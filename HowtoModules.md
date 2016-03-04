# How to use modules

## Module search function overview

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
  `exports` within the module search function is usually only needed when
  loading native (Duktape/C) modules.

* A `module` object which provides additional information about the module
  being loaded, currently containing:

  - `.id`: a resolved absolute identifier for the module being loaded.

  - `.exports`: the current exports table, initially same as `exports`.
    Can be overwritten by modSearch() and/or an Ecmascript module.  Overwriting
    `module.exports` allows a C module or a native function/constructor to be
    returned directly from `require()`.

The module search function is expected to look up the module, usually based
on the `id` argument, and:

* **Throw an error if a module is not found**.  This error will propagate out
  to the code which originally called `require()` so it should have a useful
  error message containing the module identifier.  Any changes made to
  `exports` before throwing the error are thrown away.
* **Return a string containing the module Ecmascript source code** if the
  module was found and it has Ecmascript source code (possibly in addition to
  native bindings).  Duktape will then take care of compiling and executing the
  module code so that module symbols get registered into the `module.exports`
  object.
* **Return undefined** to indicate the module was found but has no Ecmascript
  source code.  This is useful for native modules, which are handled by
  modSearch() directly.

In addition to returning a string or undefined, the modSearch() function
can directly add symbols to `exports` and/or replace `module.exports` with
a new value; for example, a native function/constructor.  This allows loading
of native and hybrid native/Ecmascript modules.  Native modules can be
initialized from statically linked native code or via platform specific DLL
loading.

The module search function can be either an Ecmascript function or a
Duktape/C function.

Also see:

* Recommended (but not mandatory) convention for writing C modules:
  [c-module-convention.rst](https://github.com/svaarala/duktape/blob/master/doc/c-module-convention.rst).

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
`loadAndInitDll()` function which loads a DLL:

```js
Duktape.modSearch = function (id, require, exports, module) {
    /* readFile(): as above.
     *
     * loadAndInitDll(): load DLL, call its init function, return module
     * init function return value (typically an object containing the
     * module's function/constant bindings).  Return undefined if DLL
     * not found.
     */
    var name;
    var src;
    var found = false;
    var mod;

    print('loading module:', id);

    /* DLL check.  DLL init function is platform specific.
     *
     * The DLL loader could also need e.g. 'require' to load further modules,
     * but typically native modules don't need to load submodules.
     */
    name = '/modules/' + id + '.so';
    mod = loadAndInitDll(name);
    if (mod) {
        print('loaded DLL:', name);
        module.exports = mod;  // replace exports table with module's exports
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
in-memory store, load the modules over the network, etc.  However, a module
search function cannot do a coroutine yield, so network access will block the
application; it is most useful for testing.

## Implementing a native modSearch() function

The modSearch() function can also be implemented as a native function, for
example:

```c
duk_ret_t my_mod_search(duk_context *ctx) {
    /* Nargs was given as 4 and we get the following stack arguments:
     *   index 0: id
     *   index 1: require
     *   index 2: exports
     *   index 3: module
     */

    /* ... */
}
```

You can register the native modSearch() function from C code as follows:

```c
duk_get_global_string(ctx, "Duktape");
duk_push_c_function(ctx, my_mod_search, 4 /*nargs*/);
duk_put_prop_string(ctx, -2, "modSearch");
duk_pop(ctx);
```

## Returning a native function/constructor from modSearch()

The `modSearch()` function can overwrite `module.exports` to control what is
returned from `require()`, which allows a function/constructor to be returned:

```js
Duktape.modSearch = function (id, require, exports, module) {
    // Ignore 'id' in this example.

    // Overwriting module.exports (and ignoring 'exports' argument) inside
    // modSearch() allows you to replace the value which is ultimately
    // returned from `require()`.  Here we return a constructor directly.

    module.exports = function MyConstructor(name) {
        this.name = name;
    };

    return; // no source to load
};

var MyFunc = require('dummy');  // returns MyConstructor
print(typeof MyFunc);  // prints "function"

var obj = new MyFunc('myname');
print(obj.name);  // prints "myname"
```

The same approach works to return a native function/constructor from
modSearch(), even if modSearch() is implemented as a Duktape/C function:

```c
duk_ret_t my_mod_search(duk_context *ctx) {
    /* Nargs was given as 4 and we get the following stack arguments:
     *   index 0: id
     *   index 1: require
     *   index 2: exports
     *   index 3: module
     */

    /* Normally we'd look at 'id' to decide what module to load, ignore
     * in this example.
     */

    /* Push our native constructor (omitted here). */
    duk_push_c_function(ctx, my_native_constructor, 1 /*nargs*/);

    /* Overwrite module.exports. */
    duk_put_prop_string(ctx, 3 /*idx of 'module'*/, "exports");

    /* Return 'undefined' to indicate no source code. */
    return 0;
}
```

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
     * how to use the value, e.g. write to global object.  The value can also
     * be e.g. a function/constructor instead of an object.
     */
    return 1;
}
```

A module written this way can be used from outside the CommonJS module loading
framework simply as:

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

The module can also be loaded using the Duktape CommonJS module loader:

* modSearch() would call the init function `dukopen_my_module()`, located
  from a DLL for example.

* modSearch() would assign the module object returned from the init function
  (on top of the Duktape value stack) to `module.exports`, and return
  `undefined` to indicate there's no Ecmascript source code associated with
  the module.

* The module object returned from `dukopen_my_module()` would then appear
  as is as the return value of `require('my_module')`.

## Limitations

* When implementing native modules in the module search function, circular
  module references are not supported because the module's `exports`
  table is not registered by Duktape as a "module being loaded" before the
  module search function exits.  Circular module references are supported for
  pure Ecmascript modules.
