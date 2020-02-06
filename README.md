# Homebrew-Jubatus

A repository for Jubatus brews. This is experimental support.

## If you failed to install jubatus with Homebrew, try following command.

```bash
brew unlink msgpack
```

The above command unlinks latest msgpack-c (https://github.com/msgpack/msgpack-c/), which breaks jubatus.
We will modify jubatus to use latest msgack-c, but use old msgpack-c for now.

## How to use

	$ brew tap jubatus/jubatus
	$ brew install jubatus --use-clang

On Catalina, Please specify option `--without-fmv`.

## Configure Options

The following options are available:

* --enable-mecab: Enable mecab
* --enable-zookeeper: Enable ZooKeeper (distributed mode)
* --without-fmv: Disable optimization using function multiversioning

Example:

    $ brew install jubatus-core --use-clang --regexp-library=re2
    $ brew install jubatus --use-clang --enable-zookeeper

## Requirement

* OS version: 10.8 (Mountain Lion) or later
* Compiler: clang
