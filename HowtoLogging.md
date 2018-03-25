# How to use logging

## Overview

Duktape 1.x has a built-in logging framework with a small footprint, reasonable
performance, and redirectable output.  In Duktape 2.x that framework was moved
into an optional extra (https://github.com/svaarala/duktape/tree/master/extras/logging)
to avoid portability issues on exotic targets.

See <https://github.com/svaarala/duktape/blob/master/doc/logging.rst> for details
on the features and internals of the logging framework.

You can of course use any other logging framework of your choice, e.g.
`console.log()` provided by <https://github.com/svaarala/duktape/tree/master/extras/console>.
For low memory targets something much simpler, such as a single `print()`
binding may be the most appropriate approach.

## Example

Basic usage example:

```js
var val1 = 'foo';
var val2 = 123;
var val3 = new Date(123456789e3);

var logger = new Duktape.Logger();  // or new Duktape.Logger('logger name')
logger.info('three values:', val1, val2, val3);
```

The example would print something like the following to `stderr`:

```
2014-10-17T19:26:42.141Z INF test.js: three values: foo 123 1973-11-29 23:33:09.000+02:00
```

## Duktape.Logger (constructor)

<table>
<thead>
<tr>
<th>Property</th><th>Description</th>
</tr>
</thead>
<tbody>
<tr><td>prototype</td><td>Prototype for Logger objects.</td></tr>
<tr><td>clog</td><td>Representative logger for log entries written from C code.</td></tr>
</tbody>
</table>

Called as a constructor, creates a new Logger object with a specified name
(first argument).  If the name is omitted, Logger will automatically assign
a name based on the calling function's `.fileName` property.  If called as a
normal function, throws a `TypeError`.

Logger instances have the following properties:

- `n`: logger name; the property will be missing if (a) the given name is not
  a string, or (b) no name is given and the automatic assignment fails.  The
  logger will then inherit a value from the Logger prototype. You can manually
  set this property later to whatever value is desired.
- `l`: log level, indicates the minimum log level to output.  This property is
  not assigned by default and the logger inherits a default level from the
  Logger prototype.  You can manually set this property to another value to
  control log level on a per-logger basis.

(Tail calling might theoretically affect the automatic name assignment (i.e.
when logger name argument is omitted).  However, constructor calls are never
converted to tail calls, so this is not a practical issue.)

## Duktape.Logger.prototype

<table>
<thead>
<tr>
<th>Property</th><th>Description</th>
</tr>
</thead>
<tbody>
<tr><td>raw</td><td>Output a formatted log line (buffer value), by default writes to <code>stderr</code>.</td></tr>
<tr><td>fmt</td><td>Format a single (object) argument.</td></tr>
<tr><td>trace</td><td>Write a trace level (level 0, TRC) log entry.</td></tr>
<tr><td>debug</td><td>Write a debug level (level 1, DBG) log entry.</td></tr>
<tr><td>info</td><td>Write an info level (level 2, INF) log entry.</td></tr>
<tr><td>warn</td><td>Write a warn level (level 3, WRN) log entry.</td></tr>
<tr><td>error</td><td>Write an error level (level 4, ERR) log entry.</td></tr>
<tr><td>fatal</td><td>Write a fatal level (level 5, FTL) log entry.</td></tr>
<tr><td>l</td><td>Default log level, initial value is 2 (info).</td></tr>
<tr><td>n</td><td>Default logger name, initial value is "anon".</td></tr>
</tbody>
</table>

## duk_log() C API call

```c
void duk_log(duk_context *ctx, duk_int_t level, const char *fmt, ...);
```

Write a formatted log entry with the specified log level (one of `DUK_LOG_xxx`).
The log write goes through the logging framework using the `Duktape.Logger.clog`
logger instance.

Example:

```c
duk_log(ctx, DUK_LOG_INFO, "received message, type: %d", (int) msg_type);
```

## duk_log_va() C API call

```c
void duk_log_va(duk_context *ctx, duk_int_t level, const char *fmt, va_list ap);
```

Like `duk_log()` but a vararg (`va_list`) variant.  Example:

```c
void my_log_info(duk_context *ctx, const char *fmt, ...) {
    va_list ap;

    va_start(ap, fmt);
    duk_log_va(ctx, DUK_LOG_INFO, fmt, ap);
    va_end(ap);
}
```
