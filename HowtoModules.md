# How to use modules

## Module search function

The module search function encapsulates all platform specific concerns,
such as module search paths and file system access, related to finding a
module matching a certain identifier:

```js
Duktape.modSearch = function (id, require, exports, module) {
    // ...
};
```

The arguments of the module search function are:

* A fully resolved module ID.  Relative IDs are converted to absolute
  IDs and there are no unresolved `.` or `..` ID terms.

* A `require()` function for loading further modules.  Relative module IDs
  are resolved relative to the current module.  For instance, if `foo/bar`
  is being loaded, the `require()` function given to the module search function
  would resolve `./quux` to `foo/quux`.

* A `exports` object to export symbols during module search.  Writing to
  `exports` within the module search function is only needed when loading
  native (Duktape/C) modules.

* A `module` object which provides metadata about the module being loaded.
  The only property provided now is module.id, a resolved absolute identifier
  for the module being loaded.

If a module is not found, the module search function is expected to throw
an error.  This error will propagate out to the code which originally called
`require()` so it should have a useful error message containing the
module identifier.  Any changes made to `exports` before throwing the error
are thrown away.

If a module is found, the module search function can return a string
providing the source code for the module.  Duktape will then take care of
compiling and executing the module code so that module symbols get registered
into the `exports` object.

The module search function can also add symbols directly to the
`exports` object.  This can be used to implement native (Duktape/C)
modules and platform specific DLL loading support.  For example, the module
search function could call a native module initializer (provided by a DLL)
which registered all the native functions and constants into the
`exports` object.

To support the native module case, the module search function can also
return `undefined` (or any non-string value), in which case Duktape will
assume that the module was found but has no Ecmascript source to execute.
Symbols written to `exports` in the module search function are the only
symbols provided by the module.

Hybrid modules containing both C and Ecmascript code are also supported:
simply write native symbols into the `exports` table inside the module
search function, and return the module's Ecmascript code.  Duktape
will then execute the Ecmascript code, which can access symbols already
registered into the `exports` table and register further symbols.

The module search function can be either an Ecmascript function or a
Duktape/C function.

## Implementing a module search function

Here's a simply module search stub which provides two modules:

```js
Duktape.modSearch = function (id) {
    if (id === 'foo') {
        return 'exports.hello = function() { print("Hello from foo!"); };';
    } else if (id === 'bar') {
        return 'exports.hello = function() { print("Hello from bar!"); };';
    }
    throw new Error('module not found: ' + id);
};
```

A more practical module search function is almost always platform dependent
because modules are most often loaded from disk.  Usually a Duktape/C binding
is needed to access the file system.  The example below loads modules using a
hypothetical `readFile()` function:

```js
Duktape.modSearch = function (id) {
    /* readFile() reads a file from disk, and returns a string or undefined.
     * 'id' is in resolved canonical form so it only contains terms and
     * slashes, and no '.' or '..' terms.
     */
    var res;

    print('loading module:', id);

    res = readFile('/modules/' + id + '.js');
    if (typeof res === 'string') {
        return res;
    }

    throw new Error('module not found: ' + id);
}
```

The following module search function supports pure C, pure Ecmascript, and
mixed modules.  C modules are loaded and initialized with a hypothetical
`loadAndInitDll()` function which loads a DLL, and if found, calls an
init function so that the DLL initializer can register exported symbols:

```js
Duktape.modSearch = function (id, require, exports, module) {
    /* readFile(): as above.
     * loadAndInitDll(): load DLL, call its init function, return true/false.
     */
    var name;
    var src;
    var found = false;

    print('loading module:', id);

    /* DLL check.  DLL init function is platform specific.  It gets 'exports'
     * but also 'require' so that it can require further modules if necessary.
     */
    name = '/modules/' + id + '.so';
    if (loadAndInitDll(name, require, exports, module)) {
        print('loaded DLL:', name);
        found = true;
    }

    /* Ecmascript check. */
    name = '/modules/' + id + '.js';
    src = readFile(name);
    if (typeof src === 'string') {
        print('loaded Ecmascript:', name);
        found = true;
    }

    /* Must find either a DLL or an Ecmascript file (or both) */
    if (!found) {
        throw new Error('module not found: ' + id);
    }

    /* For pure C modules, 'src' may be undefined which is OK. */
    return src;
}
```

The module search function could also load modules from a compressed
in-memory store, or load the modules over the network.  However, a module
search function cannot do a coroutine yield, so network access will block the
application; it is most useful for testing.

<!-- XXX: this is just a placeholder, perhaps a separate guide section or integrate
     better with text elsewhere in this section.
-->

## Writing modules in C

There's a recommended (but not mandatory) convention for writing C modules, see
[c-module-convention.rst](https://github.com/svaarala/duktape/blob/master/doc/c-module-convention.rst).

Most C modules will need the following parts:

```c
/*
 *  Identify module
 */

/* Include duktape.h and whatever platform headers are needed. */
#include "duktape.h"

/*
 *  Duktape/C functions providing module functionality.
 */

static duk_ret_t my_func_1(duk_context *ctx) {
    /* ... */
}

static duk_ret_t my_func_2(duk_context *ctx) {
    /* ... */
}

/* ... */

/*
 *  Module initialization
 */

static const duk_function_list_entry my_module_funcs[] = {
    { "func1", my_func_1, 3 /*nargs*/ },
    { "func2", my_func_2, DUK_VARARGS /*nargs*/ },
    { NULL, NULL, 0 }
};

static const duk_number_list_entry my_module_consts[] = {
    { "FLAG_FOO", (double) (1 << 0) },
    { NULL, 0.0 }
};

/* Init function name is dukopen_<modname>. */
duk_ret_t dukopen_my_module(duk_context *ctx) {
    duk_push_object(ctx);
    duk_put_function_list(ctx, -1, my_module_funcs);
    duk_put_number_list(ctx, -1, my_module_consts);

    /* Return value is the module object.  It's up to the caller to decide
     * how to use the value, e.g. write to global object.
     */
    return 1;
}
```

The calling application which wants to load this module manually (outside
of CommonJS module loading) will then simply:

```c
int main(int argc, char *argv[]) {
    duk_context *ctx;

    ctx = duk_create_heap_default();
    if (!ctx) {
        /* ... */
    }

    /* Module loading happens with a Duktape/C call wrapper. */
    duk_push_c_function(ctx, dukopen_my_module, 0 /*nargs*/);
    duk_call(ctx, 0);
    duk_put_global_string(ctx, "my_module");

    /* my_module is now registered in the global object. */
    duk_eval_string_noresult(ctx, "my_module.func2()");

    /* ... */

    duk_destroy_heap(ctx);
    return 0;
}
```

C modules can also be loaded using a CommonJS module loader, in which case
the module loader would call the init function (e.g. located from a DLL).

## Limitations

* When implementing native modules in the module search function, circular
  module references are not supported because the module's `exports`
  table is not registered by Duktape as a "module being loaded" before the
  module search function exits.  Circular module references are supported for
  pure Ecmascript modules.
