# Homebrew-Jubatus

A repository for Jubatus brews. This is experimental support.

## How to use

	$ brew tap jubatus/jubatus
	$ brew install jubatus --use-clang

## Configure Options

The following options are available:

* --enable-mecab: Enable mecab
* --enable-zookeeper: Enable ZooKeeper (distributed mode)

Example:

    $ brew install jubatus --use-clang --disable-onig --enable-zookeeper

## Requirement

* OS version: 10.8 (Mountain Lion) or later
* Compiler: clang
