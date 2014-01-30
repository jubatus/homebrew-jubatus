require 'formula'

class ZooKeeperRequirement < Requirement
  def initialize
    super
    @zk = Formula.factory('zookeeper')
  end

  def fatal?
    true
  end

  def satisfied?
    @zk.installed? and File.exist?(@zk.lib + 'libzookeeper_mt.dylib')
  end

  def message
    return nil if satisfied?
    if @zk.installed?
      <<-EOS.undent
        ZooKeeper build was requested, but Zookeeper was already built without `--c` option.
        You will need to `brew uninstall zookeeper; brew install zookeeper --c` first.
      EOS
    else
      <<-EOS.undent
        ZooKeeper build was requested, but Zookeeper is not installed.
        You will need to `brew install zookeeper --c` first.
      EOS
    end
  end
end

class Jubatus < Formula

  # Mavericks is not supported
  if MacOS.version >= "10.9"
    onoe "Jubatus does not support Mavericks OSX 10.9 or later version"
    exit 1
  end

  url 'https://github.com/jubatus/jubatus/tarball/0.5.1'
  head 'https://github.com/jubatus/jubatus.git'
  homepage 'http://jubat.us/'
  sha1 '25108d2d3659865865b5c4d150c3755deed42d08'
  version '0.5.1'

  option 'disable-onig', 'Disable oniguruma for regex'
  option 'enable-mecab', 'Enable mecab for Japanese NLP'
  option 'enable-zookeeper', 'Enable ZooDeeper for distributed environemnt'

  depends_on 'glog'
  depends_on 'pkg-config'
  depends_on 'jubatus-msgpack-rpc'

  depends_on ZooKeeperRequirement.new if build.include? 'enable-zookeeper'
  depends_on 'mecab' if build.include? "enable-mecab"
  depends_on 'oniguruma' unless build.include? "disable-onig"
  # snow leopard default gcc version is 4.2
  depends_on 'gcc' if build.include? 'snow-leopard'

  def install
    if ENV.compiler == :gcc
      gcc = Formula.factory('gcc')
      version = '4.7'

      if File.exist?(gcc.bin)
        bin = gcc.bin.to_s
        ENV['CC'] = bin+"/gcc-#{version}"
        ENV['LD'] = bin+"/gcc-#{version}"
        ENV['CXX'] = bin+"/g++-#{version}"
      end
    end

    STDERR.puts ENV['CC'], ENV['CXX']
    args = []
    args << "--prefix=#{prefix}"
    args << "--disable-onig" if build.include? "disable-onig"
    args << "--enable-mecab" if build.include? "enable-mecab"
    args << "--enable-zookeeper" if build.include? "enable-zookeeper"
    system "./waf", "configure", *args
    system "./waf", "build"
    system "./waf", "install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test jubatus`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
