# Getting started: primality testing

The [[Getting started: line processing|GettingStartedLineProcessing]] example
illustrated how C code can call into Ecmascript to do things that are easy
in Ecmascript but difficult in C.

The example in this article illustrates the reverse, how Ecmascript code can
call C code: while scripting is useful for many things, it is not optimal for
low level byte or character processing.  Being able to call optimized C
helpers allows you to write most of your script logic in nice Ecmascript but
call into C for the performance critical parts.  Another reason for using
native functions is to provide access to native libraries.

To implement a native function you write an ordinary C function which
conforms to a special calling convention, the **Duktape/C binding**.  Duktape/C
functions take a single argument, a Duktape context, and return a single
value indicating either error or number of return values.  The function
accesses call arguments and provides return values through the Duktape
context's **value stack**, manipulated with the Duktape API.  We'll go deeper
into Duktape/C binding and the Duktape API later on.

## Simple example, squaring a number

Here's a simple example:

```c
duk_ret_t my_native_func(duk_context *ctx) {
    double arg = duk_require_number(ctx, 0 /*index*/);
    duk_push_number(ctx, arg * arg);
    return 1;
}
```

Let's look at this line by line:

```c
double arg = duk_require_number(ctx, 0 /*index*/);
```

Check that the number at value stack index 0 (bottom of the stack, first
argument to function call) is a number; if not, throws an error and never
returns.  If the value is a number, returns it as a `double`.

```c
duk_push_number(ctx, arg * arg);
```

Compute square of argument and push it to the value stack.

```c
return 1;
```

Return from the function call, indicating that there is a (single) return
value on top of the value stack.  Multiple return values are not yet supported.
You could also `return 0` to indicate that no return value is given in which
case Duktape defaults to Ecmascript `undefined`.
A negative return value causes an error to be automatically thrown: this is
a shorthand for throwing errors conveniently.  Note that you don't need to
pop any values off the stack yourself, Duktape will do that for you
automatically when the function returns.  See
[Programming model](http://duktape.org/guide.html#programming) for more
details.

## Primality test

We'll use a primality test as an example for using native code to speed
up Ecmascript algorithms.  More specifically, our test program searches for
primes under 1000000 which end with the digits '9999'.  The Ecmascript
version of the program is:

* https://github.com/svaarala/duktape/blob/master/examples/guide/prime.js

Note that the program uses the native helper if it's available but falls
back to an Ecmascript version if it's not.  This allows the Ecmascript code
to be used in other containing programs.  Also, if the prime check program
is ported to another platform where the native version does not compile
without changes, the program remains functional (though slower) until the
helper is ported.  In this case the native helper detection happens when the
script is loaded.  You can also detect it when the code is actually called
which is more flexible.

A native helper with functionality equivalent to `primeCheckEcmascript()`
is quite straightforward to implement.  Adding a program main and a simple
`print()` binding into the Ecmascript global object, we get `primecheck.c`:

* https://github.com/svaarala/duktape/blob/master/examples/guide/primecheck.c

The new calls compared to
[[Getting started: line processing|GettingStartedLineProcessing]]
are, line by line:

```c
int val = duk_require_int(ctx, 0);
int lim = duk_require_int(ctx, 1);
```

These two calls check the two argument values given to the native helper.
If the values are not of the Ecmascript number type, an error is thrown.
If they are numbers, their value is converted to an integer and assigned to
the `val` and `lim` locals.  The index 0 refers to the first function
argument and index 1 to the second.

Technically `duk_require_int()` returns a <code>duk_int_t</code>; this
indirect type is always mapped to an `int` except on rare platforms where
an `int` is only 16 bits wide.  In ordinary application code you don't
need to worry about this, see
[C types](http://duktape.org/guide.html#ctypes) for more discussion.

```c
duk_push_false(ctx);
return 1;
```

Pushes an Ecmascript `false` to the value stack.  The C return value 1
indicates that the `false` value is returned to the Ecmascript caller.

```c
duk_push_global_object(ctx);
duk_push_c_function(ctx, native_prime_check, 2 /*nargs*/);
duk_put_prop_string(ctx, -2, "primeCheckNative");
```

The first call, like before, pushes the Ecmascript global object to the
value stack.  The second call creates an Ecmascript `Function` object
and pushes it to the value stack.  The function object is bound to the
Duktape/C function `native_prime_check()`: when the Ecmascript function
created here is called from Ecmascript, the C function gets invoked.
The second call argument (`2`) indicates how many arguments the C
function gets on the value stack.  If the caller gives fewer arguments,
the missing arguments are padded with `undefined`; if the caller gives
more arguments, the extra arguments are dropped automatically.  Finally, the
third call registers the function object into the global object with the
name `primeCheckNative` and pops the function value off the stack.

```c
duk_get_prop_string(ctx, -1, "primeTest");
if (duk_pcall(ctx, 0) != 0) {
    printf("Error: %s\n", duk_safe_to_string(ctx, -1));
}
duk_pop(ctx);  /* ignore result */
```

When we come here the value stack already contains the global object
at the stack top.  Line 1 looks up the `primeTest` function from the
global object (which was defined by the loaded script).  Lines
2-4 call the `primeTest` function with zero arguments, and prints out an
error safely if one occurs.  Line 5 pops the call result off the stack;
we don't need the return value here.

## Compiling and running

Compile as before:

```
# src/ contains Duktape sources from the distributable or prepared
# explicitly using tools/configure.py.

$ gcc -std=c99 -o primecheck -Isrc/ src/duktape.c primecheck.c -lm
```

Test run, ensure that `prime.js` is in the current directory:

```
$ time ./primecheck
Have native helper: true
49999 59999 79999 139999 179999 199999 239999 289999 329999 379999 389999
409999 419999 529999 599999 619999 659999 679999 769999 799999 839999 989999

real	0m2.985s
user	0m2.976s
sys	0m0.000s
```

Because most execution time is spent in the prime check, the speed-up
compared to plain Ecmascript is significant.  You can check this by editing
`prime.js` and disabling the use of the native helper:

```
// Select available helper at load time
var primeCheckHelper = primeCheckEcmascript;
```

Re-compile and re-run the test:

```
$ time ./primecheck
Have native helper: false
49999 59999 79999 139999 179999 199999 239999 289999 329999 379999 389999
409999 419999 529999 599999 619999 659999 679999 769999 799999 839999 989999

real	0m23.609s
user	0m23.573s
sys	0m0.000s
```
