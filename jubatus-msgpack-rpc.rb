class JubatusMsgpackRpc < Formula
  url 'http://download.jubat.us/files/source/jubatus_msgpack-rpc/jubatus_msgpack-rpc-0.4.4.tar.gz'
  head 'https://github.com/jubatus/jubatus-msgpack-rpc.git'
  homepage 'http://github.com/jubatus/jubatus-msgpack-rpc/'
  sha256 'b454fda0261a5aa9b34ef78902a7c0215e3d317501507f27613b4ff9973aac60'
  version '0.4.4'

  depends_on 'msgpack059'
  depends_on 'jubatus-mpio'
  depends_on 'libtool' => :build

  def install
    if MacOS.version >= :mavericks
      ENV['CXXFLAGS'] = '-std=c++11 -DMP_FUNCTIONAL_STANDARD -DMP_MEMORY_STANDARD -DMP_UNORDERED_MAP_STANDARD'
    end
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test pficommon`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
