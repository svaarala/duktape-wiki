Duktape Wiki
============

This is the repo for the official Duktape Wiki, http://wiki.duktape.org.

Duktape Wiki is edited in the [duktape-wiki](https://github.com/svaarala/duktape-wiki)
repo, using pull requests to make edits.  The Wiki is built into static HTML files
using [gollum-site](https://github.com/dreverri/gollum-site) and hosted on
[wiki.duktape.org](http://wiki.duktape.org)).  Some pages are generated
from outside sources, e.g. `ConfigOptions` page is generated using
[genconfig.py](https://github.com/svaarala/duktape/blob/master/config/genconfig.py)
(developed in the Duktape main repo).

There's a minimal build script `buildsite.sh` in this directory; it's not
used directly by the server but documents what's going on in the server side.

Installation issues
-------------------

Random notes on installation:

* Run `sudo gem install gollum-site`, may need:

  ```
  $ sudo apt-get install python-dev  # or python-all-dev
  $ sudo apt-get install ruby-dev    # or ruby-all-dev
  ```

* Workaround for ffi issues (needed on Ubuntu 14.04 x64):

  ```
  $ sudo ln -s /usr/lib/x86_64-linux-gnu/libpython2.7.so /usr/local/lib/libpython2.7.so.1.so
  ```

* Web server should redirect `/index.html` to `Home.html`.
