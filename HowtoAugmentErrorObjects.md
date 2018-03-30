# How to augment error objects

## Error object properties

Error objects have both "own" properties and properties inherited from
`Error.prototype`; some properties are normal data properties while
others are virtual, see:

- <http://duktape.org/guide.html#errorobjects>

## Overwriting .fileName, .lineNumber, and .stack

### Duktape 1.4.0 and after

These properties are provided by an accessor (getter/setter) inherited from
`Error.prototype`.  The getter provides the requested result (e.g. fileName)
based on an internal `_Tracedata` property which is added to an error when
the error is created.

Starting from Duktape 1.4.0 you can use a simple property write to override
`.fileName`, `.lineNumber`, and `.stack`:

```js
var err = new Error('aiee');
err.fileName = 'dummy.js';
print(err.fileName);  // -> dummy.js
```

Equivalently in C:

```c
duk_push_error_object(ctx, DUK_ERR_RANGE_ERROR, "invalid arg: %d", myarg);
duk_push_string(ctx, "dummy.c");
duk_put_prop_string(ctx, -2, "fileName");
```

### Before Duktape 1.4.0

Before Duktape 1.4.0 a simple property write does not work because the
inherited property is accessor which "captures" the write attempt and
ignores it:


```js
// Duktape 1.3.0
var err = new Error('aiee');
err.fileName = 'dummy.js';
print(err.fileName);  // not changed
```

You can still override these properties using `Object.defineProperty()`.
This works because the inherited accessor is configurable which allows
an overriding "own" property to be added to the error:

```js
var err = new Error('aiee');
Object.defineProperty(err, 'fileName', {
    value: 'dummy.js',
    writable: true,
    enumerable: false,
    configurable: true
});
print(err.fileName);  // dummy.js
```

In C code you can use `duk_def_prop()` similarly:

```c
duk_push_string(ctx, "fileName");
duk_push_string(ctx, "dummy.js");
duk_def_prop(ctx, idx_err, DUK_DEFPROP_HAVE_VALUE |
                           DUK_DEFPROP_HAVE_WRITABLE | DUK_DEFPROP_WRITABLE |
                           DUK_DEFPROP_HAVE_ENUMERABLE | /*not enumerable */
                           DUK_DEFPROP_HAVE_CONFIGURABLE | DUK_DEFPROP_CONFIGURABLE);
```

### Guaranteeing Duktape 1.4.0 behavior

There's a polyfill to provide Duktape 1.4.0 behavior for previous versions:

* <https://github.com/svaarala/duktape/blob/master/polyfills/duktape-error-setter-writable.js>
