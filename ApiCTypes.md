# API C types

## Overview

Duktape API uses typedef-wrapped C types such as `duk_int_t` almost
exclusively to ensure portability to exotic platforms.  This article
provides some background, summarizes the types, and describes how calling
code should use types to maximize portability.

## Guidelines for code using the Duktape API

Use Duktape types such as `duk_idx_t` and `duk_ret_t` (described below) when
declaring variables for maximum portability.  Alternatively you may use plain
types (like `int` or `long`) but your code will be less portable and you may
need to use casts to avoid warnings.  Note that `long` is a better default
integer type than `int` which may be only 16 bits wide on some platforms.

In `printf()` formatting cast Duktape types to a wide integer type and use a
standard format specifier to ensure that the type and the specifier always
match.  For integers, `long` and `unsigned long` are usually a good choice
because they don't require C99/C++11 and can usually hold all integer values
used by Duktape typedefs.  For example:

```c
printf("Result: %ld\n", (long) duk_get_int(ctx, -3));
```

Duktape API calls which support ANSI C format strings simply pass on the
format string and call arguments to the platform's `vsnprintf()` function.
To maximize portability, select format specifiers carefully and cast
arguments to ensure types match.  For example:

```c
duk_int_t val = 123;
duk_push_sprintf(ctx, "My integer: %ld", (long) val);
```

A few standard format specifiers:

<table>
<tr>
<th>Type</th>
<th>Specifier</th>
</tr>
<tr>
<td>long</td>
<td>%ld</td>
</tr>
<tr>
<td>unsigned long</td>
<td>%lu</td>
</tr>
<tr>
<td>double</td>
<td>%f or %lf for printf(), %lf for scanf()</td>
</tr>
<tr>
<td>size_t</td>
<td>%zu in C99, pre-C99 compilers have various custom specifiers</td>
</tr>
<tr>
<td>intmax_t</td>
<td>%jd in C99</td>
</tr>
<tr>
<td>uintmax_t</td>
<td>%ju in C99</td>
</tr>
</table>

Format specifiers used by `printf()` and `scanf()` may be different.  For
`scanf()`, use a standard type and a standard format code (so that you can
be certain they match), then cast to a Duktape type as necessary.  Again,
`long` and `unsigned long` are a good default choice.  For example:

```c
long val;
sscanf(my_str, "%ld", &val);
duk_push_int(ctx, (duk_int_t) val);
```

Use the `L` (or `UL`) suffix for constants which are larger than 16 bits to
maximize portability.  Like the `int` type, integer constants without a
suffix are only guaranteed to be 16 bits wide.  With the `L` suffix constants
are guaranteed to be at least 32 bits wide.  Example:

```c
duk_push_int(ctx, 1234567L);
```

Duktape 1.x API calls with a filesystem path argument simply pass the path to
`fopen()` (Duktape 2.x no long provides any file I/O API calls).  There is no
way to specify an encoding or support a wide character set.  To do that, you
need to implement a platform specific helper yourself.

## Wrapped types used in the Duktape API

For the most part you don't need to worry about these type wrappers:
they're intended for exotic environments where some common assumptions
about type bit counts and such don't hold.

The API documentation uses the Duktape wrapped typedef names (such as
`duk_idx_t`).  The concrete type used by the compiler depends on your
platform and compiler.  When hovering over a prototype in the API
documentation the tool tip will show what concrete types are used when
C99/C++11 types are available and the platform `int` is at least
32 bits wide which is nowadays almost always the case.

The following table summarizes a few central typedefs and what the concrete
type selected will be in various (example) environments.  The table also
suggests what plain type you should use for `printf()` and `scanf()` casts
for portable formatting/scanning.

<table>
<tr>
<th>Duktape type</th>
<th>C99/C++11 32-bit int</th>
<th>Legacy 32-bit int</th>
<th>Legacy 16-bit int</th>
<th>`printf`</th>
<th>`scanf`</th>
<th>Notes</th>
</tr>
<tr>
<td>duk_int_t</td>
<td>int</td>
<td>int</td>
<td>long</td>
<td>%ld<br />long</td>
<td>%ld<br />long</td>
<td>All around integer type, range is [DUK_INT_MIN, DUK_INT_MAX]</td>
</tr>
<tr>
<td>duk_uint_t</td>
<td>unsigned int</td>
<td>unsigned int</td>
<td>unsigned long</td>
<td>%lu<br />unsigned long</td>
<td>%lu<br />unsigned long</td>
<td>All around unsigned integer type, range is [0, DUK_UINT_MAX]</td>
</tr>
<tr>
<td>duk_int32_t</td>
<td>int32_t</td>
<td>int</td>
<td>long</td>
<td>%ld<br />long</td>
<td>%ld<br />long</td>
<td>Exact type for ToInt32() coercion</td>
</tr>
<tr>
<td>duk_uint32_t</td>
<td>uint32_t</td>
<td>unsigned int</td>
<td>unsigned long</td>
<td>%lu<br />unsigned long</td>
<td>%lu<br />unsigned long</td>
<td>Exact type for ToUint32() coercion</td>
</tr>
<tr>
<td>duk_uint16_t</td>
<td>uint16_t</td>
<td>unsigned short</td>
<td>unsigned short</td>
<td>%u<br />unsigned int</td>
<td>%u<br />unsigned int</td>
<td>Exact type for ToUint16() coercion</td>
</tr>
<tr>
<td>duk_idx_t</td>
<td>int</td>
<td>int</td>
<td>long</td>
<td>%ld<br />long</td>
<td>%ld<br />long</td>
<td>Value stack index</td>
</tr>
<tr>
<td>duk_uarridx_t</td>
<td>unsigned int</td>
<td>unsigned int</td>
<td>unsigned long</td>
<td>%lu<br />unsigned long</td>
<td>%lu<br />unsigned long</td>
<td>Ecmascript array index</td>
</tr>
<tr>
<td>duk_codepoint_t</td>
<td>int</td>
<td>int</td>
<td>long</td>
<td>%ld<br />long</td>
<td>%ld<br />long</td>
<td>Unicode codepoints</td>
</tr>
<tr>
<td>duk_errcode_t</td>
<td>int</td>
<td>int</td>
<td>long</td>
<td>%ld<br />long</td>
<td>%ld<br />long</td>
<td>Integer error codes used in the Duktape API (range for user codes is [1,16777215])</td>
</tr>
<tr>
<td>duk_bool_t</td>
<td>int</td>
<td>int</td>
<td>int</td>
<td>%d<br />int</td>
<td>%d<br />int</td>
<td>Boolean return values</td>
</tr>
<tr>
<td>duk_ret_t</td>
<td>int</td>
<td>int</td>
<td>int</td>
<td>%d<br />int</td>
<td>%d<br />int</td>
<td>Return value from Duktape/C function</td>
</tr>
<tr>
<td>duk_size_t</td>
<td>size_t</td>
<td>size_t</td>
<td>size_t</td>
<td>%lu<br />unsigned long</td>
<td>%lu<br />unsigned long</td>
<td>1:1 mapping now, wrapped for future use.  Range is [0, DUK_SIZE_MAX].
    C99 format specifier is %zu.</td>
</tr>
<tr>
<td>duk_double_t</td>
<td>double</td>
<td>double</td>
<td>double</td>
<td>%f or %lf<br />double</td>
<td>%lf<br />double</td>
<td>1:1 mapping now, wrapped for future use, e.g. custom software floating point library.</td>
</tr>
</table>

## Background on C/C++ typing issues

This section provides some background and rationale for the C typing.

Portable C/C++ typing is a complex issue, involving:

* Portable type detection for C99, C++11, and older environments.

* Bit sizes and ranges of available types, selecting the most appropriate
  types, e.g. fastest or smallest with a guaranteed minimum or exact bit size.

* Constants for type ranges, such as `INT_MIN`.

* Format specifiers when types are used in `printf()` and `scanf()` format
  strings.

(Duktape only works on platforms with
[two's complement](http://en.wikipedia.org/wiki/Two's_complement)
arithmetic.)

### Bit sizes are not standard (and there's no guaranteed fast 32-bit type)

Bit sizes of common types like `int` vary across implementations.  C99/C++11
provide standard integer typedefs like `int32_t` (exact signed 32-bit type)
and `int_fast32_t` (fast integer type which has at least signed 32-bit range).
These typedefs are not available in older compilers, so platform dependent
type detection is necessary.

Duktape needs an integer type which is convenient for the architecture but
still guaranteed to be 32 bits wide.  Such a type is needed to represent array
indices, Unicode points, etc.  However, there is no such standard type and at
least the following variations are seen:

* a 16-bit `int` and a 32-bit `long`
* a 32-bit `int` and a 32-bit `long`
* a 32-bit `int` and a 64-bit `long`, with the 64-bit `long` being inefficient for the processor
* a 64-bit `int` and `long`

As can be seen, no built-in C type would be appropriate in all cases, so type
detection is needed.  Duktape detects and defines `duk_int_t` type for these
purposes (at least 32 bits wide, convenient to the CPU).  Normally it is mapped
to `int` if Duktape can reliably detect that `int` is 32 bits or wider.  When
this is not the case, `int_fast32_t` is used if C99 types are available; if C99
is not available, Duktape uses platform specific detection to arrive at an
appropriate type.  The `duk_uint_t` is the same but unsigned.  Most other types
in the API (such as `duk_idx_t`) are mapped to `duk_(u)int_t` but this may
change in the future if necessary.

Other special types are also needed.  For instance, exactly N bits wide
integers are also needed to ensure proper overflow behavior in some cases.

### Format specifiers

C/C++ types are often used with `printf()` and `scanf()`, with each type
having a format specifier.  The set of format specifiers is only partially
standardized (e.g. `%d` is used for an `int`, regardless of its bit size),
but custom codes are sometimes used.

When using type wrappers, the correct format code depends on type detection.
For instance, `duk_int_t` is mapped to a convenient integer type which is
at least 32 bits wide.  On one platform the underlying type might be `int`
(format specifier `%d`) and on another it might be `long` (format specifier
`%ld`).  Calling code cannot safely use such a value in string formatting
without either getting the proper format specified from a preprocessor
define or using a fixed format specifier and casting the argument:

```c
duk_int_t val = /* ... */;

/* Cast value to ensure type and format match.  Selecting the appropriate
 * cast target is problematic, and caller must "play it safe".  Without
 * relying on C99 types, "long" is usually good for signed integers.
 */
printf("value is: %ld\n", (long) val);

/* When assuming C99 types (which limits portability), the maxint_t is
 * guaranteed to represent all signed integers and has a standard format
 * specifiers "%jd".  For unsigned values, umaxint_t and "%ju".
 */
printf("value is: %jd\n", (maxint_t) val);
```

C99 provides preprocessor defines for C99 types in `inttypes.h`.  For
instance, the `printf()` decimal format specifier for `int_fast32_t`
is `PRIdFAST32`:

```c
int_fast32_t val = /* ... */;

printf("value is: " PRIdFAST32 "\n", val);
```

Duktape doesn't currently provide wrappers for format specifier defines.

The `printf()` and `scanf()` format specifiers may be different.  One reason
is that `float` arguments are automatically promoted to `double` in `printf()`
but they are handled as distinct types by `scanf()`.  See
http://stackoverflow.com/questions/210590/why-does-scanf-need-lf-for-doubles-when-printf-is-okay-with-just-f.

The correct format specifier for a `double` in `printf()` is `%f` (float
values are automatically promoted to doubles) but `%lf` is also accepted.
The latter is used in Duktape examples for clarity.  See
http://stackoverflow.com/questions/4264127/correct-format-specifier-for-double-in-printf.
