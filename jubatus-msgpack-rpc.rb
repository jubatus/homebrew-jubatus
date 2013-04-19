require 'formula'

class JubatusMsgpackRpc < Formula
  url 'https://github.com/jubatus/jubatus-msgpack-rpc/tarball/0.4.1'
  head 'https://github.com/jubatus/jubatus-msgpack-rpc.git'
  homepage 'http://github.com/jubatus/jubatus-msgpack-rpc/'
  sha1 '87846ae055316fce819361c6fc64e42b621c1d62'
  version '0.4.1'

  depends_on 'msgpack'
  depends_on 'jubatus-mpio'
  depends_on 'libtool'
  depends_on 'automake'

  def install
    cd "cpp" do
      system "./bootstrap"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
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
