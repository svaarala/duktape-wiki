# How to run on bare metal platforms

A bare metal platform usually runs a minimal real-time operating system (RTOS)
or no conventional operating system at all.  Usual services like paging, memory
allocation primitives, a file system, etc may not be available at all.  There
may not even be an interrupt handler, with all code running in a busy polled
bit banging loop.  There is usually no libc or only parts (often noncompliant)
of one.

Duktape has been designed to run on bare metal targets: platform dependencies
have been carefully minimized, and all access to platform functions goes
through wrapper macros defined in `duk_config.h`.  As such they can be easily
replaced with custom providers.

This document discusses the usual issues in compiling and running Duktape on
a bare metal target.  See also:

* https://github.com/svaarala/duktape/blob/master/doc/low-memory.rst

## Footprint expectations

Duktape configuration options affect the final footprint a great deal.  The
following configuration compiles to around 160kB on an ARM platform, and can
run (very minimally) with 32kB RAM.

* A minimal RTOS.

* Duktape with a minimal ES5-based low memory configuration, with RegExps,
  coroutines, etc disabled.  Transcendental Math functions like `sin()`
  disabled to avoid related large libc code.  Custom Date provider.

* A minimal s(n)printf() and sscanf() replacement to avoid large libc
  implementations: https://github.com/svaarala/duktape/tree/master/extras/minimal-printf.

* A simple pool allocator:
  https://github.com/svaarala/duktape/tree/master/extras/alloc-pool.

* `setjmp()`, `longjmp()`, and various odds and ends provided by a third party
  libc implementation.

* A few native bindings, e.g. serial read/write bindings, LED flashing.

## Typical porting steps

### Configuration and duk_config.h

* Use `tools/configure.py` to create a custom configuration.  The low memory
  configuration in https://github.com/svaarala/duktape/blob/master/config/examples/low_memory.yaml
  is a reasonable starting point.

* Use the YAML config format to provide custom tweaks to Duktape configuration.

* Use a fixup header to redefine platform functions which don't exist or need
  to be avoided.  For example:

  ```
  #undef DUK_FLOOR
  #define DUK_FLOOR my_floor_replacement
  ```

* Use the fixup header to provide declarations for the custom replacements so
  that Duktape compilation knows their prototype:

  ```
  extern double my_floor_replacement(double x);
  ```

* If standard headers are not available, you may need to edit `duk_config.h`
  to remove offending `#include` lines.  You can achieve this more cleanly
  by adding a custom platform to `genconfig` and creating a `duk_config.h`
  for that specific platform.

* The Date built-in very often needs to be replaced, see:

  - https://github.com/svaarala/duktape/blob/master/doc/datetime.rst#implementing-an-external-date-provider

  - https://github.com/svaarala/duktape/tree/master/examples/dummy-date-provider

### Compiling

This is obviously compiler specific, but it's important to use options that
minimize footprint, remove any unused functions in final linking, etc.  See
for example:

* https://github.com/svaarala/duktape/blob/master/doc/low-memory.rst#optimizing-code-footprint
