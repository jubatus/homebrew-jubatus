class JubatusCore < Formula
  url 'https://github.com/jubatus/jubatus_core/archive/1.0.9.tar.gz'
  head 'https://github.com/jubatus/jubatus_core.git'
  homepage 'http://jubat.us/'
  sha256 '9e8ded9c883e7b3959cb244a0367b05fc8a369913f8751cd8d79df1e95fabb14'
  version '1.0.9'

  option 'regexp-library=', 'oniguruma (default), re2, or none'
  @@regexp_library = ARGV.value('regexp-library')
  if @@regexp_library.nil?
    @@regexp_library = 'oniguruma'
  end

  depends_on 'pkg-config' => :build
  depends_on 'msgpack059'

  depends_on 'oniguruma' if @@regexp_library == 'oniguruma'
  depends_on 're2' if @@regexp_library == 're2'
  # snow leopard default gcc version is 4.2
  depends_on 'gcc' if build.include? 'snow-leopard'

  def install
    if MacOS.version >= :mavericks
      ENV['CXXFLAGS'] = '-std=c++11'
    end
    system './waf', 'configure', "--prefix=#{prefix}", "--regexp-library=#{@@regexp_library}"
    system './waf'
    system './waf', 'install'
  end
end
