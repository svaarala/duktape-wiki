# How to work with buffers in Duktape 2.x

## Introduction

### Overview of buffer types

<table>
<tr>
<th>Buffer type</th>
<th>Standard</th>
<th>C API type</th>
<th>Ecmascript type</th>
<th>Description</th>
</tr>
<tr>
<td>Plain buffer</td>
<td>No<br />Duktape&nbsp;specific</td>
<td>DUK_TAG_BUFFER</td>
<td>[object Uint8Array]</td>
<td>Plain memory-efficient buffer value (not an object).  Mimics an Uint8Array
    for most Ecmascript behavior, separate type in C API.  Object coerces to an
    actual Uint8Array instance.  Has virtual index properties.  (Behavior
    changed in Duktape 2.x.)</td>
</tr>
<tr>
<td>ArrayBuffer object</td>
<td>Yes<br />ES2015</td>
<td>DUK_TAG_OBJECT</td>
<td>[object ArrayBuffer]</td>
<td>Standard object type for representing a byte array.  Has additional
    non-standard virtual index properties.</td>
</tr>
<tr>
<td>DataView, typed array objects</td>
<td>Yes<br />ES2015</td>
<td>DUK_TAG_OBJECT</td>
<td>[object Uint8Array], etc</td>
<td>Standard view objects to access an underlying ArrayBuffer.</td>
</tr>
<tr>
<td>Node.js Buffer object</td>
<td>No<br />Node.js-like</td>
<td>DUK_TAG_OBJECT</td>
<td>[object Uint8Array]</td>
<td>Object with <a href="https://nodejs.org/api/buffer.html">Node.js Buffer API</a>.
    Currently tracked Node.js version is 6.7.0; Duktape tracks the latest with
    some delay.</td>
</tr>
</table>

### ArrayBuffer and typed arrays recommended

New code should use ES2015 ArrayBuffers and typed arrays (such as Uint8Array)
unless there's a good reason for doing otherwise.  Here's one tutorial on
getting started with typed arrays:

* http://www.html5rocks.com/en/tutorials/webgl/typed_arrays/

`ArrayBuffer` encapsulates a byte buffer.  Typed array objects are views
into an underlying `ArrayBuffer`, e.g. `Uint32Array` provides a virtual
array which maps to successive 32-bit values in the underlying array.  Typed
arrays have host specific endianness and have alignment requirements with
respect to the underlying buffer.  `DataView` provides a set of accessor for
reading and writing arbitrarily aligned elements (integers and floats) in an
underlying `ArrayBuffer`; endianness can be specified explicitly so
`DataView` is useful for e.g. file format manipulation.

### Plain buffers for low memory environments

For very low memory environments plain buffers can be used in places where an
Uint8Array would normally be used.  Plain buffers mimic Uint8Array behavior
quite closely for Ecmascript code so often only small Ecmascript code changes
are needed when moving between actual Uint8Arrays and plain buffers.  C code
needs to be aware of the typing difference, however.

Plain buffers only provide an `uint8` access into an underlying buffer.
Plain buffers can be fixed, dynamic (resizable), or external (point to user
controlled buffer outside of Duktape control).  A plain buffer value object
coerces to a `Uint8Array` object, similarly to how a plain string object
coerces to `String` object.

When buffer object support is disabled in Duktape configuration, only plain
buffers will be available.  They will inherit from Uint8Array.prototype which
is reachable via plain buffer values (e.g. `buf.__proto__`) but isn't
registered to the global object.  All the typed array methods will be absent;
the intent is to mostly work with the buffers from C code.

### Node.js Buffer bindings

Node.js Buffer bindings are useful when working with Node.js compatible code.

Node.js `Buffer` provides both a `uint8` virtual array and a `DataView`-like
set of element accessors, all in a single object.  Since Node.js is not a
stable specification like ES2015, Node.js Buffers are more of a moving target
than typed arrays.

### Buffer type mixing supported but not recommended

Because the internal data type for all buffer objects is the same, they can be
mixed to some extent.  For example, Node.js `Buffer.concat()` can be used to
concatenate any buffer types.  However, the mixing behavior is liable to change
over time so you should avoid mixing unless there's a clear advantage in doing
so.

### Changes going forward

The most likely development direction for future releases is to:

* Follow ES2015+ more and more closely for buffer semantics.

* Make the standard types more memory and performance efficient.

* Eliminate the C API distinction between plain buffers and typed array
  objects.

### Useful references

* [API calls tagged "buffer"](http://duktape.org/api.html#taglist-buffer)
  for dealing with plain buffers

* [API calls tagged "bufferobject"](http://duktape.org/api.html#taglist-bufferobject)
  for dealing with buffer objects

* [ES2015](http://www.ecma-international.org/ecma-262/6.0/index.html) typed array
  specification
  ([ArrayBuffer constructor](http://www.ecma-international.org/ecma-262/6.0/index.html#sec-arraybuffer-constructor),
   [typed array constructors](http://www.ecma-international.org/ecma-262/6.0/index.html#sec-typedarray-constructors),
   [ArrayBuffer objects](http://www.ecma-international.org/ecma-262/6.0/index.html#sec-arraybuffer-objects),
   [DataView objects](http://www.ecma-international.org/ecma-262/6.0/index.html#sec-dataview-objects))

* [Node.js Buffer API](https://nodejs.org/api/buffer.html)

* [buffers.rst](https://github.com/svaarala/duktape/blob/master/doc/buffers.rst)
  describes the internals

  - A more detailed table of each object type, including object properties,
    coercion behavior, etc: https://github.com/svaarala/duktape/blob/master/doc/buffers.rst#summary-of-buffer-related-values

## API summary

### Creating buffers

<table>
<tr>
<th>Type</th>
<th>C</th>
<th>Ecmascript</th>
<th>Notes</th>
</tr>
<tr>
<td>plain buffer</td>
<td><a href="http://duktape.org/api.html#duk_push_buffer">duk_push_buffer()</a><br />
    <a href="http://duktape.org/api.html#duk_push_fixed_buffer">duk_push_fixed_buffer()</a><br />
    <a href="http://duktape.org/api.html#duk_push_dynamic_buffer">duk_push_dynamic_buffer()</a><br />
    <a href="http://duktape.org/api.html#duk_push_external_buffer">duk_push_external_buffer()</a></td>
<td>Uint8Array.allocPlain()<br />
    Uint8Array.plainOf()</td>
<td>Uint8Array.plainOf() gets the underlying plain buffer from any buffer
    object without creating a copy.  Slice offset/length information is lost.</td>
</tr>
<tr>
<td>ArrayBuffer object</td>
<td><a href="http://duktape.org/api.html#duk_push_buffer_object">duk_push_buffer_object()</a></td>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-arraybuffer-constructor">new ArrayBuffer()</a></td>
<td>&nbsp;</td>
</tr>
<tr>
<td>DataView object</td>
<td><a href="http://duktape.org/api.html#duk_push_buffer_object">duk_push_buffer_object()</a></td>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-dataview-constructor">new DataView()</a></td>
<td>&nbsp;</td>
</tr>
<tr>
<td>Typed array objects</td>
<td><a href="http://duktape.org/api.html#duk_push_buffer_object">duk_push_buffer_object()</a></td>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-typedarray-constructors">new Uint8Array()</a><br />
    <a href="http://www.ecma-international.org/ecma-262/6.0/#sec-typedarray-constructors">new Int32Array()</a><br />
    <a href="http://www.ecma-international.org/ecma-262/6.0/#sec-typedarray-constructors">new Float64Array()</a><br />
    etc</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>Node.js Buffer object</td>
<td><a href="http://duktape.org/api.html#duk_push_buffer_object">duk_push_buffer_object()</a></td>
<td><a href="https://nodejs.org/api/buffer.html#buffer_class_buffer">new Buffer()</a></td>
<td>&nbsp;</td>
</tr>
</table>

When a typed array is created an ArrayBuffer object is also created and
available as the `.buffer` property of the typed array.  Duktape 2.0 creates
the ArrayBuffer when the typed array is created, but Duktape 2.1 creates the
ArrayBuffer lazily on first read of the `.buffer` property.

### Type checking buffers

<table>
<tr>
<th>Type</th>
<th>C</th>
<th>Ecmascript</th>
<th>Notes</th>
</tr>
<tr>
<td>plain buffer</td>
<td><a href="http://duktape.org/api.html#duk_is_buffer">duk_is_buffer()</a><br />
    <a href="http://duktape.org/api.html#duk_is_buffer_data">duk_is_buffer_data()</a></td>
<td>n/a</td>
<td></td>
</tr>
<tr>
<td>ArrayBuffer object</td>
<td><a href="http://duktape.org/api.html#duk_is_buffer_data">duk_is_buffer_data()</a></td>
<td>v instanceof ArrayBuffer</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>DataView object</td>
<td><a href="http://duktape.org/api.html#duk_is_buffer_data">duk_is_buffer_data()</a></td>
<td>v instanceof DataView</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>Typed array objects</td>
<td><a href="http://duktape.org/api.html#duk_is_buffer_data">duk_is_buffer_data()</a></td>
<td>v instanceof Uint8Array, ...</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>Node.js Buffer object</td>
<td><a href="http://duktape.org/api.html#duk_is_buffer_data">duk_is_buffer_data()</a></td>
<td>Buffer.isBuffer()</td>
<td>&nbsp;</td>
</tr>
</table>

### Accessing buffer data

<table>
<tr>
<th>Type</th>
<th>C</th>
<th>Ecmascript</th>
<th>Notes</th>
</tr>
<tr>
<td>plain buffer</td>
<td><a href="http://duktape.org/api.html#duk_get_buffer">duk_get_buffer()</a><br />
    <a href="http://duktape.org/api.html#duk_require_buffer">duk_require_buffer()</a></td>
<td>buf[0], buf[1], ...<br />
    buf.length</br />
    buf.byteLength<br />
    buf.byteOffset<br />
    buf.BYTES_PER_ELEMENT</td>
<td>Non-standard type.  The <code>.buffer</code> property returns an
    ArrayBuffer spawned on-the-fly (new instance for every access).</td>
</tr>
<tr>
<td>ArrayBuffer object</td>
<td><a href="http://duktape.org/api.html#duk_get_buffer_data">duk_get_buffer_data()</a><br />
    <a href="http://duktape.org/api.html#duk_require_buffer_data">duk_require_buffer_data()</a></td>
<td>new Uint8Array(buf)[0], ...<br />
    buf.byteLength</td>
<td>No direct access to the underlying buffer.  Access the buffer via a typed
    array view, e.g. Uint8Array.</td>
</tr>
<tr>
<td>DataView object</td>
<td><a href="http://duktape.org/api.html#duk_get_buffer_data">duk_get_buffer_data()</a><br />
    <a href="http://duktape.org/api.html#duk_require_buffer_data">duk_require_buffer_data()</a></td>
<td>view.getInt16()<br />
    view.setUint32()<br />
    ...<br />
    view.byteLength<br />
    view.byteOffset</td>
<td>The .buffer property contains the ArrayBuffer the view operates on.
    The property is lazy; the ArrayBuffer is created on the first access
    and remains the same afterwards.</td>
</tr>
<tr>
<td>Typed array objects</td>
<td><a href="http://duktape.org/api.html#duk_get_buffer_data">duk_get_buffer_data()</a><br />
    <a href="http://duktape.org/api.html#duk_require_buffer_data">duk_require_buffer_data()</a></td>
<td>view[0], view[1], ...<br />
    view.length<br />
    view.byteLength<br />
    view.byteOffset<br />
    view.BYTES_PER_ELEMENT</td>
<td>The .buffer property contains the ArrayBuffer the view operates on.
    The property is lazy; the ArrayBuffer is created on the first access
    and remains the same afterwards.</td>
</tr>
<tr>
<td>Node.js Buffer object</td>
<td><a href="http://duktape.org/api.html#duk_get_buffer_data">duk_get_buffer_data()</a><br />
    <a href="http://duktape.org/api.html#duk_require_buffer_data">duk_require_buffer_data()</a></td>
<td>buf[0], buf[1], ...<br />
    buf.length</br />
    buf.byteLength<br />
    buf.byteOffset<br />
    buf.BYTES_PER_ELEMENT</td>
<td>In Node.js v6.7.0+ a Buffer is implemented as an Uint8Array with a custom
    prototype object.</td>
</tr>
</table>

### Configuring buffers

<table>
<tr>
<th>Type</th>
<th>C</th>
<th>Ecmascript</th>
<th>Notes</th>
</tr>
<tr>
<td>plain buffer</td>
<td><a href="http://duktape.org/api.html#duk_config_buffer">duk_config_buffer()</a><br />
    <a href="http://duktape.org/api.html#duk_resize_buffer">duk_resize_buffer()</a><br />
    <a href="http://duktape.org/api.html#duk_steal_buffer">duk_steal_buffer()</a></td>
<td>n/a</td>
<td>Fixed plain buffers cannot be configured.  Dynamic plain buffers can be
    resized and their current allocation can be "stolen".  External plain
    buffers can be reconfigured to map to a different memory area.</td>
</tr>
<tr>
<td>ArrayBuffer object</td>
<td>n/a</td>
<td>n/a</td>
<td>After creation, ArrayBuffer objects cannot be modified.  However, their
    underlying plain buffer can be reconfigured (depending on its type).</td>
</tr>
<tr>
<td>DataView object</td>
<td>n/a</td>
<td>n/a</td>
<td>After creation, DataView objects cannot be modified.  However, their
    underlying plain buffer can be reconfigured (depending on its type).</td>
</tr>
<tr>
<td>Typed array objects</td>
<td>n/a</td>
<td>n/a</td>
<td>After creation, typed array objects cannot be modified.  However, their
    underlying plain buffer can be reconfigured (depending on its type).</td>
</tr>
<tr>
<td>Node.js Buffer object</td>
<td>n/a</td>
<td>n/a</td>
<td>After creation, Node.js Buffer objects cannot be modified.  However, their
    underlying plain buffer can be reconfigured (depending on its type).</td>
</tr>
</table>

### Buffer-to-string conversion

<table>
<tr>
<th>Call</th>
<th>Description</th>
</tr>

<tr>
<td>duk_buffer_to_string()</td>
<td>Buffer data is used 1:1 as internal string representation.  If you want to
    create valid Ecmascript strings, data should be in CESU-8 encoding.  It's
    possible to create symbol values (intentionally or by accident).  Using
    duk_push_lstring() for the buffer data is equivalent.</td>
</tr>

<tr>
<td>new TextDecoder().decode(buf)</td>
<td>Decodes a buffer as a UTF-8 string and outputs a valid Ecmascript string.
    Invalid byte sequences are replaced with U+FFFD, non-BMP characters are
    replaced with surrogate pairs.</td>
</tr>

<tr>
<td>duk_to_string()</td>
<td>Not very useful: invokes Ecmascript ToString() coercion which results in
    strings like <code>[object Uint8Array]</code>.</td>
</tr>

<tr>
<td>String(buf)</td>
<td>Not very useful: invokes Ecmascript ToString() coercion as
    for duk_to_string().</td>
</tr>
</table>

### String-to-buffer conversion

<table>
<tr>
<th>Call</th>
<th>Description</th>
</tr>

<tr>
<td>duk_to_buffer()</td>
<td>Bytes from the string internal representation are copied byte-for-byte
    into the result buffer.  For valid Ecmascript strings the result is
    CESU-8 encoded.</td>
</tr>

<tr>
<td>new TextEncoder().encode(str)</td>
<td>The string internal representation is decoded as extended CESU-8/UTF-8 and
    then encoded into UTF-8.  Surrogate pairs are combined, and invalid byte
    sequences are replaced with U+FFFD.</td>
</tr>

<tr>
<td>new Buffer(str)</td>
<td>The string is treated the same as with TextEncoder.</td>
</tr>

<tr>
<td>Uint8Array.allocPlain(str)</td>
<td>String internal representation is copied byte-for-byte into the resulting
    buffer as for duk_to_buffer().</td>
</tr>
</table>

### String/buffer conversion use cases

<table>
<tr>
<th>Conversion</th>
<th>C</th>
<th>Ecmascript</th>
<th>Notes</th>
</tr>

<tr>
<td>Buffer-to-string UTF-8</td>
<td>n/a</td>
<td>new TextDecoder().decode(buf)</td>
<td>Buffer is interpreted as UTF-8, invalid UTF-8 sequences are replaced with
    U+FFFD, non-BMP codepoints are expanded into surrogate pairs.</td>
</tr>

<tr>
<td>Buffer-to-string CESU-8</td>
<td>n/a</td>
<td>n/a</td>
<td>Buffer is interpreted as CESU-8, no bindings for this now.</td>
</tr>

<tr>
<td>Buffer-to-string 1:1</td>
<td>duk_buffer_to_string()</td>
<td>n/a</td>
<td>Buffer is converted byte-for-byte into the internal (extended CESU-8/UTF-8)
    representation without decoding.  This coercion can also result in a symbol
    value.</td>
</tr>

<tr>
<td>String-to-buffer UTF-8</td>
<td>n/a</td>
<td>new TextEncoder().encode(str)</td>
<td>String is converted from a 16-bit codepoint list to UTF-8.  Valid surrogate
    pairs are combined, invalid surrogate pairs and invalid byte sequences are
    replaced with U+FFFD.</td>
</tr>

<tr>
<td>String-to-buffer CESU-8</td>
<td>n/a</td>
<td>n/a</td>
<td>No bindings for this now.</td>
</tr>

<tr>
<td>String-to-buffer 1:1</td>
<td>duk_to_buffer()</td>
<td>n/a</td>
<td>String is converted byte-for-byte from the internal representation into a
    buffer.  For valid Ecmascript strings the result is valid CESU-8 which is
    used as their internal representation.</td>
</tr>

</table>

## Plain buffers

A plain buffer value mimics an Uint8Array instance, and has virtual properties:

```js
// Create a plain buffer of 8 bytes.
var plain = Uint8Array.allocPlain(8);  // Duktape custom call

// Fill it using index properties.
for (var i = 0; i < plain.length; i++) {
    plain[i] = 0x41 + i;
}

// Print other virtual properties.
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

// Plain buffers mimic Uint8Array behavior where applicable, e.g.
print(typeof plain);             // -> object, like Uint8Array
print(String(plain));            // -> [object Uint8Array], like Uint8Array
```

`Uint8Array` is the "object counterpart" of a plain buffer.  It wraps a
plain buffer, similarly to how a `String` object wraps a plain string.
`Uint8Array` also has the same virtual properties, and since it has an
actual property table, new properties can also be added normally.

You can easily convert between the two:

```js
// Create an 8-byte plain buffer.
var plain1 = Uint8Array.allocPlain(8);

// Convert a plain buffer to a full Uint8Array, both pointing to the same
// underlying buffer.
var u8 = Object(plain1);

// Get the plain buffer wrapped inside a Uint8Array.
var plain2 = Uint8Array.plainOf(u8);  // Duktape custom call

// No copies are made of 'plain1' in this process.
print(plain1 === plain2);  // -> true
```

Plain buffers have an inherited `.buffer` property (a getter) which returns
an ArrayBuffer backing to the same plain buffer.  Because there's no
property table, each .buffer read creates a new ArrayBuffer instance, so
avoid reading the property over and over again.  The .buffer property allows
one to create another view over the plain buffer without making a copy:

```js
var plain = Uint8Array.allocPlain(8);

// A typed array constructor interprets a plain array like a Uint8Array:
// it gets treated as an initializer array so that a copy is made.  Here,
// when constructing a Uint16Array, each input byte expands to 16 bits.
var u16 = new Uint16Array(plain);  // no shared storage

// Using .buffer allows a shared view to be created.  Here, a two-element
// Uint32Array is created over the 8-byte plain buffer.
var u32 = new Uint32Array(plain.buffer);  // shared storage
```

To summarize, the main differences between a plain buffer and an
`Uint8Array` are:

<table>
<tr>
<th>&nbsp;</th>
<th>Plain buffer</th>
<th>Uint8Array</th>
<th>Notes</th>
</tr>
<tr>
<td>Creation</td>
<td>Uint8Array.allocPlain(length)<br />
Uint8Array.allocPlain('stringValue')<br />
Uint8Array.allocPlain([ 1, 2, 3, 4 ])</td>
<td>new Uint8Array(length)<br />
new Uint8Array([ 1, 2, 3, 4 ])</td>
<td>Uint8Array.allocPlain() has more argument variants, and strings are
treated specially (string internal representation is copied 1:1 into the
buffer).  C API can of course also be used for buffer creation.</td>
</tr>
<tr>
<td>typeof</td>
<td>object</td>
<td>object</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>Object.prototype.toString()</td>
<td>[object Uint8Array]</td>
<td>[object Uint8Array]</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>instanceof Uint8Array</td>
<td>true</td>
<td>true</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>Property table</td>
<td>No</td>
<td>Yes</td>
<td>Plain buffer has no property table but inherited from Uint8Array.prototype.
    Property writes are usually ignored, but e.g. an inherited setter can
    capture a write.</td>
</tr>
<tr>
<td>.buffer property</td>
<td>Yes</td>
<td>Yes</td>
<td>Plain buffer has an inherited <code>.buffer</code> getter which returns an
    ArrayBuffer which backs to the plain buffer.  Each read creates a new
    ArrayBuffer instance.</td>
<tr>
<td>Allow finalizer</td>
<td>No</td>
<td>Yes</td>
<td>Even though plain buffers inherit from Uint8Array.prototype, a finalizer
    is not supported, even if the finalizer was inherited.</td>
</tr>
<tr>
<td>Object.isExtensible()</td>
<td>false</td>
<td>true</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>buf.subarray() result</td>
<td>Uint8Array</td>
<td>Uint8Array</td>
<td>The result of a .subarray() on a plain buffer is a Uint8Array object
    because a plain buffer cannot express a slice offset.</td>
</tr>
</table>

Other notes:

* Plain buffers behave like Uint8Arrays when passed as an argument to
  built-in typed array bindings.  In many cases the internal implementation
  will first promote the plain buffer to a (temporary) Uint8Array object
  which is used for the operation; the temporary is then thrown away.
  This affects performance when using plain buffers with some Ecmascript
  bindings.

* Duktape built-ins like `Duktape.dec()` create plain buffers to save
  memory space; if you explicitly wish to work with Uint8Array objects
  you can e.g. use `Object(Duktape.dec('hex', 'deadbeef'))`.

## JSON and JX serialization

The Node.js Buffer type has a `.toJSON()` method so it gets serialized in
standard `JSON.stringify()`:

```js
var buf = new Buffer('ABCD');
print(JSON.stringify(buf));

// Output:
// {"type":"Buffer","data":[65,66,67,68]}
```

`ArrayBuffer` doesn't have any enumerable own properties and no `.toJSON()`
so they serialize as empty objects (same applies to `DataView`):

```js
var buf = Duktape.dec('hex', 'deadbeef');
print(JSON.stringify([ 1, buf, 2 ]));

// Output:
// [1,{},2]
```

Plain buffers and typed arrays have enumerable index properties but no
`.toJSON()` so they get serialized as objects (not arrays):

```js
var plain = Uint8Array.allocPlain('foo');
var u16 = new Uint16Array([ 0x1111, 0x2222, 0x3333 ]);
print(JSON.stringify({ plain: plain, u16: u16 }));

// Output:
// {"plain":{"0":102,"1":111,"2":111},"u16":{"0":4369,"1":8738,"2":13107}}
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
plain buffers unless a `.toJSON()` method exists:

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
`JSON.stringify()` because `.toJSON()` takes precedence (at least in
Duktape 2.x) over JX built-in buffer serialization.

## Using buffers in C code

### Typing

Plain buffers and buffer objects work a bit differently in the C API:

- Plain buffer stack type is `DUK_TYPE_BUFFER` and they test true for
  both `duk_is_buffer()` and `duk_is_buffer_data()`.

- Buffer object stack type is `DUK_TYPE_OBJECT` and they test false for
  `duk_is_buffer()`, but true for `duk_is_buffer_data()`.

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
may have been resized.  Safest approach is to re-lookup right before accessing:

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
data area is valid for reading and writing, and must ensure the area eventually
gets freed.

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
if (duk_is_buffer(ctx, idx_mybuffer)) {
    /* value is a plain buffer (fixed, dynamic, or external) */
}
```

Or equivalently:

```c
if (duk_get_type(ctx, idx_mybuffer) == DUK_TYPE_BUFFER) {
    /* value is a plain buffer (fixed, dynamic, or external) */
}
```

### Buffer objects

Here's a test case with some basic usage:

* https://github.com/svaarala/duktape/blob/master/tests/api/test-bufferobject-example-1.c

#### Creating buffer objects

Buffer objects and view objects are all created with the
[duk_push_buffer_object()](http://duktape.org/api.html#duk_push_buffer_object)
API call:

```c
/* Create a 1000-byte backing buffer.  Only part of the buffer is visible
 * for the view created below.
 */
duk_push_fixed_buffer(ctx, 1000);

/* Create an Uint16Array of 25 elements, backed by plain buffer at index -1,
 * starting from byte offset 100 and having byte length 50.
 */
duk_push_buffer_object(ctx,
                       -1 /*index of plain buffer*/,
                       100 /*byte offset*/,
                       50 /*byte (!) length */,
                       DUK_BUFOBJ_UINT16ARRAY /*flags and type*/);
```

This is equivalent to:

```js
// Argument plain buffer
var plainBuffer = Uint8Array.allocPlain(1000);

// Create a Uint16Array over the existing plain buffer.
var view = new Uint16Array(plainBuffer.buffer,
                           100 /*byte offset*/,
                           25 /*length in elements (!)*/);

// Outputs: 25 100 50 2
print(view.length, view.byteOffset, view.byteLength, view.BYTES_PER_ELEMENT);
```

Note that the C call gets a **byte length** argument (50) while the Ecmascript
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
is a buffer object or not, or to check its specific type.  However, the
`duk_is_buffer_data()` API call returns true for both plain buffers and
buffer objects:

```c
if (duk_is_buffer_data(ctx, 0)) {
    /* ... */
}
```

Similarly, `duk_get_buffer_data()` and `duk_require_buffer_data()` accept
both plain buffers and buffer objects and are a good default idiom to deal
with buffer data in C code:

```c
/* First argument must be a plain buffer or a buffer object. */
duk_size_t len;
char *buf = (char *) duk_require_buffer_data(ctx, 0, &len);
/* ... work with 'buf', valid offset range is [0,len[. */
```

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

/* duk_is_buffer() for plain buffers, duk_is_buffer_data() for plain
 * buffers or buffer objects.
 */
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

/* Or duk_require_buffer_data(). */
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

In Duktape 2.0 plain buffers mimic Uint8Arrays and Node.js Buffer behavior
has been aligned with Node.js v6.7.0 where Buffers are Uint8Array instances
with a custom prototype.

As a result, in Duktape 2.0 it's no longer generally possible (or necessary)
to mix buffer types as in Duktape 1.x, where e.g. a Duktape.Buffer could be
used as an input argument to `new Uint16Array()` with some custom behavior.

## Common issues and best practices

### Resizing and/or appending data to a buffer

Neither the standard ArrayBuffer nor the Node.js Buffer type allow buffer
resizing so there's no easy way to efficiently append data to an ArrayBuffer
or a Node.js buffer.  A trivial but inefficient approach is to always create a
new buffer for appended data:

```js
// Node.js example
var data = new Buffer(0);

function received(buf) {
    data = Buffer.concat([ data, buf ]);
}
```

A better common technique is to accumulate parts and concatenate them when
input is finished:

```js
// Node.js example
var parts = [];

function received(buf) {
    parts.push(buf);
}

function finalize() {
    var final = Buffer.concat(parts);
}
```

Another efficient approach is to keep some spare and avoid excessive copying
by e.g. doubling the buffer whenever you're out of space:

```js
// Typed array example
var data = new Uint8Array(64);
var offset = 0;

function received(buf) {
    // Incoming data ('buf') is an Uint8Array

    while (data.length - offset < buf.byteLength) {
        // Not enough space, resize to make room.
        var newBuf = new Uint8Array(data.length * 2);
        newBuf.set(data);  // copy old bytes
        data = newBuf;
    }

    data.set(new Uint8Array(buf), offset);
    offset += buf.byteLength;
}

// When accumulation is finished, final data can be extracted as follows:
var finalArrayBuffer = data.buffer.slice(0, offset);
```

If you want to use a Duktape specific solution, a dynamic plain buffer can be
resized on-the-fly with minimal cost.  A dynamic buffer appears to Ecmascript
code as an ArrayBuffer whose `.length` and `.byteLength` will simply change
to reflect a resize of the buffer.  Dynamic plain buffers can only be resized
from C code.  External plain buffers can also be reconfigured on-the-fly which
allows e.g. resizing.

## Avoiding Duktape custom behaviors

It's best to start with ES2015 typed arrays because they are the "best
standard" for buffers in Ecmascript.  When doing so, avoid Duktape specific
behavior unless you really need to.  Particular gotchas are discussed below.

### Avoid relying on memory zeroing of Node.js Buffers

ES2015 specification requires that new `ArrayBuffer` values be filled with
zeroes.  Starting from Duktape 1.4.0, Duktape follows this even when the
`DUK_USE_ZERO_BUFFER_DATA` config option is turned off.

Node.js does *not* zero allocated `Buffer` objects by default.  Duktape
zeroes Node.js `Buffer` objects too, unless the `DUK_USE_ZERO_BUFFER_DATA`
config option is turned off.

## Security considerations

Duktape guarantees that no out-of-bounds accesses are possible to an
underlying plain buffer by any Ecmascript code.

This guarantee is in place even if you initialize a buffer object using a
dynamic plain buffer which is then resized so that the conceptual buffer
object extends beyond the resized buffer.  In such cases Duktape doesn't
provide very clean behavior (some operations return zero, others may throw
a TypeError, etc) but the behavior is guaranteed to be memory safe.  This
situation is illustrated (and tested for) in the following test case:

* https://github.com/svaarala/duktape/blob/master/tests/api/test-bufferobject-dynamic-safety.c

C code interacting with buffers through property reads/writes is guaranteed
to be memory safe.  C code may fetch a pointer and a length to an underlying
buffer and operate on that directly; memory safety is up to user code in that
situation.

When an external plain buffer is used, it's up to user code to ensure that
the pointer and length configured into the buffer are valid, i.e. all bytes
in that range are readable and writable.  If this is not the case, memory
unsafe behavior may happen.
