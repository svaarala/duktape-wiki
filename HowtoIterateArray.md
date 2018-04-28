# How to iterate over an array

## ECMAScript code

The fastest way to iterate over an array is:

```js
var i, n, e;
for (i = 0, n = arr.length; i < n; i++) {
    e = arr[i];
    // operate on 'e'
}
```

Looking up `.length` in the loop condition (`i < arr.length`) is a bit
slower, and using `arr.forEach()` is a lot slower.

## Native code

The basic approach uses `duk_get_length()` to get the array length and
`duk_get_prop_index()` to request for array elements:

```c
duk_size_t i, n;

n = duk_get_length(ctx, idx_target);
for (i = 0; i < n; i++) {
    duk_get_prop_index(ctx, idx_target, i);
    /* ... */
    duk_pop(ctx);
}
```

If you don't check for an array explicitly, the loop will also work for:

- Any object with a `.length` property (buffer objects, typed array views, etc)
- Plain strings (iterating over codepoints)
- Plain buffers (iterating over bytes)

If this is not desirable, check for the value type using `duk_is_array()`:

```c
duk_size_t i, n;

if (!duk_is_array(ctx, idx_target)) {
    /* not an array */
    return;
}

n = duk_get_length(ctx, idx_target);
for (i = 0; i < n; i++) {
    duk_get_prop_index(ctx, idx_target, i);
    /* ... */
    duk_pop(ctx);
}
```

If you need to handle missing elements specifically (rather than just treating
them like an `undefined` value):

```js
duk_size_t i, n;

n = duk_get_length(ctx, idx_target);
for (i = 0; i < n; i++) {
    if (duk_get_prop_index(ctx, idx_target, i)) {
        /* element is present */
    } else {
        /* element is not present */
    }
    duk_pop(ctx);
}
```
