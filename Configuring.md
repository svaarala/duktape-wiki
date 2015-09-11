# Configuring Duktape for build

## Duktape 1.2

In Duktape 1.2 Duktape features are configured through feature options:

* If defaults are acceptable, compile Duktape as is.  For example:

  ```
  $ gcc -std=c99 -Os -o hello -Isrc src/duktape.c hello.c -lm
  ```

* Otherwise use `DUK_OPT_xxx` feature options on the compiler command line
  when compiling both Duktape and your application (if they're compiled
  separately).  For example:

  ```
  $ gcc -std=c99 -Os -o hello -Isrc -DDUK_OPT_FASTINT \
          src/duktape.c hello.c -lm
  ```

  For available feature options, see:
  https://github.com/svaarala/duktape/blob/master/doc/feature-options.rst

* When compiling Duktape as a Windows DLL, you must define `DUK_OPT_DLL_BUILD`
  for both Duktape and application build.  For example:

  ```
  > cl /O2 /W3 /DDUK_OPT_DLL_BUILD /Isrc /LD src\duktape.c
  > cl /O2 /W3 /DDUK_OPT_DLL_BUILD /Fehello.exe /Isrc hello.c duktape.lib
  > hello.exe
  ```

The table below summarizes the most commonly needed feature options, in no
particular order:

<table>
<thead>
<tr>
<th>Define</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>DUK_OPT_DLL_BUILD</td>
<td>Build Duktape as a DLL, affects symbol visibility declarations.
    Most concretely, enables <code>__declspec(dllexport)</code> and
    <code>__declspec(dllimport)</code> on Windows builds.  This option
    must be used also for application build when Duktape is linked as
    a DLL (otherwise <code>__declspec(dllimport)</code> won't be used).</td>
</tr>
<tr>
<td>DUK_OPT_NO_PACKED_TVAL</td>
<td>Don't use the packed 8-byte internal value representation even if otherwise
    possible.  The packed representation has more platform/compiler portability
    issues than the unpacked one.</td>
</tr>
<tr>
<td>DUK_OPT_FORCE_ALIGN</td>
<td>Use <code>-DDUK_OPT_FORCE_ALIGN=4</code> or <code>-DDUK_OPT_FORCE_ALIGN=8</code>
    to force a specific struct/value alignment instead of relying on Duktape's
    automatic detection.  This shouldn't normally be needed.</td>
</tr>
<tr>
<td>DUK_OPT_FORCE_BYTEORDER</td>
<td>Use this to skip byte order detection and force a specific byte order:
    <code>1</code> for little endian, <code>2</code> for ARM "mixed" endian
    (integers little endian, IEEE doubles mixed endian), <code>3</code> for
    big endian.  Byte order detection relies on unstandardized platform
    specific header files, so this may be required for custom platforms if
    compilation fails in endianness detection.</td>
</tr>
<tr>
<td>DUK_OPT_NO_REFERENCE_COUNTING</td>
<td>Disable reference counting and use only mark-and-sweep for garbage collection.
    Although this reduces memory footprint of heap objects, the downside is much
    more fluctuation in memory usage.</td>
</tr>
<tr>
<td>DUK_OPT_NO_MARK_AND_SWEEP</td>
<td>Disable mark-and-sweep and use only reference counting for garbage collection.
    This reduces code footprint and eliminates garbage collection pauses, but
    objects participating in unreachable reference cycles won't be collected until
    the Duktape heap is destroyed.  In particular, function instances won't be
    collected because they're always in a reference cycle with their default
    prototype object.  Unreachable objects are collected if you break reference
    cycles manually (and are always freed when a heap is destroyed).</td>
</tr>
<tr>
<td>DUK_OPT_NO_VOLUNTARY_GC</td>
<td>Disable voluntary periodic mark-and-sweep collection.  A mark-and-sweep
    collection is still triggered in an out-of-memory condition.  This option
    should usually be combined with reference counting, which collects all
    non-cyclical garbage.  Application code should also request an explicit
    garbage collection from time to time when appropriate.  When this option
    is used, Duktape will have no garbage collection pauses in ordinary use,
    which is useful for timing sensitive applications like games.</td>
</tr>
<tr>
<td>DUK_OPT_TRACEBACK_DEPTH</td>
<td>Override default traceback collection depth.  The default is currently 10.</td>
</tr>
<tr>
<td>DUK_OPT_NO_FILE_IO</td>
<td>Disable use of ANSI C file I/O which might be a portability issue on some
    platforms.  Causes <code>duk_eval_file()</code> to throw an error,
    makes built-in <code>print()</code> and <code>alert()</code> no-ops,
    and suppresses writing of a panic message to <code>stderr</code> on panic.
    This option does not suppress debug printing so don't enable debug printing
    if you wish to avoid I/O.</td>
</tr>
<tr>
<td>DUK_OPT_PANIC_HANDLER(code,msg)</td>
<td>Provide a custom panic handler, see detailed description below.</td>
</tr>
<tr>
<td>DUK_OPT_SELF_TESTS</td>
<td>Perform run-time self tests when a Duktape heap is created.  Catches
    platform/compiler problems which cannot be reliably detected during
    compile time.  Not enabled by default because of the extra footprint.</td>
</tr>
<tr>
<td>DUK_OPT_ASSERTIONS</td>
<td>Enable internal assert checks.  These slow down execution considerably
    so only use when debugging.</td>
</tr>
</tbody>
</table>

## Duktape 1.3

In Duktape 1.3 there are three supported ways of configuring Duktape features
for build:

* Use the `duk_config.h` in the distributable (`src/duk_config.h` or
  `src-separate/duk_config.h`).  If default features are not desirable,
  provide `DUK_OPT_xxx` feature options when compiling both Duktape and
  the application.  This matches Duktape 1.2, but there's an external
  `duk_config.h` header:

  ```
  # src/ contains default duk_config.h (comes with distributable)
  $ gcc -std=c99 -Os -o hello -Isrc -DDUK_OPT_FASTINT \
          src/duktape.c hello.c -lm
  ```

* Generate a new autodetect `duk_config.h` using `genconfig` with config
  option overrides given either on the command line or in YAML/header
  files.  For example, to enable fastint support and to disable
  bufferobjects:

  ```
  $ sudo apt-get install python-yaml

  $ python config/genconfig.py \
          --metadata config/genconfig_metadata.tar.gz \
          --output myinclude/duk_config.h \
          -DDUK_USE_FASTINT \
          -UDUK_USE_BUFFEROBJECT_SUPPORT \
          autodetect-header

  # Ensure myinclude/duk_config.h comes first in include path.
  $ gcc -std=c99 -Os -o hello -Imyinclude -Isrc \
          src/duktape.c hello.c -lm
  ```

  There are several alternatives to defining option overrides, see:
  https://github.com/svaarala/duktape/blob/master/doc/duk-config.rst#genconfig-option-overrides

  NOTE: config options (`DUK_USE_xxx`) used to be Duktape internal, and are
  being cleaned up after Duktape 1.3 release.  Some config options may change
  in Duktape 1.4.

* Edit `duk_config.h` manually.  This is a bit messy but allows everything
  to be modified, e.g. typedefs and `#include` directives.

## Duktape 1.4 (planned)

In Duktape 1.4 the `DUK_OPT_xxx` options will be removed and configuration
is done only through `genconfig` and `DUK_USE_xxx` config options.  This
removes one level of indirection and avoids compiler command line defines
entirely, but requires build scripts to run `genconfig` if the default
options are not desirable.
