require 'formula'

class JubatusMsgpackRpc < Formula
  url 'http://download.jubat.us/files/source/jubatus_msgpack-rpc/jubatus_msgpack-rpc-0.4.2.tar.gz'
  head 'https://github.com/jubatus/jubatus-msgpack-rpc.git'
  homepage 'http://github.com/jubatus/jubatus-msgpack-rpc/'
  sha1 'd24d43678c5d468ebad0dbb229df1c30a9de229e'
  version '0.4.2'

  depends_on 'msgpack'
  depends_on 'jubatus-mpio'
  depends_on 'libtool'

  def install
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
