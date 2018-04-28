# Development setup

## Overview

Most application code should just use a pre-built dist package which can be
used directly with no special development setup other than including Duktape
source and headers into the application build.  There are pre-built dist
packages for:

* Official releases: <http://duktape.org/download.html>

* Snapshots from master: <http://duktape.org/snapshots/>

In some cases modifications to Duktape internals are needed; for example, a
private fork of Duktape may be used for a certain target.  It may then be
necessary to include the "make dist" step into an application build.  Or
maybe you just want to hack the internals a bit and see what happens.

This document describes the requirements for creating a dist package (Linux,
Windows, OS X) and using the Duktape top level `Makefile` (Linux only).

## Minimal setup for creating dist packages

The minimum requirements for creating a dist package are:

* A checkout of <https://github.com/svaarala/duktape> or a fork; a plain
  non-versioned directory also works.

* Python 2 with PyYAML, needed for the dist tools.

The following are optional but useful:

* Git command line tools used to get "git describe" and other version
  metadata.

* Duktape 1.x: a minifier (Closure or UglifyJS2) for some ECMAScript code
  embedded in the build.  This dependency was removed in Duktape 2.x.

After making changes to Duktape sources, metadata, etc:

```
# Use --help for option help.
$ python util/make_dist.py
```

This will create a `dist` directory which has the same contents as a pre-built
dist package such as `duktape-1.4.0.tar.xz`.  Some notes:

* The dist tar package itself is not created automatically to minimize
  dependencies.

* If you don't have Git installed, you can give the version related as command
  line options, see: `$ python util/make_dist.py --help`.

* Instead of a git clone, you can also use a plain non-versioned snapshot
  directory as long as you give the git version metadata as command line
  options.

* The optional minifier is used in Duktape 1.x for a very small ECMAScript
  initialization script (`src/duk_initjs.js`) embedded into the Duktape build.
  If you don't provide a minifier using `--minify` the script won't be
  minified.  The impact on footprint is very small, around 500 bytes.
  Duktape 2.x no longer embeds this initialization script so a minifier is
  not required.

Creating a dist package is the minimum step needed to work with a private fork
effectively.  As such, the dist process has been made quite portable and should
work on Linux, Windows (with and without Cygwin), and OS X at least, and has
minimal mandatory dependencies beyond Python 2 and PyYAML.  Note that the top
level `Makefile` is not used or needed for creating a dist package so having
"make" is not a requirement.

## When to create a dist package manually

You'll need to make a dist package when you want to:

* Modify Duktape source code or work from a private fork.

* Create a dist package from a work-in-progress branch.

* Enable some more exotic options like ROM built-ins support not enabled in
  the default dist package.

## Other development steps (Linux only)

Other development stuff, such as building the website and running test cases,
is based on a `Makefile` **intended for Linux only**.  The basic steps to use
the Makefile are:

    # Install required packages (exact packages depend on distribution)
    $ sudo apt-get install nodejs nodejs-legacy npm perl ant openjdk-7-jdk \
          libreadline6-dev libncurses-dev python-rdflib python-bs4 python-yaml \
          clang llvm bc

    # Compile the command line tool ('duk')
    $ git clone https://github.com/svaarala/duktape.git
    $ cd duktape
    $ make

    # If you want to build dukweb.js or run Emscripten targets, you need
    # to setup Emscripten fastcomp manually, see doc/emscripten-status.rst
    # for step-by-step instructions.

    # Run ECMAScript and API testcases, and some other tests
    $ make ecmatest
    $ make apitest
    $ make regfuzztest
    $ make underscoretest    # see doc/underscore-status.rst
    $ make test262test       # see doc/test262-status.rst
    $ make emscriptentest    # see doc/emscripten-status.rst
    $ make emscriptenmandelbrottest  # run Emscripten-compiled mandelbrot.c with Duktape
    $ make emscripteninceptiontest   # run Emscripten-compiled Duktape with Duktape
    $ make jsinterpretertest
    $ make luajstest
    $ make dukwebtest        # then browse to file:///tmp/dukweb-test/dukweb.html
    $ make xmldoctest
    $ make bluebirdtest
    # etc

You may get the Makefile working in OSX or Windows (using Cygwin), but this is
not supported at the moment.  Some of the Makefile targets (such as some API
testcases) make Linux specific assumptions, e.g. existence of `/tmp/`.

## Platform notes

### Ubuntu, Debian, etc

To support `make_dist.py`:

```
# Linux; can often install from packages or using 'pip'
$ sudo apt-get install python python-yaml
$ python util/make_dist.py
```

To run testcases etc, see "Other development steps (Linux only)" above.

### ArchLinux

Install necessary Python packages:

```
# python2-beautifulsoup4 and python2-rdflib are not needed for plain dist.
$ sudo pacman -S --needed python2 python2-beautifulsoup4 python2-rdflib python2-yaml
```

If you want to run testcases etc, you may need a Node.js fixup:

```
$ sudo ln -s /usr/bin/node /usr/bin/nodejs
```

Other development basics, should not be needed to build dist packages:

```
$ sudo pacman -S --needed base-devel clang llvm git bc
```

Based on:

* <https://github.com/svaarala/duktape/issues/466>

### Windows

```
; Install Python 2.7.x from python.org, and add it to PATH
> pip install PyYAML
> python util\make_dist.py
```

### OS X

```
# Install Python 2.7.x
$ pip install PyYAML
$ python util/make_dist.py
```
