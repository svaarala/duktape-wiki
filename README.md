Duktape Wiki
============

[![Build Status](https://travis-ci.org/svaarala/duktape-wiki.svg?branch=master)](https://travis-ci.org/svaarala/duktape-wiki)

This is the repo for the official Duktape Wiki, <http://wiki.duktape.org/>.

Duktape Wiki is edited in the [duktape-wiki](https://github.com/svaarala/duktape-wiki)
repo, using pull requests to make edits.  The Wiki is built into static HTML files
using [pandoc](http://pandoc.org/) and hosted on
[wiki.duktape.org](http://wiki.duktape.org)).  Some pages are generated
from outside sources, e.g. `ConfigOptions` page is generated using
[genconfig.py](https://github.com/svaarala/duktape/blob/master/tools/genconfig.py)
(developed in the Duktape main repo).

There's a minimal build script `build_pandoc.sh` in this directory; it's not
used directly by the server but documents what's going on in the server side.

Installation issues
-------------------

Random notes on installation:

* Python2 is required.

* Run `sudo apt install pandoc`.

* Web server should redirect `/index.html` to `Home.html`.

License
-------

Duktape Wiki is part of Duktape documentation and under the
[Duktape MIT license](https://github.com/svaarala/duktape/blob/master/LICENSE.txt).
When contributing to the Duktape Wiki you agree to license your contribution
under this license.

Before contributing to the Wiki, create a pull request into the Duktape main
repository to include your name in the
[AUTHORS.rst](https://github.com/svaarala/duktape/blob/master/AUTHORS.rst),
under "Authors".

Contributing
------------

See [CONTRIBUTING.md](https://github.com/svaarala/duktape-wiki/blob/master/CONTRIBUTING.md).
