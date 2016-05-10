class Msgpack059 < Formula
  url 'https://github.com/msgpack/msgpack-c/releases/download/cpp-0.5.9/msgpack-0.5.9.tar.gz'
  head 'https://github.com/msgpack/msgpack-c.git'
  homepage 'http://msgpack.org'
  sha256 '6139614b4142df3773d74e9d9a4dbb6dd0430103cfa7b083e723cde0ec1e7fdd'
  version '0.5.9'

  keg_only 'Conflicts with msgpack in main repository.'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make'
    system 'make', 'install'
  end
end
