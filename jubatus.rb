class ZooKeeperRequirement < Requirement
  def initialize
    super
    @zk = Formula['zookeeper']
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
        ZooKeeper build was requested, but ZooKeeper was already built without `--c` option.
        You will need to `brew uninstall zookeeper; brew install zookeeper` first.
      EOS
    else
      <<-EOS.undent
        ZooKeeper build was requested, but ZooKeeper is not installed.
        You will need to `brew install zookeeper` first.
      EOS
    end
  end
end

class Jubatus < Formula
  url 'https://github.com/jubatus/jubatus/tarball/0.8.2'
  head 'https://github.com/jubatus/jubatus.git'
  homepage 'http://jubat.us/'
  sha1 'e94673f44bb6fbc66aa0132aa04354812d7a5de7'
  version '0.8.2'

  option 'enable-mecab', 'Enable mecab for Japanese NLP'
  option 'enable-zookeeper', 'Enable ZooKeeper for distributed environemnt'

  depends_on 'log4cxx'
  depends_on 'pkg-config' => :build
  depends_on 'jubatus-core'
  depends_on 'jubatus-msgpack-rpc'

  depends_on ZooKeeperRequirement.new if build.include? 'enable-zookeeper'
  depends_on 'mecab' if build.include? "enable-mecab"
  # snow leopard default gcc version is 4.2
  depends_on 'gcc' if build.include? 'snow-leopard'

  def install
    if ENV.compiler == :gcc
      gcc = Formula['gcc']
      version = '4.7'

      if File.exist?(gcc.bin)
        bin = gcc.bin.to_s
        ENV['CC'] = bin+"/gcc-#{version}"
        ENV['LD'] = bin+"/gcc-#{version}"
        ENV['CXX'] = bin+"/g++-#{version}"
      end
    end

    if MacOS.version >= :mavericks
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
