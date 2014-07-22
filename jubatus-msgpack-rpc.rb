require 'formula'

class JubatusMsgpackRpc < Formula
  url 'http://download.jubat.us/files/source/jubatus_msgpack-rpc/jubatus_msgpack-rpc-0.4.3.tar.gz'
  head 'https://github.com/jubatus/jubatus-msgpack-rpc.git'
  homepage 'http://github.com/jubatus/jubatus-msgpack-rpc/'
  sha1 '4471039dc4451e0feed428a2f10a616d7593fb88'
  version '0.4.3'

  depends_on 'msgpack'
  depends_on 'jubatus-mpio'
  depends_on 'libtool'

  def install
    if MacOS.version >= "10.9"
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
