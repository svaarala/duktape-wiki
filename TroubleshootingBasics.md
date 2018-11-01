# Troubleshooting basics

When you encounter unexpected issues like your application crashing when
Duktape is initialized, some basic steps to diagnose the issue:

* Enable assertions with `-DDUK_USE_ASSERTIONS` given to tools/configure.py.

* Enable debug prints, see
  [How to enable debug prints](HowtoDebugPrints.md).

* If possible, run with valgrind or some other memory checker to rule out
  any obvious memory corruption issues.

* If you're using a custom Duktape configuration, try to use the default
  configuration (if possible).  If that works, try to pin down the problem
  to a specific configuration option.

* If you're running with a custom/embedded libc, ensure that your math
  support is fully IEEE compliant.  In particular, if you need replacements
  for missing math functions, check that at least the following work
  correctly (these are used by Duktape internals, not just the `Math`
  built-in):

  - fmod()
  - floor()
