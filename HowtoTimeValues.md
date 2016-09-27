# How to work with time values

## Overview

In Ecmascript code you can work with time values using the `Date` built-in with
no Duktape specific APIs.

* FIXME: high precision time values? Duktape.now()?

In C code you have two basic alternatives:

* Use the platform native time APIs (such as ``time()``, ``gmtime()``, etc).
  These are the most appropriate if you specifically need the platform time,
  even if it differs from the time seen by Ecmascript code.

* Use the Duktape C API time handling functions (since Duktape 2.x).  This
  ensures you'll be working with the same time provider as seen by Ecmascript
  code: sometimes the Ecmascript time differs from the platform time, e.g.
  because of time virtualization or because a correction offset needs to be
  applied to the platform time.  When using the C API time functions your code
  will also be more portable.

## Working with the C time API

### Time value and current time

A time value is represented in the C API similarly to Ecmascript `Date`:
an IEEE double indicating number of milliseconds since epoch.  The time
value may be negative for years before 1970.  However, unlike the Ecmascript
`Date` API, the millisecond value may have fractions for sub-millisecond
resolution.  (This is currently allowed in the C API but there's no facility
for high precision timevalues yet.)

To get the current time:

```c
/* Milliseconds since Jan 1, 1970, POSIX time. */
duk_double_t curr_time = duk_get_now(ctx);
printf("Time now: %lf\n", (double) curr_time);
```

The time value is compatible with the UNIX/POSIX notion of time values.  This
allows you to use platform functions for time value conversion and formatting
but to get the time value matching Ecmascript code.  For example:

```c
struct tm *t;
time_t now;

now = (time_t) (duk_get_now(ctx) / 1000.0);
t = gmtime(&now);
/* Work with struct tm in 't'. */
```

### Component breakdown

There are two useful helpers for converting an arbitrary time value into broken
down components (year, month, etc) and converting components into a time value.
Converting a time value to components allows you to to e.g. format a time value
in a custom manner:

```c
duk_double_t time = 1451703845006.0;  /* 2016-01-02 03:04:05.006Z */
duk_time_components comp;

duk_time_to_components(time, &comp);
printf("Event occurred at: %04d-%02d-%02d %02d:%02d:%02d.%03dZ\n",
       (int) comp.year, (int) comp.month, (int) comp.day,
       (int) comp.hour, (int) comp.minute, (int) comp.second,
       (int) comp.millisecond);
```

**FIXME: check components above re: one vs. zero based, naming.**

Similarly, you can build a time value from components:

```c
duk_time_components comp;
duk_double_t time;

memset((void *) &comp, 0, sizeof(comp));  /* good practice */
comp.year = 2016;
comp.month = 1;
comp.day = 2;
comp.hour = 3;
comp.minute = 4;
comp.second = 5;
comp.millisecond = 6.0;  /* IEEE double, to allow sub-millisecond resolution */

time = duk_components_to_time(&comp);
printf("Time value is %lf\n", (double) time);
```

**FIXME: normalization example.**

Note that the conversion functions may throw an error when an argument is
invalid, e.g. a time value is beyond supported range or time components are
invalid.

### Local time

**FIXME: local time**
