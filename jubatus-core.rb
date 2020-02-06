class JubatusCore < Formula
  url 'https://github.com/jubatus/jubatus_core/archive/1.1.1.tar.gz'
  head 'https://github.com/jubatus/jubatus_core.git'
  homepage 'http://jubat.us/'
  sha256 'bcfb6240f41275bcd6626c9fa1ad13a272e96d60759b6aa69a482aec020cc27b'
  version '1.1.1'

  option 'regexp-library=', 'oniguruma (default), re2, or none'
  @@regexp_library = ARGV.value('regexp-library')
  if @@regexp_library.nil?
    @@regexp_library = 'oniguruma'
  end
  option 'without-fmv', 'Disable optimization using function multiversioning'

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
    args = []
    args << '--disable-fmv' if build.without? "fmv"
    system './waf', 'configure', "--prefix=#{prefix}", "--regexp-library=#{@@regexp_library}", *args
    system './waf'
    system './waf', 'install'
  end
end
