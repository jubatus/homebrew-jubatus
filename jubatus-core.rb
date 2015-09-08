require 'formula'

class JubatusCore < Formula
  url 'https://github.com/jubatus/jubatus_core/tarball/0.2.2'
  head 'https://github.com/jubatus/jubatus_core.git'
  homepage 'http://jubat.us/'
  sha1 '8ba671cd6b57f42aece8f8be2628210c56cbf64e'
  version '0.2.2'

  option 'regexp-library=', 'oniguruma (default), re2, or none'
  @@regexp_library = ARGV.value('regexp-library')
  if @@regexp_library.nil?
    @@regexp_library = 'oniguruma'
  end

  depends_on 'pkg-config'
  depends_on 'msgpack059'

  depends_on 'oniguruma' if @@regexp_library == 'oniguruma'
  depends_on 're2' if @@regexp_library == 're2'
  # snow leopard default gcc version is 4.2
  depends_on 'gcc' if build.include? 'snow-leopard'

  def install
    if MacOS.version >= "10.9"
      ENV['CXXFLAGS'] = '-std=c++11'
    end
    system './waf', 'configure', "--prefix=#{prefix}", "--regexp-library=#{@@regexp_library}"
    system './waf'
    system './waf', 'install'

    # waf versoin 1.6.4 is does not support OS X install_name option.
    %w{
      libjubatus_core
      libjubatus_util
      libjubatus_util_concurrent
      libjubatus_util_data
      libjubatus_util_lang
      libjubatus_util_math
      libjubatus_util_system
      libjubatus_util_text
    }.each do |f|
      %w{
        util/libjubatus_util
        util/concurrent/libjubatus_util_concurrent
        util/data/libjubatus_util_data
        util/lang/libjubatus_util_lang
        util/math/libjubatus_util_math
        util/system/libjubatus_util_system
        util/text/libjubatus_util_text
      }.each do |l|
        system "chmod", "644", "#{lib}/#{f}.#{version}.dylib"
        system "install_name_tool", "-change",
            "#{buildpath}/build/jubatus/#{l}.dylib",
            "#{lib}/#{Pathname.new(l).basename}.dylib",
            "#{lib}/#{f}.#{version}.dylib"
        system "chmod", "444", "#{lib}/#{f}.#{version}.dylib"
      end
    end
  end
end
