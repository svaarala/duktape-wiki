# How to work with buffers in Duktape 1.x

**This page applies to Duktape 1.x only.**

## Overview

Up to Duktape 1.2 all buffer values (plain buffers and Duktape.Buffer objects)
were Duktape specific.  Khronos/ES2015 typed arrays and Node.js Buffer objects
were added in Duktape 1.3, with custom types still supported for backwards
compatibility.  The plain buffer type is likely not going away (it is memory
efficient and often enough) but the `Duktape.Buffer` type might be deprecated
in a later version because it overlaps with `ArrayBuffer`.

Duktape provides the following buffer and buffer-related types:

<table>
<tr>
<th>Type</th>
<th>Standard</th>
<th>Duktape version</th>
<th>Description</th>
</tr>
<tr>
<td>Plain buffer</td>
<td>No<br />Duktape&nbsp;specific</td>
<td>1.0</td>
<td>Plain, primitive buffer value (not an object), similar to how a plain string relates to a String object</td>
</tr>
<tr>
<td>Duktape.Buffer object</td>
<td>No<br />Duktape&nbsp;specific</td>
<td>1.0</td>
<td>Object wrapped plain buffer, similar to how a String object relates to a plain string</td>
</tr>
<tr>
<td>Node.js Buffer object</td>
<td>No<br />Node.js-like</td>
<td>1.3</td>
<td>Object with <a href="https://nodejs.org/api/buffer.html">Node.js Buffer API</a></td>
</tr>
<tr>
<td>ArrayBuffer object</td>
<td>Yes<br />Khronos/ES2015</td>
<td>1.3</td>
<td>Standard object type for representing a byte array</td>
</tr>
<tr>
<td>DataView, typed array objects</td>
<td>Yes<br />Khronos/ES2015</td>
<td>1.3</td>
<td>View objects to access an underlying ArrayBuffer</td>
</tr>
</table>

The three kinds of buffer values have similarities and differences:

* Plain buffers and `Duktape.Buffer` are Duktape specific, and only provide
  an `uint8` access into an underlying buffer.  Plain buffers can be fixed,
  dynamic (resizable), or external (point to user controlled buffer outside
  of Duktape control).  A plain buffer value coerces to `Duktape.Buffer` at
  present, similarly to how a plain string object coerces to `String` object.
  (This behavior might later change so that a plain buffer coerces to
  `ArrayBuffer` which would allow `Duktape.Buffer` to be deprecated.)

* `ArrayBuffer` encapsulates a byte buffer.  Typed array objects are views
  into an underlying `ArrayBuffer`, e.g. `Uint32Array` provides a virtual
  array which maps to successive 32-bit values in the underlying array.  Typed
  arrays have host specific endianness and have alignment requirements with
  respect to the underlying buffer.  `DataView` provides a set of accessor for
  reading and writing arbitrarily aligned elements (integers and floats) in an
  underlying `ArrayBuffer`; endianness can be specified explicitly so
  `DataView` is useful for e.g. file format manipulation.

* Node.js `Buffer` provides both a `uint8` virtual array and a `DataView`-like
  set of element accessors, all in a single object.  Since Node.js is not a
  stable specification like ES2015, Node.js Buffers are more of a moving target
  than typed arrays.

Here's a more detailed table of each object type, including object properties,
coercion behavior, etc:

* <https://github.com/svaarala/duktape/blob/master/doc/buffers.rst#summary-of-buffer-related-values>

Because Khronos/ES2015 typed arrays is the best standard for buffers, that should
be the preferred choice for new code.  Here's a good tutorial on getting started
with typed arrays:

* <http://www.html5rocks.com/en/tutorials/webgl/typed_arrays/>

## Useful references

* [API calls tagged "buffer"](http://duktape.org/api.html#taglist-buffer)
  for dealing with plain buffers

* [API calls tagged "bufferobject"](http://duktape.org/api.html#taglist-bufferobject)
  for dealing with buffer objects

* [Khronos](https://www.khronos.org/registry/typedarray/specs/latest/) and
  [ES2015](http://www.ecma-international.org/ecma-262/6.0/index.html) typed array
  specifications
  ([ArrayBuffer constructor](http://www.ecma-international.org/ecma-262/6.0/index.html#sec-arraybuffer-constructor),
   [typed array constructors](http://www.ecma-international.org/ecma-262/6.0/index.html#sec-typedarray-constructors),
   [ArrayBuffer objects](http://www.ecma-international.org/ecma-262/6.0/index.html#sec-arraybuffer-objects),
   [DataView objects](http://www.ecma-international.org/ecma-262/6.0/index.html#sec-dataview-objects))

* [Node.js Buffer API](https://nodejs.org/api/buffer.html)

* [buffers.rst](https://github.com/svaarala/duktape/blob/master/doc/buffers.rst)
  describes the internals

## Creating buffers

<table>
<tr>
<th>Type</th>
<th>C</th>
<th>ECMAScript</th>
</tr>
<tr>
<td>plain buffer</td>
<td><a href="http://duktape.org/api.html#duk_push_buffer">duk_push_buffer()</a><br />
    <a href="http://duktape.org/api.html#duk_push_fixed_buffer">duk_push_fixed_buffer()</a><br />
    <a href="http://duktape.org/api.html#duk_push_dynamic_buffer">duk_push_dynamic_buffer()</a><br />
    <a href="http://duktape.org/api.html#duk_push_external_buffer">duk_push_external_buffer()</a></td>
<td><a href="http://duktape.org/guide.html#builtin-duktape-buffer">Duktape.Buffer()</a></td>
</tr>
<tr>
<td>Duktape.Buffer object</td>
<td><a href="http://duktape.org/api.html#duk_push_buffer_object">duk_push_buffer_object()</a></td>
<td><a href="http://duktape.org/guide.html#builtin-duktape-buffer">new Duktape.Buffer()</a></td>
</tr>
<tr>
<td>Node.js Buffer object</td>
<td><a href="http://duktape.org/api.html#duk_push_buffer_object">duk_push_buffer_object()</a></td>
<td><a href="https://nodejs.org/api/buffer.html#buffer_class_buffer">new Buffer()</a></td>
</tr>
<tr>
<td>ArrayBuffer object</td>
<td><a href="http://duktape.org/api.html#duk_push_buffer_object">duk_push_buffer_object()</a></td>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-arraybuffer-constructor">new ArrayBuffer()</a></td>
</tr>
<tr>
<td>DataView object</td>
<td><a href="http://duktape.org/api.html#duk_push_buffer_object">duk_push_buffer_object()</a></td>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-dataview-constructor">new DataView()</a></td>
</tr>
<tr>
<td>Typed array objects</td>
<td><a href="http://duktape.org/api.html#duk_push_buffer_object">duk_push_buffer_object()</a></td>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-typedarray-constructors">new Uint8Array()</a><br />
    <a href="http://www.ecma-international.org/ecma-262/6.0/#sec-typedarray-constructors">new Int32Array()</a><br />
    <a href="http://www.ecma-international.org/ecma-262/6.0/#sec-typedarray-constructors">new Float64Array()</a><br />
    etc</td>
</tr>
</table>

## Using buffers in ECMAScript code

### Plain buffer and Duktape.Buffer

A plain buffer value has virtual properties and provides index properties:

```js
// Create a plain buffer of 8 bytes
var plain = Duktape.Buffer(8);

// Fill it using index properties
for (var i = 0; i < plain.length; i++) {
    plain[i] = 0x41 + i;
}

// Print other virtual properties
print(plain.length);             // -> 8
print(plain.byteLength);         // -> 8
print(plain.byteOffset);         // -> 0
print(plain.BYTES_PER_ELEMENT);  // -> 1

// Because a plain buffer doesn't have an actual property table, new
// properties cannot be added (this behavior is similar to a plain string).
plain.dummy = 'foo';
print(plain.dummy);              // -> undefined

// Duktape JX format can be used for dumping
print(Duktape.enc('jx', plain)); // -> |4142434445464748|

// typeof is 'buffer'
print(typeof plain);             // -> buffer
```

A `Duktape.Buffer` is the "object counterpart" of a plain buffer.  It wraps
a plain buffer, similarly to how a `String` object wraps a plain string.
`Duktape.Buffer` also has the same virtual properties, and since it has an
actual property table, new properties can also be added normally.

```js
// Create a Duktape.Buffer object of 8 bytes
var buf = new Duktape.Buffer(8);

// Fill it using index properties
for (var i = 0; i < buf.length; i++) {
    buf[i] = 0x41 + i;
}

// Print other virtual properties
print(buf.length);             // -> 8
print(buf.byteLength);         // -> 8
print(buf.byteOffset);         // -> 0
print(buf.BYTES_PER_ELEMENT);  // -> 1

// Because a Duktape.Buffer has an actual property table, new properties
// can be added normally (this behavior is similar to a String object).
buf.dummy = 'foo';
print(buf.dummy);              // -> foo

// Duktape JX format can be used for dumping
print(Duktape.enc('jx', buf)); // -> |4142434445464748|

// typeof is 'object'
print(typeof buf);                // -> object

// typeof behavior mimics how plain string and String object work
print(typeof 'foo');              // -> string
print(typeof new String('foo'));  // -> object
```

You can easily convert between the two:

```js
var plain1 = Duktape.Buffer(8);

// Convert a plain buffer to a Duktape.Buffer, both pointing to the same
// underlying buffer.
var buf = new Duktape.Buffer(plain1)

// Get the plain buffer wrapped inside a Duktape.Buffer.
var plain2 = Duktape.Buffer(buf);

// No copies are made of 'plain1' in this process.
print(plain1 === plain2);  // -> true
```

To summarize, the main differences between a plain buffer and a
`Duktape.Buffer` are:

* A plain buffer is created using `Duktape.Buffer(length)`, i.e. when
  called as a normal function.  A `Duktape.Buffer` is created using
  `new Duktape.Buffer(length)`, i.e. when called as a constructor.
  This behavior mimics how plain strings and `String` objects work.

* A `Duktape.Buffer` has a property table so that new properties can
  be added if necessary.

* A `Duktape.Buffer` can have a finalizer, a plain buffer cannot.

* Typeof of a plain buffer is `buffer` while typeof of a `Duktape.Buffer`
  is `object`.  This again mimics how plain strings and `String` objects
  work.

### Typed arrays

Typed arrays are used in ECMAScript code like with other engines, see
e.g. the following tutorial:

* <http://www.html5rocks.com/en/tutorials/webgl/typed_arrays/>

There are some custom behaviors discussed later in this document.

### Node.js Buffers

Node.js Buffers are used like with Node.js/V8, see e.g.:

* <https://nodejs.org/api/buffer.html>

There are some custom behaviors discussed later in this document.

### JSON and JX serialization

The Node.js Buffer type has a `.toJSON()` method so it gets serialized in
standard `JSON.stringify()`:

```js
var buf = new Buffer('ABCD');
print(JSON.stringify(buf));

// Output:
// {"type":"Buffer","data":[65,66,67,68]}
```

`Duktape.Buffer`, `ArrayBuffer`, and typed array views don't have a `.toJSON()`
so they'll be skipped by standard `JSON.stringify()`:

```js
var buf = Duktape.dec('hex', 'deadbeef');
print(JSON.stringify([ 1, buf, 2 ]));

// Output:
// [1,null,2]
```

You can of course add a `.toJSON()` yourself:

```js
Uint8Array.prototype.toJSON = function (v) {
    var res = [];
    var nybbles = '0123456789abcdef';
    var u8 = this;
    for (var i = 0; i < u8.length; i++) {
        res[i] = nybbles[(u8[i] >> 4) & 0x0f] +
                 nybbles[u8[i] & 0x0f];
    }
    return res.join('');
};
var u8 = new Uint8Array([ 0x41, 0x42, 0x43, 0x44 ]);
print(JSON.stringify({ myBuffer: u8 }));

// Output:
// {"myBuffer":"41424344"}
```

Duktape JX format supports all buffer objects directly, encoding them like
plain buffers:

```js
var u8 = new Uint8Array([ 0x41, 0x42, 0x43, 0x44 ]);
print(Duktape.enc('jx', { myBuffer: u8 }));

// Output:
// {myBuffer:|41424344|}
```

JX respects slice information:

```js
var u8a = new Uint8Array([ 0x41, 0x42, 0x43, 0x44 ]);
var u8b = u8a.subarray(2);
print(Duktape.enc('jx', { myBuffer: u8a, mySlice: u8b }));

// Output:
// {myBuffer:|41424344|,mySlice:|4344|}
```

Node.js Buffers, having a `.toJSON()`, will still serialize like with
`JSON.stringify()` because `.toJSON()` takes precedence over JX built-in
buffer serialization.

## Using buffers in C code

### Typing

Plain buffers and buffer objects work a bit differently in the C API:

- Plain buffer stack type is `DUK_TYPE_BUFFER` and they test true for
  `duk_is_buffer()`.

- Buffer object stack type is `DUK_TYPE_OBJECT` and they test false for
  `duk_is_buffer()`.

This mimics how strings currently work in the API: `String` object also
have the `DUK_TYPE_OBJECT` type tag and test false for `duk_is_string()`.
However, this will probably change at a later time so that plain buffers
and buffer objects (and plain strings and `String` objects) can be used
interchangeably.

### Plain buffers

#### Working with a plain fixed buffer

A fixed buffer cannot be resized after its creation, but it is the most
memory efficient buffer type and has a stable data pointer.  To create a
fixed buffer:

```c
unsigned char *ptr;

ptr = (unsigned char *) duk_push_fixed_buffer(ctx, 256 /*size*/);

/* You can now safely read/write between ptr[0] ... ptr[255] until the
 * buffer is collected.
 */
```

#### Working with a plain dynamic buffer

A dynamic buffer can be resized after its creation, but requires two heap
allocations to allow resizing.  The data pointer of a dynamic buffer may
change in a resize, so you must re-lookup the data pointer from the buffer
may have been resized.  Safest is to re-lookup right before accessing:

```c
unsigned char *ptr;
duk_size_t len;

/* Create a dynamic buffer, can be resized later using
 * duk_resize_buffer().
 */
ptr = (unsigned char *) duk_push_dynamic_buffer(ctx, 64 /*size*/);

/* You can now safely read/write between ptr[0] ... ptr[63] until a
 * buffer resize (or garbage collection).
 */

/* The buffer can be resized later.  The resize API call returns the new
 * data pointer for convenience.
 */
ptr = (unsigned char *) duk_resize_buffer(ctx, -1, 256 /*new_size*/);

/* You can now safely read/write between ptr[0] ... ptr[255] until a
 * buffer resize.
 */

/* You can also get the current pointer and length explicitly.
 * The safest idiom is to do this right before reading/writing.
 */
ptr = (unsigned char *) duk_require_buffer(ctx, -1, &len);

/* You can now safely read/write between [0, len[. */
```

#### Working with a plain external buffer

An external buffer has a data area which is managed by user code: Duktape just
stores the current pointer and length and directs any read/write operations to
the memory range indicated.  User code is responsible for ensuring that this
data area is valid for reading and writing.

To create an external buffer:

```c
/* Imaginary example: external buffer is a framebuffer allocated here. */
size_t framebuffer_len;
unsigned char *framebuffer_ptr = init_my_framebuffer(&framebuffer_len);

/* Push an external buffer.  Initially its data pointer is NULL and length
 * is zero.
 */
duk_push_external_buffer(ctx);

/* Configure the external buffer for a certain memory area using
 * duk_config_buffer().  The pointer is not returned because the
 * caller already knows it.
 */
duk_config_buffer(ctx, -1, (void *) framebuffer_ptr, (duk_size_t) framebuffer_len);

/* You can reconfigure the external buffer later as many times as
 * necessary.
 */

/* You can also get the current pointer and length explicitly.
 * The safest idiom is to do this right before reading/writing.
 */
ptr = (unsigned char *) duk_require_buffer(ctx, -1, &len);
```

#### Type checking

All plain buffer variants have stack type `DUK_TYPE_BUFFER`:

```c
if (duk_get_type(ctx, idx_mybuffer) == DUK_TYPE_BUFFER) {
    /* value is a plain buffer (fixed, dynamic, or external) */
}
```

Or equivalently:

```c
if (duk_is_buffer(ctx, idx_mybuffer)) {
    /* value is a plain buffer (fixed, dynamic, or external) */
}
```

### Buffer objects

The Duktape C API for working with buffer objects is still experimental and
somewhat tentative, and may undergo slight changes in Duktape 1.4.

Here's a test case with some basic usage:

* <https://github.com/svaarala/duktape/blob/master/tests/api/test-bufferobject-example-1.c>

#### Creating buffer objects

Buffer objects and view objects are all created with the
[duk_push_buffer_object()](http://duktape.org/api.html#duk_push_buffer_object)
API call:

```c
/* Create an Uint16Array of 25 elements, backed by plain buffer at index -3,
 * starting from byte offset 100 and having byte length 50.
 */
duk_push_buffer_object(ctx,
                       -3 /*index of plain buffer*/,
                       100 /*byte offset*/,
                       50 /*byte length (!)*/,
                       DUK_BUFOBJ_UINT16ARRAY /*flags and type*/);
```

This is equivalent to:

```js
// Argument plain buffer
var plainBuffer = Duktape.Buffer(256);

// Create a Uint16Array over the existing plain buffer.
var view = new Uint16Array(new ArrayBuffer(plainBuffer),
                           100 /*byte offset*/,
                           25 /*length in elements (!)*/);

// Outputs: 25 100 50 2
print(view.length, view.byteOffset, view.byteLength, view.BYTES_PER_ELEMENT);
```

Note that the C call gets a **byte length** argument (50) while the ECMAScript
equivalent gets an **element length** argument (25).  This is intentional for
consistency: in the C API buffer lengths are always represented as bytes.

#### Getting buffer object data pointer

To get the data pointer and length of a buffer object (also works for a plain
buffer):

```c
unsigned char *ptr;
duk_size_t len;
duk_size_t i;

/* Get a data pointer to the active slice of a buffer object.  Also
 * accepts a plain buffer.
 */
ptr = (unsigned char *) duk_require_buffer_data(ctx, -3 /*idx*/, &len);

/* You can now safely access indices [0, len[ of 'ptr'. */
for (i = 0; i < len; i++) {
    /* Uppercase ASCII characters. */
    if (ptr[i] >= (unsigned char) 'a' && ptr[i] <= (unsigned char) 'z') {
        ptr[i] += (unsigned char) ('A' - 'a');
    }
}
```

#### Type checking

There's currently no explicit type check API call for checking whether a value
is a buffer object or not.  This is also the case for `String` objects: they
type check as `DUK_TYPE_OBJECT` instead of `DUK_TYPE_STRING` and there's no
other primitive to check their type.  Changing this behavior is tracked by:
<https://github.com/svaarala/duktape/issues/167>.

In practice this is not a big issue: you can simply call
`duk_require_buffer_data()` to get a data pointer and length.  The call will
fail unless the target value is either a plain buffer or a buffer object.
If the call returns normally, you can work with the data pointer and length.

### Pointer stability and validity

Any buffer data pointers obtained through the Duktape API are invalidated
when the plain buffer or buffer object is garbage collected.  **You must
ensure the buffer is reachable for Duktape while you use a data pointer**.

In addition to this, a buffer related data pointer may change from time to
time:

* For fixed buffers the data pointer is stable (until garbage collect).

* For dynamic buffers the data pointer may change when the buffer is
  resized using `duk_buffer_resize()`.

* For external buffers the data pointer may change when the buffer is
  reconfigured using `duk_buffer_config()`.

* For buffer objects pointer stability depends on the underlying plain
  buffer.

Duktape cannot protect user code against using a stale pointer so it's
important to ensure any data pointers used in C code are valid.  The safest
idiom is to always get the buffer data pointer explicitly before using it.
For example, by default you should get the buffer pointer before a loop
rather than storing it in a global (unless that is justified by e.g. a
measurable performance benefit):

```c
unsigned char *buf;
duk_size_t len, i;

buf = (unsigned char *) duk_require_buffer(ctx, -3 /*idx*/, &len);
for (i = 0; i < len; i++) {
    buf[i] ^= 0x80;  /* flip highest bit */
}
```

Because `duk_get_buffer_data()` and `duk_require_buffer_data()` work for both
plain buffers and buffer objects, this is more generic:

```c
unsigned char *buf;
duk_size_t len, i;

buf = (unsigned char *) duk_require_buffer_data(ctx, -3 /*idx*/, &len);
for (i = 0; i < len; i++) {
    buf[i] ^= 0x80;  /* flip highest bit */
}
```

#### Zero length buffers and NULL vs. non-NULL pointers

For technical reasons discussed below, **a buffer with zero length may have
either a `NULL` or a non-`NULL` data pointer**.  The pointer value doesn't
matter as such because when the buffer length is zero, no read/write is
allowed through the pointer (e.g. `ptr[0]` would refer to a byte outside the
valid buffer range).

However, this has a practical impact on structuring code:

```c
unsigned char *buf;
duk_size_t len;

buf = (unsigned char *) duk_get_buffer(ctx, -3, &len);
if (buf != NULL) {
    /* Value was definitely a buffer, buffer length may be zero. */
} else {
    /* Value was not a buffer -or- it might be a buffer with zero length
     * which also has a NULL data pointer.
     */
}
```

If you don't care about the typing, you can just ignore the pointer check
and rely on `len` alone: for non-buffer values the data pointer will be
`NULL` and length will be zero:

```c
unsigned char *buf;
duk_size_t len, i;

/* If value is not a buffer, buf == NULL and len == 0. */
buf = (unsigned char *) duk_get_buffer(ctx, -3, &len);

/* Can use 'buf' and 'len' directly.  However, note that if len == 0,
 * there's no valid dereference for 'buf'.  This is OK for loops like:
 */
for (i = 0; i < len; i++) {
    /* Never entered if len == 0. */
    printf("%i: %d\n", (int) i, (int) buf[i]);
}
```

If you don't want that ambiguity you can check for the buffer type
explicitly:

```c
unsigned char *buf;
duk_size_t len, i;

if (duk_is_buffer(ctx, -3)) {
    buf = (unsigned char *) duk_get_buffer(ctx, -3, &len);

    for (i = 0; i < len; i++) {
        /* Never entered if len == 0. */
        printf("%i: %d\n", (int) i, (int) buf[i]);
    }
}
```

If throwing an error for a non-buffer value is acceptable, this is perhaps
the cleanest approach:

```c
unsigned char *buf;
duk_size_t len, i;

buf = (unsigned char *) duk_require_buffer(ctx, -3, &len);

/* Value is definitely a buffer; buf may still be NULL but only if len == 0. */

for (i = 0; i < len; i++) {
    /* Never entered if len == 0. */
    printf("%i: %d\n", (int) i, (int) buf[i]);
}
```

The technical reason behind this behavior is different for each plain
buffer variant:

* The data area of a fixed buffer is allocated together with the buffer's
  heap header (it follows the header directly), so that the data pointer
  for a fixed buffer is always non-NULL, even if it has zero length.  The
  data pointer is simply: `(void *) ((duk_hbuffer *) heaphdr + 1)`.

* The data area of a dynamic buffer is allocated using separate alloc/realloc
  call.  ANSI C allows an implementation to return a `NULL` or some non-`NULL`
  pointer for a zero size `malloc()`/`realloc()`, as long as that pointer is
  properly ignored by a later `free()` call.  This behavior is allowed for
  Duktape allocation functions too.  Dynamic buffer zero length pointer
  behavior thus depends directly on the allocator functions used.

* The data area of an external buffer is controlled by user code.  User code
  can use a `NULL` or a non-`NULL` pointer for a zero length buffer; Duktape
  won't change the pointer value used.

## Mixed use

### Overview

Duktape allows some mixing of buffer types.  These mixing behaviors are
not defined in the Khronos/ES2015 or Node.js API specifications, so they are
necessarily Duktape custom behavior.  The buffer type mixing behavior in
Duktape 1.3 is a work in progress and likely to change in future versions.

To understand how mixing works, it's important to note that there are
really only two internal types for buffers:

* A plain buffer type, represented by three structs:
  `duk_hbuffer_fixed`, `duk_hbuffer_dynamic`, and `duk_hbuffer_external`.
  Plain buffers don't have properties, and cannot represent slices.

* A buffer object, represented by `duk_hbufferobject` (`duk_hbufobj` in
  Duktape 2.x).  This type is used to represent all buffer objects and
  buffer view objects, including `Duktape.Buffer`, Node.js `Buffer`,
  `ArrayBuffer`, `DataView`, and typed array views.  A buffer object points
  to a plain underlying buffer, provides an element type (`Uint8`, `Uint16`,
  etc), and may be a slice of the underlying buffer.

This allows for natural mixing, with some examples given below.

Duktape provides the same virtual properties (`.length`, `.byteLength`,
`.byteOffset`, `.BYTES_PER_ELEMENT`) for each buffer object type,
so that mixing them is more natural.  For example, all buffer object types
have `.byteOffset` and `.byteLength` properties even though they are not
required by the standards for all types.

### Duktape.Buffer(buf) returns the underlying plain buffer

Calling `Duktape.Buffer(buf)` (without `new`) returns the underlying plain
buffer of any buffer object.  If the argument is a plain buffer, it is
returned as is.  For example:

```js
var buf = new ArrayBuffer(16);
var u32 = new Uint32Array(buf);
var plain_buf = Duktape.Buffer(buf);
var plain_u32 = Duktape.Buffer(u32);
print(plain_buf === plain_u32);  // the same plain buffer is returned
```

Because a plain buffer cannot represent slice information (offset and length
into the buffer), that information is lost in the process.  For example:

```js
var buf = new ArrayBuffer(64);
var u32 = new Uint32Array(buf, 4, 7);   // offset 4, length 7x4=28 bytes
print(u32.length);                      // prints: 7, i.e. element count
print(u32.byteOffset, u32.byteLength);  // prints 4, 28
var plain = Duktape.Buffer(u32);
print(plain.length);                    // prints: 64, because underlying
                                        // buffer is 64 bytes long
```

All buffer object types provide `.byteOffset` and `.byteLength` properties
which allow you to read the slice information manually, and take it into
account when e.g. dumping or converting buffers.

### ArrayBuffer and Node.js Buffer constructors accept a plain buffer

You can construct an ArrayBuffer using a plain buffer.  The plain buffer
becomes the underlying buffer without a copy being made:

```js
var plain = Duktape.dec('hex', '4142434445464748');
var buf = new ArrayBuffer(plain);
buf[0] = 0x61;
print(plain[0], buf[0]);  // same value because both back to 'plain'
```

Similarly for Node.js Buffer:

```js
var plain = Duktape.dec('hex', '4142434445464748');
var buf = new Buffer(plain);
buf[0] = 0x61;
print(plain[0], buf[0]);  // same value because both back to 'plain'
```

This behavior allows you to transfer an underlying buffer from one type to
another without copying.  For example, to create an ArrayBuffer from a
Node.js Buffer so that both share the same underlying buffer:

```js
var nodeBuffer = new Buffer('ABCDEFGH');
var plainBuffer = Duktape.Buffer(nodeBuffer);
var arrayBuffer = new ArrayBuffer(plainBuffer);
arrayBuffer[0] = 0x61;  // visible through nodeBuffer too
print(JSON.stringify(nodeBuffer));  // -> {"type":"Buffer","data":[97,66,67,68,69,70,71,72]}
```

Slice information is lost in the `Duktape.Buffer(nodeBuffer)` call, so if you
want to preserve that information into e.g. a `Uint8Array` sharing the same
underlying buffer, you need to carry over the information manually:

```js
var nodeBuffer = new Buffer('ABCDEFGH');
var nodeSlice = nodeBuffer.slice(3, 6);  // 'DEF' part of nodeBuffer
var plainBuffer = Duktape.Buffer(nodeSlice);
var arrayBuffer = new ArrayBuffer(plainBuffer);
var u8Slice = new Uint8Array(arrayBuffer, nodeSlice.byteOffset, nodeSlice.byteLength);
u8Slice[0] = 0xff;  // visible through nodeBuffer too

// Slices now map to the same underlying buffer
print(nodeSlice.length, u8Slice.length);  // 3 for both
print(JSON.stringify(nodeSlice));   // -> {"type":"Buffer","data":[255,69,70]}

// The full nodeBuffer has been modified through the slices
print(JSON.stringify(nodeBuffer));  // -> {"type":"Buffer","data":[65,66,67,255,69,70,71,72]}
```

Or less verbosely:

```js
var nodeSlice = new Buffer('ABCDEFGH').slice(3, 6);
var arrayBuffer = new ArrayBuffer(Duktape.Buffer(nodeSlice));
var u8Slice = new Uint8Array(arrayBuffer, nodeSlice.byteOffset, nodeSlice.byteLength);
```

This is still not very convenient so "slice copying" may need improvements in
future versions.

### Typed array constructors accept a plain buffer argument since Duktape 1.4.0

Typed array constructors recognize objects as potential providers of
initialization values, e.g. as:

```
duk> u8 = new Uint8Array([ 0x41, 0x42, 0x43, 0x44 ]); Duktape.enc('jx', u8);
= |41424344|
```

`Duktape.Buffer` values as similarly treated as value initializers, and since
Duktape 1.4.0 a plain buffer value is treated the same as a `Duktape.Buffer`:

```
duk> buf = new Duktape.Buffer('foo'); Duktape.enc('jx', new Int16Array(buf));
= |66006f006f00|
duk> buf = Duktape.Buffer('foo'); Duktape.enc('jx', new Int16Array(buf));
= |66006f006f00|
```

Because the argument is treated as an initializer, a new underlying buffer
will be created instead of sharing the existing one.

Non-object arguments are integer coerced and used as a length for the new
`ArrayBuffer` automatically created (Duktape 1.3.0 would treat plain buffers
this way too, which is quite confusing).  For example the string `"5"` gets
treated as a length:

```js
var u8 = new Uint8Array("5");
print(u8.byteLength);  // -> 5
```

If you want to reuse a plain buffer as the underlying buffer of a typed
array, you need to go through an `ArrayBuffer` which does recognize plain
buffers specially:

```js
var plain = Duktape.dec('hex', '4142434445464748');
var u8 = new Uint8Array(new ArrayBuffer(plain));
print(u8.byteLength);  // -> 8
u8[2] = 0xff;

// Both 'plain' and 'u8' were modified because 'plain' is the shared
// underlying buffer.
print(Duktape.enc('jx', plain));  // -> |4142ff4445464748|
print(Duktape.enc('jx', u8));     // -> |4142ff4445464748|
```

### Typed array constructors interpret other buffer objects as value arrays

When a buffer object is given as an argument to `new Uint32Array()` or other
typed array constructor, a new underlying buffer is created and the argument
buffer object is interpreted as a value array: values are conceptually read
from the argument (as if it was a plain array) and are then coerced and
written into the underlying `ArrayBuffer` through the view being constructed.
There are internal fast paths for common cases so that direct memory copying
is used when possible.

For example, if the argument is a `Int8Array` and the target is a `Int32Array`
the 8-bit signed values get signed extended to 32 bits and written to the
result array with platform dependent endianness:

```js
var i8 = new Int8Array([ -128, -1, 0, 127 ]);  // 0x80 0xff 0x00 0x7f
var i32 = new Int32Array(i8);
print(i8.byteLength);  // -> 4
print(i32.byteLength); // -> 16
print(Duktape.enc('jx', Duktape.Buffer(i32)));

// Output on a little endian machine:
//
// |80ffffffffffffff000000007f000000|
```

This behavior is available for typed array constructors but *not* for the
`ArrayBuffer` constructor (this is defined in Khronos/ES2015 specifications).

As a custom buffer type mixing behavior, the typed array constructors allow
any buffer object to be used as input.  For example, to initialize a new
view (and a new underlying `ArrayBuffer`) using a Node.js Buffer as input:

```js
var nodeBuffer = new Buffer('ABCDEFGH');
var u16 = new Uint16Array(nodeBuffer);
print(Duktape.enc('jx', Duktape.Buffer(u16)));

// Output on a little endian machine:
//
// |41004200430044004500460047004800|
```

Starting from Duktape 1.4.0 a plain buffer argument is treated the same as
`Duktape.Buffer`, i.e. used as a value initializer.

## Avoiding Duktape custom behaviors

As a general rule it is best to start with Khronos/ES2015 typed arrays because
they are the "best standard" for buffers in ECMAScript.  When doing so, avoid
Duktape specific behavior unless you really need to.  Particular gotchas are
discussed below.

### Avoid index properties on ArrayBuffer

Duktape allows indexed access of `ArrayBuffer` which Khronos/ES2015 does not:

```js
var buf = new ArrayBuffer(4);
buf[0] = 123;  // works in Duktape, custom
```

The standard version is:

```js
var buf = new ArrayBuffer(4);
var u8 = new Uint8Array(buf);
u8[0] = 123;
```

Or more compactly:

```js
var u8 = new Uint8Array(4);  // shorthand
u8[0] = 123;
```

### Avoid custom properties

These extra properties are provided by Duktape, avoid them if possible:

* Node.js Buffer:

  - byteLength (length is standard)
  - byteOffset
  - BYTES_PER_ELEMENT (= 1)

* ArrayBuffer:

  - Index properties (`buf[123]`)
  - length (byteLength is standard)
  - byteOffset
  - BYTES_PER_ELEMENT (= 1)

* Typed arrays

  - No extra properties

* DataView

  - length (byteLength is standard)
  - BYTES_PER_ELEMENT (= 1)

These properties are useful in Duktape specific code because they allow
uniform handling of different buffer objects.  They also allow some memory
savings, e.g. you can read/write `ArrayBuffer` using index properties without
creating a temporary `Uint8Array` object.

### Avoid relying on memory zeroing of Node.js Buffers

Khronos/ES2015 specification requires that new `ArrayBuffer` values be filled
with zeroes.  Starting from Duktape 1.4.0, Duktape follows this even when the
`DUK_USE_ZERO_BUFFER_DATA` config option is turned off.

Node.js does *not* zero allocated `Buffer` objects by default.  Duktape
zeroes Node.js `Buffer` objects too, unless the `DUK_USE_ZERO_BUFFER_DATA`
config option is turned off.

## Security considerations

Duktape guarantees that no out-of-bounds accesses are possible to an
underlying plain buffer by any ECMAScript code.

This guarantee is in place even if you initialize a buffer object using a
dynamic plain buffer which is then resized so that the conceptual buffer
object extends beyond the resized buffer.  In such cases Duktape doesn't
provide very clean behavior (some operations return zero, others may throw
a TypeError, etc) but the behavior is guaranteed to be memory safe.  This
situation is illustrated (and tested for) in the following test case:

* <https://github.com/svaarala/duktape/blob/master/tests/api/test-bufferobject-dynamic-safety.c>

C code interacting with buffers through property reads/writes is guaranteed
to be memory safe.  C code may fetch a pointer and a length to an underlying
buffer and operate on that directly; memory safety is up to user code in that
situation.

When an external plain buffer is used, it's up to user code to ensure that
the pointer and length configured into the buffer are valid, i.e. all bytes
in that range are readable and writable.  If this is not the case, memory
unsafe behavior may happen.
