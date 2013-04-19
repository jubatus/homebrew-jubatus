require 'formula'

class JubatusMpio < Formula
  url 'https://github.com/jubatus/jubatus-mpio/tarball/0.4.2'
  head 'https://github.com/jubatus/jubatus-mpio.git'
  homepage 'https://github.com/jubatus/jubatus-mpio'
  sha1 '4b3917b7ef7e0caf5f9ae1b6cf0ceeb82f8ae9b1'
  version '0.4.2'

  depends_on 'libtool'
  depends_on 'automake'

  def install
    system "./bootstrap"
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
