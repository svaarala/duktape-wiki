# Getting started: line processing

## Overview

Let's look at a simple example program.  The program reads in a line from
`stdin` using a C mainloop, calls an ECMAScript helper to transform the
line, and prints out the result.  The line processing function can take
advantage of ECMAScript goodies like regular expressions, and can be easily
modified without recompiling the C program.

The script code will be placed in
[process.js](https://github.com/svaarala/duktape/blob/master/examples/guide/process.js).
The example line processing function converts a plain text line into HTML,
and automatically bolds text between stars:

* <https://github.com/svaarala/duktape/blob/master/examples/guide/process.js>

The C code, [processlines.c](https://github.com/svaarala/duktape/blob/master/examples/guide/processlines.c)
initializes a Duktape context, evaluates the script, then proceeds to process
lines from `stdin`, calling `processLine()` for every line:

* <https://github.com/svaarala/duktape/blob/master/examples/guide/processlines.c>

## Breakdown of processlines.c

Let's look at the Duktape specific parts of the example code piece by piece.
Here we need to gloss over some details for brevity, see
[Programming model](http://duktape.org/guide.html#programming) for a
detailed discussion:

```c
/* For brevity assumes a maximum file length of 16kB. */
static void push_file_as_string(duk_context *ctx, const char *filename) {
    FILE *f;
    size_t len;
    char buf[16384];

    f = fopen(filename, "rb");
    if (f) {
        len = fread((void *) buf, 1, sizeof(buf), f);
        fclose(f);
        duk_push_lstring(ctx, (const char *) buf, (duk_size_t) len);
    } else {
        duk_push_undefined(ctx);
    }
}
```

Because Duktape is an embeddable engine and makes minimal assumptions
there are no file I/O bindings in the default C or ECMAScript API.  The
above helper is an example of how to push the contents of a file as a
string; the example uses a fixed read buffer for brevity, a better
implementation would first check the file size and then allocate a buffer
for it.  The Duktape distributable includes "extras" which provide, among
other things, useful C and ECMAScript helpers, including file I/O helpers.

```c
ctx = duk_create_heap_default();
if (!ctx) {
    printf("Failed to create a Duktape heap.\n");
    exit(1);
}
```

First we create a Duktape context.  A context allows us to exchange values
with ECMAScript code by pushing and popping values to the **value stack**.
Most calls in the Duktape API operate with the value stack, pushing, popping,
and examining values on the stack.  For production code you should use
[duk_create_heap()](http://duktape.org/api.html#duk_create_heap) so that you
can set a **fatal error handler**.  See
[Error handling](http://duktape.org/guide.html#error-handling)
for discussion of error handling best practices.

```c
push_file_as_string(ctx, "process.js");
if (duk_peval(ctx) != 0) {
    printf("Error: %s\n", duk_safe_to_string(ctx, -1));
    goto finished;
}
duk_pop(ctx);  /* ignore result */
```

First we use our file helper to push <code>process.js</code> onto the value
stack as a string.  Then we use [duk_peval()](http://duktape.org/api.html#duk_peval)
to compile and run the script.  The script registers `processLine()` into the
ECMAScript global object for later use.  A **protected call, duk_peval(),** is
used for running the script so that any script errors, such as syntax errors,
are caught and handled without causing a fatal error.  If an error occurs, the
error message is coerced safely using
[duk_safe_to_string()](http://duktape.org/api.html#duk_safe_to_string)
which is guaranteed not to throw a further error.  The result of the string
coercion is a `const char *` pointing to a read-only, NUL-terminated, UTF-8
encoded string, which can be used directly with `printf()`.  The string is
valid as long as the corresponding string value is on the value stack.  The
string will be automatically freed when the value is popped off the value
stack.

```c
duk_push_global_object(ctx);
duk_get_prop_string(ctx, -1 /*index*/, "processLine");
```

The first call pushes the ECMAScript global object to the value stack.
The second call looks up `processLine` property of the global object (which
the script in `process.js` has defined).  The `-1` argument is an index to
the value stack; negative values refer to stack elements starting from the
top, so `-1` refers to the topmost element of the stack, the global object.


```c
duk_push_string(ctx, line);
```

Pushes the string pointed to by `line` to the value stack.  The string length
is automatically determined by scanning for a NUL terminator, like `strlen()`.
Duktape makes a copy of the string when it is pushed to the stack, so the
`line` buffer can be freely modified when the call returns.

```c
if (duk_pcall(ctx, 1 /*nargs*/) != 0) {
    printf("Error: %s\n", duk_safe_to_string(ctx, -1));
} else {
    printf("%s\n", duk_safe_to_string(ctx, -1));
}
duk_pop(ctx);  /* pop result/error */
```

At this point the value stack contains (stack grows to the right):

```
[ globalObject processLine line ]
```

The [duk_pcall()](http://duktape.org/api.html#duk_pcall) method calls a
function with a specified number of arguments given on the value stack, and
replaces both the function and the argument values with the function's
return value.  Here the nargs count is 1 so the processLine function and
the line are replaced with the return value, with the resulting value stack
looking like this:

```
[ globalObject callResult ]
```

The call is protected so that errors can be caught and printed.  The
[duk_safe_to_string()](http://duktape.org/api.html#duk_safe_to_string) API
call is again used to print errors safely.  Once printed, the result (or error)
is popped off the value stack, the global object still remains on the stack.

```c
duk_destroy_heap(ctx);
```

Finally, the Duktape context is destroyed, freeing all resources held by the
context.  This call will free the value stack and all references on the value
stack.  In our example we left the global object on the value stack on purpose.
This is not a problem: no memory leaks will occur even if the value stack
is not empty when the heap is destroyed.

## Compiling

Compile simply as:
```
# src/ contains Duktape sources from the distributable or prepared
# explicitly using tools/configure.py.

$ gcc -std=c99 -o processlines -Isrc/ src/duktape.c processlines.c -lm
```

Test run, ensure that `process.js` is in the current directory:

```
$ echo "I like *Sam & Max*." | ./processlines
I like <b>Sam & Max</b>.
```
