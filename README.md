# Homebrew-Jubatus

A repository for Jubatus brews.

## How to use

	$ brew tap jubatus/jubatus
	$ brew install --HEAD pficommon
	$ brew install jubatus

## Configure Options

The following options are available:

* --prefix=PATH: Installation path
* --disable-re2: Disable re2 (regex library)
* --enable-mecab: Disable mecab
* --enable-zookeeper: Disable ZooKeeper (distributed mode)

Example:

    $ brew install jubatus --disable-re2 --enable-zookeeper
