require 'formula'

class JubatusMpio < Formula
  url 'http://download.jubat.us/files/source/jubatus_mpio/jubatus_mpio-0.4.2.tar.gz'
  head 'https://github.com/jubatus/jubatus-mpio.git'
  homepage 'https://github.com/jubatus/jubatus-mpio'
  sha1 'e68d0777b28461a30a3612f9f5f1b4aa9408ac6c'
  version '0.4.2'

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
