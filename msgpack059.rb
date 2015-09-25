class Msgpack059 < Formula
  url 'https://github.com/msgpack/msgpack-c/releases/download/cpp-0.5.9/msgpack-0.5.9.tar.gz'
  head 'https://github.com/msgpack/msgpack-c.git'
  homepage 'http://msgpack.org'
  sha1 '6efcd01f30b3b6a816887e3c543c8eba6dcfcb25'
  version '0.5.9'

  keg_only 'Conflicts with msgpack in main repository.'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make'
    system 'make', 'install'
  end
end
