# How to persist Duktape/C arguments across calls

When a Duktape/C function is called, Duktape places the call arguments on the
value stack.  While the arguments are on the value stack, they're guaranteed
to be reachable and the Duktape/C function can safely work with the arguments.

However, when the Duktape/C function returns, the value stack is unwound and
references in the function's value stack frame are lost.  If the last reference
to a particular value was in the function's value stack frame, the value will
be garbage collected when the function return is processed.

Sometimes Duktape/C functions need to store longer term references to argument
values.  One common example is implementing a `setTimeout()`-like function,
which we'll use as a running example here:

```js
setTimeout(function cb() {
    print('called after 1 second');
}, 1000);
```

The basic issues in implementing such a function are:

* The Duktape/C function needs to store a reference to the persisted value
  somewhere to prevent garbage collection.  In other words, the value must
  be reachable from Duktape's garbage collector point of view.

* Another Duktape/C function needs to be able to look up the reference to
  be able to call the callback function.  If there are multiple registered
  callbacks they may need to be assigned e.g. a string/number identifier as
  a lookup handle.

## Storing a persistent reference

### Global object

If one were to implement `setTimeout()` in pure Ecmascript, the reference
would be stored to the global object.  You can do the same in a Duktape/C
function.

### Stash objects

You can store references in Duktape's "stash" objects.  They are similar to
the global object but are not (easily) reachable from Ecmascript code:

- <http://duktape.org/api.html#duk_push_heap_stash>
- <http://duktape.org/api.html#duk_push_global_stash>
- <http://duktape.org/api.html#duk_push_thread_stash>

### Any reachable object

You can store a reference as a property of any reachable object; the object
may be reachable through the global object, the stashes, the current thread,
etc.  For example:

- Initialize `globalObject.callbacks` to an empty array and manage callbacks
  as array elements.  Callback IDs can be array indices directly.
- Initialize `globalStash.callbacks` to an empty object and manage callbacks
  as (string keyed) properties of the object.  Callback IDs can be the string
  keys directly.

## Example using a single global variable

The most trivial approach is simply to store the callback as a global
variable.  In Ecmascript one would simply:

```js
var _callbackFunc;  // single callback function

function setTimeout(cb, timeout) {
    if (typeof cb !== 'function') {
        throw new TypeError('callback not a function');
    }
    _callbackFunc = cb;
}

// Later on, a scheduler would call this
function invokeCallback() {
    var fn = _callbackFunc;
    _callbackFunc = null;
    fn();  // TypeError if not set
}
```

The C equivalent of this would be something like:

```c
duk_ret_t native_set_timeout(duk_context *ctx) {
    long timeout;
    duk_require_function(ctx, 0);
    timeout = (long) duk_require_uint(ctx, 1);

    duk_dup(ctx, 0);
    duk_put_global_string(ctx, "_callbackFunc");
    return 0;
}

duk_ret_t native_invoke_callback(duk_context *ctx) {
    duk_get_global_string(ctx, "_callbackFunc");
    duk_push_null(ctx);
    duk_put_global_string(ctx, "_callbackFunc");
    duk_call(ctx, 0);
    return 0;
}
```

In practice it's useful to detect a missing callback and perhaps log callback
errors:

```c
duk_ret_t native_invoke_callback(duk_context *ctx) {
    duk_int_t rc;

    /* Get current callback. */
    duk_get_global_string(ctx, "_callbackFunc");

    /* Explicit check for callback existence; log and exit if no callback. */
    if (!duk_is_function(ctx, -1)) {
        printf("No callback registered\n");
        return 0;
    }

    /* Remove registered callback to avoid calling again. */
    duk_push_null(ctx);
    duk_put_global_string(ctx, "_callbackFunc");

    /* Protected call, log callback errors. */
    rc = duk_pcall(ctx, 0);
    if (rc != 0) {
        printf("Callback failed: '%s'\n", duk_safe_to_string(ctx, -1));
    }
    duk_pop(ctx);

    return 0;
}
```

Changing the callback data structure to hold multiple callbacks, assigning
callbacks number or string IDs etc are straightforward extensions of this
basic pattern.
