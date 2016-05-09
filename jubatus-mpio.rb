class JubatusMpio < Formula
  url 'http://download.jubat.us/files/source/jubatus_mpio/jubatus_mpio-0.4.5.tar.gz'
  head 'https://github.com/jubatus/jubatus-mpio.git'
  homepage 'https://github.com/jubatus/jubatus-mpio'
  sha256 'bc51d7c92fe6500d94d5c7be3b4b2757a37553da4247d59edc41d4abe1fdc979'
  version '0.4.5'

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
