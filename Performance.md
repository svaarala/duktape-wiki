# How to optimize performance

This article discusses Duktape specific performance characteristics and
provides some hints to avoid Duktape specific performance pitfalls.

## Compiler options

As general guidelines:

* Gcc/clang `-O2` is a good default for performance optimization.

* When performance matters, profile guided optimization (PGO) is **strongly
  recommended**.

The difference between plain `-O2` and `-O2` with PGO can be very large,
often around 20%!  For example:

```
# -O2 without PGO.
$ time ./duk.O2 tests/perf/test-mandel.js
[...]

real	0m3.061s
user	0m3.059s
sys	0m0.000s

# -O2 with PGO.
$ time ./duk-pgo.O2 tests/perf/test-mandel.js
[...]

real	0m2.488s
user	0m2.487s
sys	0m0.000s
```

In this particular case the performance improvement is almost 20%.

See:

* <https://github.com/svaarala/duktape/blob/master/doc/performance-sensitive.rst>

## Duktape performance characteristics

### String interning

Strings are
[interned](http://en.wikipedia.org/wiki/String_interning): only
a single copy of a certain string exists at any point in time.  Interning
a string involves hashing the string and looking up a global string table
to see whether the string is already present.  If so, a pointer to the
existing string is returned; if not, the string is inserted into the string
table, potentially involving a string table resize.  While a string remains
reachable, it has a unique and a stable pointer which allows byte-by-byte
string comparisons to be converted to simple pointer comparisons.  Also,
string hashes are computed during interning which makes the use of string
keys in internal hash tables efficient.

There are many downsides also.  Strings cannot be modified in-place but
a copy needs to be made for every modification.  For instance, repeated
string concatenation creates a temporary value for each intermediate string
which is especially bad if a result string is built one character at a time.
Duktape internal primitives, such as string case conversion and array
`join()`, try to avoid these downsides by minimizing the number of temporary
strings created.

### String memory representation and the string cache

The internal memory representation for strings is extended UTF-8, which
represents each ASCII character with a single byte but uses two or more
bytes to represent non-ASCII characters.  This reduces memory footprint for
most strings and makes strings easy to interact with in C code.  However,
it makes random access expensive for non-ASCII strings because characters
are represented by a variable number of bytes.  Random access is needed for
operations such as extracting a substring or looking up a character at a
certain character index.

Duktape automatically detects pure ASCII strings (based on the fact that
their character and byte length are identical) and provides efficient random
access to such strings.

However, when a string contains non-ASCII characters a **string cache**
is used to resolve a character index to an internal byte index.  Duktape
maintains a few  string cache entries (internal define `DUK_HEAP_STRCACHE_SIZE`,
currently 4) which remember the last byte offset and character offset for
recently accessed strings.  Character index lookups near a cached
character/byte offset can be efficiently handled by scanning backwards or
forwards from the cached location.  When a string access cannot be resolved
using the cache, the string is scanned either from the beginning or the end,
which is obviously very expensive for large strings.  The cache is maintained
with a very simple LRU mechanism and is transparent to both Ecmascript and C
code.

The string cache makes simple loops like the following efficient:

```js
var i;
var n = inp.length;
for (i = 0; i < n; i++) {
    print(inp.charCodeAt(i));
}
```

When random accesses are made from here and there to multiple strings,
the strings may very easily fall out of the cache and become expensive
at least for longer strings.

Note that the cache never maintains more than one entry for each
string, so the following would be very inefficient:

```js
var i;
var n = inp.length;
for (i = 0; i < n; i++) {
    // Accessing the string alternatively from beginning and end will
    // have a major performance impact for large strings.
    print(inp.charCodeAt(i));
    print(inp.charCodeAt(n - 1 - i));
}
```

As mentioned above, these performance issues are avoided entirely for
ASCII strings which behave as one would expect.  More generally, Duktape
provides fast paths for ASCII characters and pure ASCII strings in internal
algorithms whenever applicable.  This applies to algorithms such as case
conversion, regexp matching, etc.

### Array and buffer numeric index accesses

There is a fast path for reading and writing numeric indices of (dense)
arrays and plain buffer values, e.g. `x = buf[123]` or `buf[123] = x`.
The fast path avoids coercing the index to a string (here `"123"`) before
attempting a lookup.

There's a similar fast path for buffer objects (Duktape.Buffer, Node.js
Buffer, ArrayBuffer, and TypedArray views), but it is about 20% slower.

### Object/array storage

Object properties are stored in a linear key/value list which provides
stable ordering (insertion order).  When an object has enough properties
(internal define `DUK_HOBJECT_E_USE_HASH_LIMIT`, currently 32), a hash
lookup table is also allocated to speed up property lookups.  Even in
this case the key ordering is retained which is a practical requirement
for an Ecmascript implementation.  The hash part is avoided for most objects
because it increases memory footprint and doesn't significantly speed up
property lookups for very small objects.

For most objects property lookup thus involves a linear comparison
against the object's property table.  Because properties are kept in the
property table in their insertion order, properties added earlier are
slightly faster to access than those added later.  When the object grows
large enough to gain a hash table this effect disappears.

Array elements are stored in a special "array part" to reduce memory
footprint and to speed up access.  Accessing an array with a numeric index
officially first coerces the number to a string (e.g. `x[123]` to
`x["123"]`) and then does a string key lookup; when an object has an array
part no temporary string is actually created in most read/write situations.

The array part can be "sparse", i.e. contain unmapped entries.  Duktape
occasionally rechecks the density of the array part, and if it becomes too
sparse the array part is abandoned (current limit is roughly: if fewer than
25% of array part elements are mapped, the array part is abandoned).  The
array entries are then converted to ordinary object properties, with every
mapped array index converted to an explicit string key (such as `"123"`),
which is relatively expensive.  If an array part has once been abandoned,
it is never recreated even if the object would be dense enough to warrant
an array part.

Elements in the array part are required to be plain properties (not
accessors) and have default property attributes (writable, enumerable,
and configurable).  If any element deviates from this, the array part is
again abandoned and array elements converted to ordinary properties.

### Identifier access

Duktape has two modes for storing and accessing identifiers (function
arguments, local variables, function declarations): a fast path and a slow
path.  The fast path is used when an identifier can be bound to a virtual
machine register, i.e., a fixed index in a virtual stack frame allocated
for a function.  Identifier access is then simply an array lookup.  The
slow path is used when the fast path cannot be safely used; identifier
accesses are then converted to explicit property lookups on either
external or internal objects, which is more than an order of magnitude
slower.

To keep identifier accesses in the fast path:

* Execute (almost all) code inside Ecmascript functions, not in the top-level
  global or eval code: global/eval code never uses fast path identifier
  accesses (however, function code inside global/eval does).

* Store frequently accessed values in local variables instead of looking
  them up from the global object or other objects.

### Enumeration

When an object is enumerated, with either the `for-in` statement or
`Object.keys()`, Duktape first traverses the target object and its
prototype chain and forms an internal enumeration object, which contains
all the enumeration keys as strings.  In particular, all array indices
(or character indices in case of strings) are converted and interned into
string values before enumeration and they remain interned until the
enumeration completes.  This can be memory intensive especially if large
arrays or strings are enumerated.

Note, however, that iterating a string or an array with `for-in` and
expecting the array elements or string indices to be enumerated in an
ascending order is non-portable.  Such behavior, while guaranteed by many
implementations including Duktape, is not guaranteed by the Ecmascript
E5.1 standard.

### Function features

Ecmascript has several features which make function entry and execution
quite expensive.  The general goal of the Duktape Ecmascript compiler is to
avoid the troublesome features for most functions while providing full
compatibility for the rest.

An ideal compiled function has all its variables and functions bound to
virtual machine registers to allow fast path identifier access, avoids
creation of the `arguments` object on entry, avoids creation of explicit
lexical environment records upon entry and during execution, and avoids
storing any lexical environment related control information such as
internal identifier-to-register binding tables.

The following features have a significant impact on execution performance:

* Access to the `arguments` object: requires creation of an expensive object
  upon function entry in case it is accessed.

* A [direct call](http://www.ecma-international.org/ecma-262/5.1/#sec-15.1.2.1.1)
  to `eval()`: requires initialization of the `arguments` and full identifier
  binding information needs to be retained in case evaluated code needs it.

* Global and eval code in general: identifiers are never bound to virtual
  machine registers but use explicit property lookups instead.  Statements
  in eval code also have implicit values which require bytecode instructions
  to evalute.

The following features have a more moderate impact:

* `try-catch-finally` statement: the dynamic binding required by the catch
  variable is relatively expensive at present.

* `with` statement: the object binding required is relatively expensive
  at present.

* Use of bound functions, i.e. functions created with `Function.prototype.bind()`:
  an additional function object is created, and function invocation is slowed
  down by handling of bound function objects and argument shuffling.

* More than about 250 formal arguments, literals, and active temporaries:
  causes bytecode to use register shuffling which increases bytecode size and
  slows down execution.

To avoid these, isolate performance critical parts into separate minimal
functions which avoid using the features mentioned above.

## Minimize use of temporary strings

All temporary strings are interned.  It is particularly bad to accumulate
strings in a loop:

```js
var t = '';
for (var i = 0; i < 1024; i++) {
    t += 'x';
}
```

This will intern 1025 strings.  Execution time is `O(n^2)` where `n` is the
loop limit.  It is better to use a temporary array instead:

```js
var t = [];
for (var i = 0; i < 1024; i++) {
    t[i] = 'x';
}
t = t.join('');
```

Here, `x` will be interned once into a function constant, and each array
entry simply refers to the same string, typically costing only 8 bytes
per array entry.  The final `Array.prototype.join()` avoids unnecessary
interning and creates the final string in one go.

## Avoid large non-ASCII strings if possible

Avoid operations which require access to a random character offset inside
a large string containing one or more non-ASCII characters.  Such accesses
require use of the internal "string cache" and may, in the worst case, require
a brute force scanning of the string to find the correct byte offset
corresponding to the character offset.

Case conversion and other Unicode related operations have fast paths for
ASCII codepoints but fall back to a slow path for non-ASCII codepoints.  The
slow path is size optimized, not speed optimized, and often involve linear
range matching.

## Iterate over plain buffer values, not Buffer objects

Both buffer objects and plain buffer values have a fast path when buffer
contents are accessed with numeric indices.  The fast path for plain buffer
values is a bit faster, so your code will run faster if you get the plain
buffer before iteration:

```js
var b, i, n;

// Buffer object, typeof is 'object'
var bufferValue = new Duktape.Buffer('foo');
print(typeof bufferValue);  // 'object'

// Get plain buffer, if already plain, no harm
b = bufferValue.valueOf();
print(typeof b);  // always 'buffer'

n = b.length;
for (i = 0; i < n; i++) {
    print(i, b[i]);  // fast path for plain buffer access
}
```

When creating buffers, note that `new Duktape.Buffer(x)` always creates a
Buffer object, while `Duktape.Buffer(x)` returns a plain buffer value.  This
mimics how Ecmascript `new String()` and `String()` work.  Plain buffers
should be preferred whenever possible.

## Avoid sparse arrays when possible

If an array becomes too sparse at any point, Duktape will abandon the
array part permanently and convert array properties to explicit string keyed
properties.  This may happen for instance if an array is initialized with a
descending index:

```js
var arr = [];
for (var i = 1000; i >= 0; i--) {
    // bad: first write will abandon array part permanently
    arr[i] = i * i;
}
```

Right after the first array write the array part would contain 1001
entries with only one mapped array element.  The density of the array would
thus be less than 0.1%.  This is way below the density limit for abandoning
the array part, so the array part is abandoned immediately.  At the end the
array part would be 100% dense but will never be restored.  Using an ascending
index fixes the issue:

```js
var arr = [];
for (var i = 0; i < 1000; i++) {
    arr[i] = i * i;
}
```

Setting the `length` property of an array manually does not, by itself, cause
an array part to be abandoned.  To simplify a bit, the array density check
compares the number of mapped elements relative to the highest used element
(actually allocated size).  The `length` property does not affect the check.
Although setting an array length beforehand may effectively pre-allocate an
array in some implementations, it has no such effect in Duktape, at least at
the moment.  For example:

```js
var arr = [];
arr.length = 1001;  // array part not abandoned, but no speedup in Duktape
for (var i = 0; i < 1000; i++) {
    arr[i] = i * i;
}
```

## Iterate arrays with explicit indices, not a "for-in"

Because the internal enumeration object contains all (used) array
indices converted to string values, avoid `for-in` enumeration
of at least large arrays.  As a concrete example, consider:

```js
var a = [];
for (var i = 0; i < 1000000; i++) {
  a[i] = i;
}
for (var i in a) {
  // Before this loop is first entered, a million strings ("0", "1",
  // ..., "999999") will be interned.
  print(i, a[i]);
}
// The million strings become garbage collectable only here.
```

The internal enumeration object created in this example would contain a
million interned string keys for "0", "1", ..., "999999".  All of these keys
would remain reachable for the entire duration of the enumeration.  The
following code would perform much better (and would be more portable, as it
makes no assumptions on enumeration order):

```js
var a = [];
for (var i = 0; i < 1000000; i++) {
  a[i] = i;
}
var n = a.length;
for (var i = 0; i < n; i++) {
  print(i, a[i]);
}
```

## Minimize top-level global/eval code

Identifier accesses in global and eval code always use slow path instructions
to ensure correctness.  This is at least a few orders of magnitude slower than
the fast path where identifiers are mapped to registers of a function
activation.

So, this is slow:

```js
for (var i = 0; i < 100; i++) {
    print(i);
}
```

Each read and write of `i` will be an explicit environment record lookup,
essentially a property lookup from an internal environment record object,
with the string key `i`.

Optimize by putting most code into a function:

```js
function main() {
    for (var i = 0; i < 100; i++) {
        print(i);
    }
}
main();
```

Here, `i`will be mapped to a function register, and each access will be a
simple register reference (basically a pointer to a tagged value), which is
much faster than the slow path.

If you don't want to name an explicit function, use:

```js
(function() {
    var i;

    for (i = 0; i < 100; i++) {
      print(i);
    }
})();
```

Eval code provides an implicit return value which also has a performance
impact.  Consider, for instance, the following:

```js
var res = eval("if (4 >= 3) { 'foo'; } else { 'bar'; }");
print(res);  // prints 'foo'
```

To support such code the compiler emits bytecode to store a statement's
implicit return value to a temporary register in case it is needed.  These
instructions slow down execution and increase bytecode size unnecessarily.

## Prefer local variables over external ones

When variables are bound to virtual machine registers, identifier lookups
are much faster than using explicit property lookups on the global object or
on other objects.

When an external value or function is required multiple times, copy it to
a local variable instead:

```js
function slow(x) {
    var i;

    // 'x.length' is an explicit property lookup and happens on every loop
    for (i = 0; i < x.length; i++) {
        // 'print' causes a property lookup to the global object
        print(x[i]);
    }
}

function fast(x) {
    var i;
    var n = x.length;
    var p = print;

    // every access in the loop now happens through register-bound identifiers
    for (i = 0; i < n; i++) {
        p(x[i]);
    }
}
```

Use such optimizations only where it matters, because they often reduce
code readability.

## Using "undefined"

The `undefined` value is interesting in Ecmascript because it's not actually
a literal but a global variable.  As such, if you refer to it just as
`undefined`, Duktape will currently read it using a slow path variable read.
For example:

```js
    print("undefined is: " + undefined);
```

produces bytecode like:

```
    ; constant 19: "undefined"

    ...
    GETVAR r123, c19   ; load undefined
    ...
```

This is slower and uses larger bytecode than necessary.  Using e.g. `void null`
(or equivalently `void 0`, etc) produces better bytecode.  For example:

```js
    print("undefined is: " + void null);
```

produces bytecode like:

```
    ...
    LDUNDEF r123
    ...
```

This is faster because there's no slow path access.  The code is also better
because it is no longer dependent on the global `undefined` binding being
intact.

## JSON.stringify() fast path

There's a fast path for `JSON.stringify()` serialization which is used when
there is no "replacer" argument.  Indent argument and JX/JC support was added
to the fast path in Duktape 1.4.0.

The fast path assumes that it can serialize the argument value without risking
any side effects which might mutate the value being serialized, and will fall
back to the slower default algorithm if necessary.

This happens at least when:

* any object has a `toJSON()` property

* any object property is a getter

* any object is a Proxy

See [test-bi-json-enc-fastpath.js](https://github.com/svaarala/duktape/blob/master/tests/ecmascript/test-bi-json-enc-fastpath.js)
for detailed notes on current limitations; the fast path preconditions and
limitations are very likely to change between Duktape releases.

The fast path is currently not enabled by default.  To enable, ensure
`DUK_USE_JSON_STRINGIFY_FASTPATH` is enabled in your `duk_config.h`.
