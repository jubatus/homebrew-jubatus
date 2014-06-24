require 'formula'

class JubatusCore < Formula
  url 'https://github.com/jubatus/jubatus_core/tarball/0.0.1'
  head 'https://github.com/jubatus/jubatus_core.git'
  homepage 'http://jubat.us/'
  sha1 '74fd956f6e61fbf8de1f5aad4f8e8461c7e81e9f'
  version '0.0.1'

  option 'regexp-library=', 'oniguruma (default), re2, or none'
  @@regexp_library = ARGV.value('regexp-library')
  if @@regexp_library.nil?
    @@regexp_library = 'oniguruma'
  end

  depends_on 'pkg-config'

  depends_on 'oniguruma' if @@regexp_library == 'oniguruma'
  # snow leopard default gcc version is 4.2
  depends_on 'gcc' if build.include? 'snow-leopard'

  def install
    if MacOS.version >= "10.9"
      ENV['CXXFLAGS'] = '-std=c++11'
    end
    system './waf', 'configure', "--prefix=#{prefix}", "--regexp-library=#{@@regexp_library}"
    system './waf'
    system './waf', 'install'
  end
end
