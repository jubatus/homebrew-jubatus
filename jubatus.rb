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
        ZooKeeper build was requested, but Zookeeper was already built without `--with-c` option.
        You will need to `brew uninstall zookeeper; brew install zookeeper --with-c` first.
      EOS
    else
      <<-EOS.undent
        ZooKeeper build was requested, but Zookeeper is not installed.
        You will need to `brew install zookeeper --with-c` first.
      EOS
    end
  end
end

class Jubatus < Formula
  url 'https://github.com/jubatus/jubatus/tarball/0.6.2'
  head 'https://github.com/jubatus/jubatus.git'
  homepage 'http://jubat.us/'
  sha1 'db28f9eec062537f6ca6910ee461242d6deb641d'
  version '0.6.2'

  option 'enable-mecab', 'Enable mecab for Japanese NLP'
  option 'enable-zookeeper', 'Enable ZooDeeper for distributed environemnt'

  depends_on 'log4cxx'
  depends_on 'pkg-config'
  depends_on 'jubatus-core'
  depends_on 'jubatus-msgpack-rpc'

  depends_on ZooKeeperRequirement.new if build.include? 'enable-zookeeper'
  depends_on 'mecab' if build.include? "enable-mecab"
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

    if MacOS.version >= "10.9"
      ENV['CXXFLAGS'] = "-std=c++11 -DMP_FUNCTIONAL_STANDARD -DMP_MEMORY_STANDARD -DMP_UNORDERED_MAP_STANDARD"
    end

    STDERR.puts ENV['CC'], ENV['CXX']
    args = []
    args << "--prefix=#{prefix}"
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
