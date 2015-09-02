# How to use virtual properties

Duktape provides two mechanisms for interacting with property accesses
programmatically:

* Accessor properties (getters and setters)

* Proxy object

## Ecmascript E5 accessor properties (getters and setters)

### Overview of accessors

Ecmascript Edition 5 provides **accessor properties** (also called
"getters and setters") which allow property read/write operations to be
captured by a user function.  Setter/getter functions can be both Ecmascript
and Duktape/C functions.

Accessors are set up using `Object.defineProperty()` or
`Object.defineProperties()` from Ecmascript code, or using
[duk_def_prop()](http://duktape.org/api.html#duk_def_prop) from C code.

### Example

To capture writes to `obj.color` so that you can validate the
color value and trigger a redraw as a side effect:

```js
var obj = {};

function validateColor(color) {
    // Return true or false
}

Object.defineProperty(obj, 'color', {
    enumerable: false,
    configurable: false,
    get: function () {
        // current color is stored in the raw _color property here
        return this._color;
    },
    set: function (v) {
        if (!validateColor(v)) {
            // only allow valid color formats to be assigned
            throw new TypeError('invalid color: ' + v);
        }
        this._color = v;
        redraw();
    }
});

// Change to red and trigger a redraw.
obj.color = '#ff0000';
```

### Limitations

Setters and getters have the advantage of being part of the E5 standard
and of being widely implemented.  However, they have significant limitations:

* They are limited to interacting with property read and write operations.
  You cannot capture property deletions, interact with object enumeration, etc.

* They only apply to individual properties which you set up as accessors
  beforehand.  You cannot capture all property accesses of a certain object,
  which limits their usefulness in some scenarios, such as virtualizing large
  arrays.

* A standard property getter/setter function doesn't get the property key as an
  argument (this behavior is defined by the Ecmascript specification) which
  prevents sharing of getter/setter functions for multiple properties.  However,
  Duktape provides getter/setter functions with the property name as an additional,
  non-standard argument; see more discussion below.

### Non-standard getter/setter key argument

Duktape provides the property key as a non-standard getter/setter function
argument when the getter/setter is triggered by a property access.  For instance,
when running `print(foo.bar)` the getter for the "bar" property would
get called, and that function would get "bar" as a non-standard additional
argument:

```js
var obj = {};
function myGetter(key) {
    // 'this' binding is the target object, 'key' is a non-standard argument
}
function mySetter(val, key) {
    // 'this' binding is the target object, 'key' is a non-standard argument
}
Object.defineProperties(obj, {
    // Same getter/setter can be used here
    key1: { enumerable: true, configurable: true, get: myGetter, set: mySetter },
    key2: { enumerable: true, configurable: true, get: myGetter, set: mySetter },
    key3: { enumerable: true, configurable: true, get: myGetter, set: mySetter }
    // ...
});
```

However, getters and setters can be also called without doing a property
access; in these cases the argument will of course be missing:

```js
var desc = Object.getOwnPropertyDescriptor(obj, 'key1');
var getter = desc.get;
print(getter());  // invoke getter directly; key name will be 'undefined'
```

With this technique you can share getter/setter functions, but you still need
to define each accessor property beforehand.  In particular, you can't virtualize
array elements in a reasonable manner, except for very small, fixed size arrays.

Also see
[test-dev-nonstd-setget-key-argument.js](https://github.com/svaarala/duktape/blob/master/tests/ecmascript/test-dev-nonstd-setget-key-argument.js).

### Sharing a Duktape/C getter/setter without the non-standard key argument

If you don't want to use the non-standard getter/setter key argument,
you can also share a single pair of Duktape/C functions to virtualize
multiple property keys as follows.

First, a separate Ecmascript function is created for each getter/setter,
with each such function using the same underlying Duktape/C functions.  Second,
the Duktape/C function uses properties stored on the Ecmascript function
instance "through" which it was called to specialize its behavior.  Below, a
`key` property is stored in the Ecmascript function instance.

For each property, the getter/setter functions would be created as follows:

```c
/* Create Ecmascript function objects for 'key1' getter/setter. */
duk_push_c_function(my_setter, 1 /*nargs*/);
duk_push_string(ctx, "key1");
duk_put_prop_string(ctx, -2, "key");
duk_push_c_function(my_getter, 0 /*nargs*/);
duk_push_string(ctx, "key1");
duk_put_prop_string(ctx, -2, "key");
/* ... add accessor property to target object */

/* Create Ecmascript function objects for 'key2' getter/setter in
 * the same way, and so on for remaining properties.
 */
```

The Duktape/C getter function would then (similarly for the setter):

```c
static duk_ret_t my_getter(duk_context *ctx) {
    const char *key;

    /* There are no positional arguments for the getter. */

    /* Get the target object (e.g. if "foo.bar" is accessed, gets "foo")
     * from the 'this' binding.
     */
    duk_push_this(ctx);

    /* Get the 'key' being accessed from the Ecmascript function which
     * "wraps" the my_getter native function.
     */
    duk_push_current_function(ctx);
    duk_get_prop_string(ctx, -1, "key");
    key = duk_require_string(ctx, -1);

    /* -> [ this func key ] */

    if (strcmp(key, "key1") == 0) {
        /* Behavior for 'key1' */
    } else if (strcmp(key, "key2") == 0) {
        /* Behavior for 'key2' */
    }
    /* ... */
}
```

Separate Ecmascript function objects and pre-defined accessor properties on
the target object are still needed for each virtualized property.

## Ecmascript E6 Proxy subset

### Overview of Proxy

In addition to accessors, Duktape provides a subset implementation of the
Ecmascript E6 `Proxy` concept, see:

* [Proxy object (subset)](http://duktape.org/guide.html#es6-proxy):
  current limitations in Duktape's `Proxy` implementation.

* [Proxy Objects (E6)](http://www.ecma-international.org/ecma-262/6.0/index.html#sec-proxy-objects):
  ES6 specification for the `Proxy` object.

* [Proxy (Mozilla)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy):
  Mozilla's description of the `Proxy` implemented in Firefox, contains a lot of examples.

The Proxy object is much more powerful than getters/setters, but is not yet
a widely used feature of Ecmascript engines.

### Examples of has, get, set, and deleteProperty traps

To print a line whenever any property is accessed:

```js
// Underlying plain object.
var target = { foo: 'bar' };

// Handler table, provides traps for interaction (can be modified on-the-fly).
var handler = {
    has: function (targ, key) {
        print('has called for key=' + key);
        return key in targ;  // return unmodified existence status
    }

    get: function (targ, key, recv) {
        print('get called for key=' + key);
        return targ[key];  // return unmodified value
    },

    set: function (targ, key, val, recv) {
        print('set called for key=' + key + ', val=' + val);
        targ[key] = val;  // must perform write to target manually if 'set' defined
        return true;      // true: indicate that property write was allowed
    },

    deleteProperty: function (targ, key) {
        print('deleteProperty called for key=' + key);
        delete targ[key];  // must perform delete to target manually if 'deleteProperty' defined
        return true;       // true: indicate that property delete was allowed
    }
};

// Create proxy object.
var proxy = new Proxy(target, handler);

// Proxy object is then accessed normally.
print('foo' in proxy);
proxy.foo = 321;
print(proxy.foo);
delete proxy.foo;
```

A Proxy object can also be used to create a read-only version of an underlying
object (which is quite tedious otherwise):

```js
var proxy = new Proxy(target, {
    // has and get are omitted: existence checks and reads go through to the
    // target object automatically

    // set returns false: rejects write
    set: function () { return false; },

    // deleteProperty returns false: rejects delete
    deleteProperty: function () { return false; }
});
```

You can also create a write-only version of an object (which is not
possible otherwise):

```js
var proxy = new Proxy(target, {
    has: function() { throw new TypeError('has not allowed'); },
    get: function() { throw new TypeError('get not allowed'); }

    // set and deleteProperty are omitted: set/delete operations
    // are allowed and go through to the target automatically
});
```

The following is a more convoluted example combining multiple somewhat
artificial behaviors:

```js
var target = { foo: 'bar' };

/*
 *  - 'color' behaves like in the getter/setter example, cannot be deleted
 *    (attempt to do so causes a TypeError)
 *
 *  - all string values are uppercased when read
 *
 *  - property names beginning with an underscore are read/write/delete
 *    protected in a few different ways, and their existence is denied
 */

var handler = {
    has: function (targ, key) {
        // this binding: handler table
        // targ: underlying plain object (= target, above)

        if (typeof key === 'string' && key[0] === '_') {
            // pretend that property doesn't exist
            return false;
        }

        return key in targ;
    },

    get: function (targ, key, recv) {
        // this binding: handler table
        // targ: underlying plain object (= target, above)
        // key: key (can be any value, not just a string)
        // recv: object being read from (= the proxy object)

        if (typeof key === 'string' && key[0] === '_') {
            throw new TypeError('attempt to access a read-protected property');
        }

        // Return value: value provided as property lookup result.
        var val = targ[key];
        return (typeof val === 'string' ? val.toUpperCase() : val);
    },

    set: function (targ, key, val, recv) {
        // this binding: handler table
        // targ: underlying plain object (= target, above)
        // key: key (can be any value, not just a string)
        // val: value
        // recv: object being read from (= the proxy object)

        if (typeof key === 'string') {
            if (key === 'color') {
                if (!validateColor(val)) {
                    throw new TypeError('invalid color: ' + val);
                }
                targ.color = val;
                redraw();

                // True: indicates to caller that property write allowed.
                return true;
            } else if (key[0] === '_') {
                // False: indicates to caller that property write rejected.
                // In non-strict mode this is ignored silently, but in strict
                // mode a TypeError is thrown.
                return false;
            }
        }

        // Write to target.  We could also return true without writing to the
        // target to simulate a successful write without changing the target.
        targ[key] = val;
        return true;
    },

    deleteProperty: function (targ, key) {
        // this binding: handler table
        // targ: underlying plain object (= target, above)
        // key: key (can be any value, not just a string)

        if (typeof key === 'string') {
            if (key === 'color') {
                // For 'color' a delete attempt causes an explicit error.
                throw new TypeError('attempt to delete the color property');
            } else if (key[0] === '_') {
                // False: indicates to caller that property delete rejected.
                // In non-strict mode this is ignored silently, but in strict
                // mode a TypeError is thrown.
                return false;
            }
        }

        // Delete from target.  We could also return true without deleting
        // from the target to simulate a successful delete without changing
        // the target.
        delete targ[key];
        return true;
    }
};
```

The ES6 semantics reject some property accesses even if the trap would allow
it.  This happens if the proxy's target object has a non-configurable
conflicting property; see E6 Sections 9.5.7, 9.5.8, 9.5.9, and 9.5.10 for details.
You can easily avoid any such behaviors by keeping the target object empty and,
if necessary, backing the virtual properties in an unrelated plain object.

### Examples of enumerate and ownKeys traps

The `enumerate` trap is invoked for enumeration (`for (k in obj) { ... }`)
while the `ownKeys` trap is invoked by `Object.keys()` and `Object.getOwnPropertyNames()`.

To hide property names beginning with an underscore from enumeration and
`Object.keys()` and `Object.getOwnPropertyNames()`:

```js
var target = {
    foo: 1,
    bar: 2,
    _quux: 3,
    _baz: 4
};

var proxy = new Proxy(target, {
    enumerate: function (targ) {
        // this binding: handler table
        // targ: underlying plain object (= target, above)

        return Object.getOwnPropertyNames(targ)
                     .filter(function (v) { return v[0] !== '_'; });
    },

    ownKeys: function (targ) {
        return Object.getOwnPropertyNames(targ)
                     .filter(function (v) { return v[0] !== '_'; });
    }
});

function test() {
    for (var k in proxy) {
        print(k);  // prints 'foo' and 'bar'
    }
}
test();

print(Object.keys(proxy));                 // prints 'foo,bar'
print(Object.getOwnPropertyNames(proxy));  // prints 'foo,bar'
```

### Using Proxy with a constructor function

If a constructor returns an object value, that value replaces the
automatically created default instance available to the constructor
as the `this` binding
[E5.1 Section 13.2.2](http://www.ecma-international.org/ecma-262/5.1/#sec-13.2.2).
This allows a Proxy object to be returned from a constructor as the result
of a constructor call.

It's also possible to initialize the `this` object normally, and
then wrap it behind a proxy (see
[test-bi-proxy-in-constructor.js](https://github.com/svaarala/duktape/blob/master/tests/ecmascript/test-bi-proxy-in-constructor.js)):

```js
function MyConstructor() {
    // Initialize 'this' normally
    this.foo = 'bar';

    // Wrap it behind a proxy
    return new Proxy(this, {
        // proxy traps
    });
}

var obj = new MyConstructor();
```

## Mechanisms not supported by Duktape

There are various non-standard mechanisms for property virtualization.
These are **not supported** by Duktape:

* [Object.prototype.watch()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/watch)
