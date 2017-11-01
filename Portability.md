# Portability

## Platforms and compilers

The table below summarizes the platforms and compilers which Duktape is known
to work on, with portability notes where appropriate.  This is **not an exhaustive list**
of supported/unsupported platforms, rather a list of what is known to work
(and not to work).  Platform and compiler specific issues are discussed in more
detail below the table.

<table>
<thead>
<tr>
<th>Operating system</th>
<th>Compiler</th>
<th>Processor</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>Linux</td>
<td>GCC</td>
<td>x86</td>
<td>No known issues.</td>
</tr>
<tr>
<td>Linux</td>
<td>GCC</td>
<td>x64</td>
<td>No known issues.</td>
</tr>
<tr>
<td>Linux</td>
<td>GCC</td>
<td>x32</td>
<td>No known issues, use <code>-mx32</code>.</td>
</tr>
<tr>
<td>Linux</td>
<td>GCC</td>
<td>ARM</td>
<td>No known issues.</td>
</tr>
<tr>
<td>Linux</td>
<td>GCC</td>
<td>MIPS</td>
<td>No known issues.</td>
</tr>
<tr>
<td>Linux</td>
<td>GCC</td>
<td>SuperH</td>
<td>No known issues.</td>
</tr>
<tr>
<td>Linux</td>
<td>GCC</td>
<td>SPARC</td>
<td>No known issues.</td>
</tr>
<tr>
<td>Linux</td>
<td>Clang</td>
<td>x86</td>
<td>No known issues.</td>
</tr>
<tr>
<td>Linux</td>
<td>Clang</td>
<td>x64</td>
<td>No known issues.</td>
</tr>
<tr>
<td>Linux</td>
<td>Clang</td>
<td>ARM</td>
<td>No known issues.</td>
</tr>
<tr>
<td>Linux</td>
<td>Clang</td>
<td>MIPS</td>
<td>No known issues.</td>
</tr>
<tr>
<td>Linux</td>
<td>TCC</td>
<td>x64</td>
<td>Zero sign issues (see below).</td>
</tr>
<tr>
<td>FreeBSD</td>
<td>Clang</td>
<td>x86</td>
<td>Aliasing issues with clang 3.3 on 64-bit FreeBSD, <code>-m32</code>, and packed <code>duk_tval</code> (see below).</td>
</tr>
<tr>
<td>FreeBSD</td>
<td>Clang</td>
<td>x64</td>
<td>No known issues.</td>
</tr>
<tr>
<td>NetBSD</td>
<td>GCC</td>
<td>x86</td>
<td>No known issues (NetBSD 6.0).  There are some <code>pow()</code> function incompatibilities on NetBSD, but
    there is a workaround for them.</td>
</tr>
<tr>
<td>OpenBSD</td>
<td>GCC</td>
<td>x86</td>
<td>No known issues (OpenBSD 5.4).</td>
</tr>
<tr>
<td>Windows</td>
<td>MinGW</td>
<td>x86</td>
<td><code>-std=c99</code> recommended, only ISO 8601 date format supported (no platform specific format).</td>
</tr>
<tr>
<td>Windows</td>
<td>MinGW-w64</td>
<td>x64</td>
<td><code>-m64</code>, <code>-std=c99</code> recommended, only ISO 8601 date format supported (no platform specific format).</td>
</tr>
<tr>
<td>Windows</td>
<td>MSVC<br />(Visual Studio Express 2010)</td>
<td>x86</td>
<td>Only ISO 8601 date format supported (no platform specific format).
    Harmless warnings if <code>/Wp64</code> is enabled.</td>
</tr>
<tr>
<td>Windows</td>
<td>MSVC<br />(Visual Studio Express 2013 for Windows Desktop)</td>
<td>x64</td>
<td>Only ISO 8601 date format supported (no platform specific format).</td>
</tr>
<tr>
<td>Windows</td>
<td>MSVC<br />(Visual Studio 2010)</td>
<td>x64</td>
<td>Only ISO 8601 date format supported (no platform specific format).
    May require explicit <code>DUK_OPT_NO_PACKED_TVAL</code> with
    Duktape 0.10.0.</td>
</tr>
<tr>
<td>Android</td>
<td>GCC<br />(Android NDK)</td>
<td>ARM</td>
<td><code>-std=c99</code> required at least on some NDK versions.</td>
</tr>
<tr>
<td>OSX</td>
<td>Clang</td>
<td>x64</td>
<td>Tested on OSX 10.9.2 with XCode.</td>
</tr>
<tr>
<td>Darwin</td>
<td>GCC</td>
<td>x86</td>
<td>No known issues.</td>
</tr>
<tr>
<td>QNX</td>
<td>GCC</td>
<td>x86</td>
<td><code>-std=c99</code> recommended.  Architectures other than x86 should also work.</td>
</tr>
<tr>
<td>AmigaOS</td>
<td>VBCC</td>
<td>M68K</td>
<td>Requires some preprocessor defines, datetime resolution limited to full seconds.</td>
</tr>
<tr>
<td>TOS<br />(Atari ST)</td>
<td>VBCC</td>
<td>M68K</td>
<td>Requires some preprocessor defines, datetime resolution limited to full seconds.</td>
</tr>
<tr>
<td>RISC OS</td>
<td>GCC</td>
<td>ARM</td>
<td>No known issues.</td>
</tr>
<tr>
<td>Emscripten</td>
<td>Emscripten</td>
<td>n/a</td>
<td>Requires additional options, see below. At least V8/NodeJs works.</td>
</tr>
<tr>
<td>Adobe Flash Runtime</td>
<td>CrossBridge<br />(GCC-4.2 with Flash backend)</td>
<td>n/a</td>
<td><code>-std=c99</code> recommended, may need <code>-jvmopt=-Xmx1G</code> if running
    32-bit Java.  Tested with <a href="http://adobe-flash.github.io/crossbridge/">CrossBridge</a>
    1.0.1 on 64-bit Windows 7.</td>
</tr>
<tr>
<td>pNaCl</td>
<td>clang</td>
<td>n/a</td>
<td>No known issues.</td>
</tr>
<tr>
<td>Linux</td>
<td>BCC<br />(Bruce's C compiler)</td>
<td>i386</td>
<td><code>-3</code> and <code>-ansi</code> required; compiles but doesn't link.  This is an
    old compiler useful for portability torture tests (for instance 16-bit <code>int</code> type).</td>
</tr>
</tbody>
</table>

### Clang

Clang 3.3 on FreeBSD has some aliasing issues (at least) when using
`-m32` and when Duktape ends up using a packed `duk_tval` value representation
type.  You can work around the problem by defining `DUK_OPT_NO_PACKED_TVAL` to
disable packed value type.  The problem does not appear in all clang versions.
Duktape self tests cover this issue (define `DUK_OPT_SELF_TESTS` when compiling.
See internal test file [clang_aliasing.c](https://github.com/svaarala/duktape/blob/master/misc/clang_aliasing.c).

### MSVC

The [/Wp64 (Detect 64-bit Portability Issues)](http://msdn.microsoft.com/en-us/library/yt4xw8fh.aspx)
option causes harmless compile warnings when compiling 32-bit code, e.g.:

```
duk_api.c(2419): warning C4311: 'type cast' : pointer truncation from 'duk_hstring *' to 'duk_uint32_t'
```

The warnings are caused by Duktape casting 32-bit pointers to 32-bit integers
used by its internal value representation.  These casts would be incorrect in
a 64-bit environment which is reported by the `/Wp64` option.  When Duktape is
compiled in a 64-bit environment a different value representation is used which
doesn't use these casts at all, so the warnings are not relevant.

Compilation with `/Wall` is not clean at the moment.

### TCC

TCC has zero sign handling issues; Duktape mostly works but zero sign is
not handled correctly.  This results in Ecmascript non-compliance, for
instance `1/-0` evaluates to `Infinity`, not `-Infinity` as it should.

### VBCC (AmigaOS / TOS)

VBCC doesn't appear to provide OS or processor defines.  To compile for
M68K AmigaOS or TOS you must:

* Define `__MC68K__` manually.

* Define either `AMIGA` or `__TOS__` manually.

Datetime resolution is limited to full seconds only when using VBCC on
AmigaOS or TOS.

### Emscripten

Needs a set of `emcc` options.  When executed with V8, the following
seem to work:</p>

* `-DEMSCRIPTEN`: **mandatory option**, needed by Duktape to detect
  Emscripten.  Without this Duktape may use unaligned accesses which
  Emscripten does not allow.  This results in odd and inconsistent
  behavior, and is not necessarily caught by Duktape self tests.

* `-std=c99`

* `-O2`

* `--memory-init-file 0`

Dukweb is compiled using Emscripten, so you can also check out the Duktape
git repository to see how Dukweb is compiled.

## Limitations

* Pointer less-than/greater-than comparisons are expected to work like
  pointers were unsigned.  This is incorrect on some platforms.

* [Two's complement](http://en.wikipedia.org/wiki/Two's_complement) signed
  arithmetic is required.  This is not technically guaranteed by ANSI C,
  but there are very few environments where this assumption does not hold.

* IEEE behavior is assumed for <code>float</code> and <code>double</code>
  types.  This means e.g. gcc <code>-ffast-math</code>
  (see https://gcc.gnu.org/wiki/FloatingPointMath) is not supported.
  Duktape also works directly with IEEE float and double memory
  representations.

* ASCII is assumed, Duktape doesn't currently work on e.g. EBCDIC platforms.

## Troubleshooting

* Compile in C mode if possible.  Although C++ compilation now works,
  it isn't as portable as C compilation.

* Enable C99 mode if possible (`-std=c99` or similar).  Type detection
  without C99 is less reliable than with C99.  Duktape also relies on
  (v)snprintf() which are C99/POSIX; there's a fill-in for MSVC but for
  other non-C99 platforms you may need to define `DUK_SNPRINTF()` and
  `DUK_VSNPRINTF()` manually in your `duk_config.h` header.

* If Duktape compiles but doesn't seem to work correctly, enable
  self tests with `DUK_OPT_SELF_TESTS`.  Self tests detect some compiler
  and platform issues which cannot be caught compile time.

* If the target platform has specific alignment requirements and Duktape
  doesn't autodetect the platform correctly, you may need to provide
  either `DUK_OPT_FORCE_ALIGN=4` or `DUK_OPT_FORCE_ALIGN=8`.  The alignment
  number should match whatever alignment is needed for IEEE doubles and
  64-bit integer values.

* If compilation fails in endianness detection, Duktape probably doesn't
  (yet) support the platform specific endianness headers of your platform.
  Such headers are unfortunately non-standardized, so endianness detection
  is a common (and usually trivial) portability issue on custom platforms.
  Use `DUK_OPT_FORCE_BYTEORDER` to force endianness as a workaround.
  If you know how the endianness detection should work on your platform,
  please send an e-mail about the issue or contribute a patch.

* Another typical portability issue on new/exotic platforms is the Date
  built-in, which requires a few platform specific functions for dealing
  with date and time.  Often existing Date functions are sufficient but
  if they're not, you can implement an external "Date provider" which
  requires no Duktape changes, see:
  [datetime.rst](https://github.com/svaarala/duktape/blob/master/doc/datetime.rst).

* Some exotic platforms have broken double-to-integer or integer-to-double
  casts, which causes e.g. https://github.com/svaarala/duktape/issues/336.
  At the moment there's no easy workaround because casts are used inside
  Duktape in several places.  A possible future fix is to use macros for such
  casts, so that you can fix the casts in a platform dependent manner and edit
  `duk_config.h` to provide working casting macros.

* Since Duktape 1.3 almost all portability related includes and defines are
  in an external [duk_config.h](https://github.com/svaarala/duktape/blob/master/doc/duk-config.rst)
  header which you can modify freely to suit exotic platforms.
