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
        You will need to `brew uninstall zookeeper; brew install zookeeper` first.
      EOS
    else
      <<-EOS.undent
        ZooKeeper build was requested, but Zookeeper is not installed.
        You will need to `brew install zookeeper` first.
      EOS
    end
  end
end

class Jubatus < Formula
  url 'https://github.com/jubatus/jubatus/tarball/0.6.4'
  head 'https://github.com/jubatus/jubatus.git'
  homepage 'http://jubat.us/'
  sha1 '6b930717c9140b0e052dff55ee60c2308ad5f913'
  version '0.6.4'

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
      gcc_version = '4.7'

      if File.exist?(gcc.bin)
        ENV['CC'] = "#{gcc.bin.to_s}/gcc-#{gcc_version}"
        ENV['LD'] = "#{gcc.bin.to_s}/gcc-#{gcc_version}"
        ENV['CXX'] ="#{gcc.bin.to_s}/g++-#{gcc_version}"
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

    # waf versoin 1.6.4 is does not support OS X install_name option.
    %w{
      libjubaserv_common
      libjubaserv_common_mprpc
      libjubaserv_framework
      libjubaserv_fv_converter
      libjubaserv_mixer
    }.each do |f|
      %w{
        server/common/logger/libjubaserv_common_logger
        server/common/libjubaserv_common
        server/common/mprpc/libjubaserv_common_mprpc
        server/framework/mixer/libjubaserv_mixer
      }.each do |l|
        system "chmod", "644", "#{lib}/#{f}.#{version}.dylib"
        system "install_name_tool", "-change",
            "#{buildpath}/build/jubatus/#{l}.dylib",
            "#{lib}/#{Pathname.new(l).basename}.dylib",
            "#{lib}/#{f}.#{version}.dylib"
        system "chmod", "444", "#{lib}/#{f}.#{version}.dylib"
      end
    end

    %w{
      jubaanomaly
      jubaburst
      jubaclassifier
      jubaclustering
      jubaconv
      jubagraph
      jubanearest_neighbor
      jubarecommender
      jubaregression
      jubastat
    }.each do |f|
      %w{
        server/framework/libjubaserv_framework
        server/framework/mixer/libjubaserv_mixer
        server/common/logger/libjubaserv_common_logger
        server/common/libjubaserv_common
        server/common/mprpc/libjubaserv_common_mprpc
        server/fv_converter/libjubaserv_fv_converter
      }.each do |l|
        system "install_name_tool", "-change",
            "#{buildpath}/build/jubatus/#{l}.dylib",
            "#{lib}/#{Pathname.new(l).basename}.dylib",
            "#{bin}/#{f}"
      end
    end
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
