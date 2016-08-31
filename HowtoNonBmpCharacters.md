# How to work with non-BMP characters

## Ecmascript and Duktape support for non-BMP

### Ecmascript standard strings are 16-bit only

Ecmascript standard itself does not support non-BMP characters: all
codepoints are strictly 16-bit.  Non-BMP characters are intended to be
represented using surrogate pairs:

- E5.1 Section 8.4: http://www.ecma-international.org/ecma-262/5.1/#sec-8.4
- E6 Section 6.1.4: http://www.ecma-international.org/ecma-262/6.0/#sec-ecmascript-language-types-string-type

ES6 RegExp patterns having the `u` flag support non-BMP characters by
interpreting the string data as UTF-16:

- http://www.ecma-international.org/ecma-262/6.0/#sec-pattern-semantics

ES6 `String.prototype.trim()` also has special handling for non-BMP
characters (again interpreting the string as UTF-16):

- http://www.ecma-international.org/ecma-262/6.0/#sec-string.prototype.trim

### Duktape strings support up to 32-bit codepoints

Duktape represents strings in an extended UTF-8 format which allows both
arbitrary 16-bit codepoints (as required by Ecmascript) but also extended
codepoints for the full 32-bit range.  Also arbitrary byte sequences (which
are invalid UTF-8) are allowed:

- http://duktape.org/guide.html#type-string

As a result, Duktape supports characters in the non-BMP range directly:

- C code can push such strings, expressed as (extended) UTF-8, directly
  using e.g. `duk_push_string()`.
- Non-BMP characters will mostly work as one expects in Ecmascript code.
  There are some individual Ecmascript bindings which may not work as
  expected because the standard bindings expect codepoints to be at most
  16 bits.

## Main approaches for dealing with non-BMP characters

The main choice is between:

- Using surrogate pairs: standard approach, engine neutral, has some
  inconveniences like `.length` of strings counting the surrogate pair
  characters individually.  C code will first encode non-BMP characters
  into surrogate pairs, with each codepoint in the pair then encoded
  using CESU-8.
- Using Duktape specific non-BMP strings: more natural for C code, `.length`
  will be correct, has some inconveniences like some standard bindings
  working in unexpected ways.  C code will encode strings using
  [UTF-8](https://en.wikipedia.org/wiki/UTF-8) directly.

## Using surrogate pairs

For example, to represent [LEFT-POINTING MAGNIFYING GLASS U+1F50D](http://www.fileformat.info/info/unicode/char/1f50d/index.htm):

```js
// http://www.russellcottrell.com/greek/utilities/surrogatepaircalculator.htm
var magnifyingGlass = '\uD83D\uDD0D';

print(magnifyingGlass.length);  // prints 2
print(Duktape.enc('hex', magnifyingGlass));  // prints eda0bdedb48d, surrogate codepoints eda0bd edb48d
= eda0bdedb48d
```

Note in particular that the `\u` escape only accepts 4 digits, which may be
misleading:

```js
// This gets parsed as U+1F50 followed by ASCII 'D'.
var magnifyingGlass = '\u1F50D';
```

If you want your C code to see UTF-8 you'll need to encode/decode the surrogate
pairs as appropriate.  It's probably best to write helpers to:

- Push a UTF-8 string onto the value stack, converting non-BMP characters to
  surrogate pairs (CESU-8).
- Read a string the value stack, converting surrogate pairs (CESU-8) into
  UTF-8.

For example:
```c
// Get a string from the duk stack, converting data from CESU-8 encoding to UTF-8.
// Returns null if value at index is not a string, or there's insufficient memory
// Caller is responsible for freeing returned buffer (if not null).
// 
char *get_utf8_string(duk_context *ctx, duk_idx_t index) {
    duk_size_t len;
    const duk_uint8_t *in = (duk_uint8_t *)duk_get_lstring(ctx, index, &len);
    if (in == NULL) return NULL;

    duk_uint8_t *buf = malloc(len);
    if (buf == NULL) return NULL;

    duk_uint8_t *out = buf;
    while (*in) {
        // next six bytes represent a codepoint encoded as UTF-16 surrogate pair
        if (in[0] == 0xED 
            && (in[1] & 0xF0) == 0xA0
            && (in[2] & 0xC0) == 0x80
            && (in[3] == 0xED)
            && (in[4] & 0xF0) == 0xB0
            && (in[5] & 0xC0) == 0x80) 
        {
            // push coding parts of 6 bytes of UTF-16 surrogate pair into a 4 byte UTF-8 codepoint
            // adding 1 to in[1] adds 0x10000 to code-point that was subtracted for UTF-16 encoding
            out[0] = 0xF0 | ((in[1]+1) & 0x1C) >> 2;
            out[1] = 0x80 | ((in[1]+1) & 0x03) << 4 | (in[2] & 0x3C) >> 2;
            out[2] = 0x80 | (in[2] & 0x03) << 4 | (in[4] & 0x0F);
            out[3] = in[5];
            in += 6; out += 4; 
        } else {
            // copy anything else as is
            *out++ = *in++;
        }
    }
    *out = '\0';
    return (char *)buf;
}

// Push a UTF-8 string to the duk stack, first converting it to CESU-8 encoding
// Returns a pointer to the interned string
const char *push_utf8_string(duk_context *ctx, const char *str) {
    const duk_uint8_t *in = (const duk_uint8_t *)str;
    int supp_count = 0, out_size = 0;

    // scan input string, look for 4 byte UTF-8 chars, calculate required buffer size
    if (in != NULL) {
        while (*in) {
            if    ((in[0] & 0xF8) == 0xF0 && (in[1] & 0xC0) == 0x80
                && (in[2] & 0xC0) == 0x80 && (in[3] & 0xC0) == 0x80)
            {
                supp_count++;
                in += 4; out_size += 6;
            } else {
                in += 1; out_size += 1;
            }
        }        
    }
    // found no 4 byte characters to convert, so just push the string and return
    if (supp_count == 0) {        
        return duk_push_string(ctx, str);
    }

    // convert some UTF-8 characters to CESU-8
    duk_uint8_t *buf = malloc(out_size + 1);
    duk_uint8_t *out = buf;
    in = (const duk_uint8_t *)str;
    while (*in) {
        if    ((in[0] & 0xF8) == 0xF0 && (in[1] & 0xC0) == 0x80
            && (in[2] & 0xC0) == 0x80 && (in[3] & 0xC0) == 0x80)
        {
            out[0] = 0xED;
            out[1] = 0xA0 | (((in[0] & 0x07) << 2 | (in[1] & 0x30) >> 4) - 1);
            out[2] = 0x80 | (in[1] & 0x0F) << 2 | (in[2] & 0x30) >> 4;
            out[3] = 0xED;
            out[4] = 0xB0 | (in[2] & 0x0F);
            out[5] = in[3];
            in += 4; out += 6;
        } else {
            // copy anything else as is
            *out++ = *in++;
        }        
    }
    *out = '\0';
    const char *result = duk_push_string(ctx, (char *)buf);
    free(buf);
    return result;
}
```

## Using Duktape UTF-8

This approach is convenient for C code, because strings can be expressed
directly as UTF-8 with no conversion or dealing with surrogate pairs.

One limitation is that there is no Ecmascript syntax for non-BMP characters
so you can't use them in literals.  There are a few workarounds:

```js
// Decode from Duktape JX format which supports UTF-8.
var magnifyingGlass = Duktape.dec('jx', '"\\U0001f50d"');
print(magnifyingGlass.length);  // prints 1
print(Duktape.enc('hex', magnifyingGlass));  // prints f09f948d, direct UTF-8  for U+1F50D

// Enter UTF-8 data directly as hex.
var magnifyingGlass = Duktape.dec('hex', 'f09f948d');
print(magnifyingGlass.length);
print(Duktape.enc('hex', magnifyingGlass));

// Enter UTF-8 data into a buffer and coerce to string.
var magnifyingGlass = String(Duktape.Buffer(new Uint8Array([ 0xf0, 0x9f, 0x94, 0x8d ])));
print(magnifyingGlass.length);
print(Duktape.enc('hex', magnifyingGlass));

// Use String.fromCharCode(); since Duktape 1.2.0 fromCharCode() has default
// non-standard behavior (which can be disabled) to accept non-BMP codepoints.
var magnifyingGlass = String.fromCharCode(0x1f50d);
print(magnifyingGlass.length);
print(Duktape.enc('hex', magnifyingGlass));
```
