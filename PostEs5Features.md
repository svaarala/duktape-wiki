# Post-ES5 features

This page summarizes features implemented from
[ES2015](http://www.ecma-international.org/ecma-262/6.0/index.html) (ES6),
[ES2016](http://www.ecma-international.org/ecma-262/7.0/index.html) (ES7),
and later.  Custom features like Node.js Buffer and WHATWG Encoding API
are also listed.

Many of the features can be disabled through config options such as
`DUK_USE_ES6_PROXY` and `DUK_USE_BUFFEROBJECT_SUPPORT`.

## Summary

<table>

<tr>
<td>Feature</td>
<td>Specification</td>
<td>Status</td>
<td>Duktape<br />version</td>
<td>Notes</td>
</tr>

<tr>
<td><a href="http://duktape.org/guide.html#builtin-duktape">Duktape object</a></td>
<td>Duktape</td>
<td>n/a</td>
<td>1.0.0</td>
<td>Object providing Duktape specific operations like inspecting values, forcing
    a garbage collection run, etc.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-proxy-objects">Proxy object</a></td>
<td>ES2015</td>
<td>Partial</td>
<td>1.0.0</td>
<td>Partial support, see separate Proxy trap support table below.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-object.setprototypeof">Object.setPrototypeOf()</a></td>
<td>ES2015</td>
<td>Full</td>
<td>1.0.0</td>
<td><code>Object.setPrototypeOf()</code> allows user to set the internal
    prototype of an object which is not supported in Ecmascript E5.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-object.prototype.__proto__">Object.prototype.__proto__</a></td>
<td>ES2015 Annex B</td>
<td>Partial</td>
<td>1.0.0</td>
<td><code>Object.prototype.__proto__</code> is a setter/getter which provides
    the same functionality as <code>Object.getPrototypeOf()</code>
    and <code>Object.setPrototypeOf()</code> but is compatible with existing
    code base which has relied on a non-standard <code>__proto__</code>
    property for a while.  The property is not available for "bare objects".
    Duktape does not support
    <a href="http://www.ecma-international.org/ecma-262/6.0/index.html#sec-__proto__-property-names-in-object-initializers">__proto__ property name in an object initializer</a>.</td>
</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-regular-expressions-patterns">Additional RegExp syntax</a></td>
<td>ES2015 Annex B</td>
<td>Partial</td>
<td>1.0.0</td>
<td>Support for non-ES5 RegExp forms (most of them described in ES2015 Annex B)
    has been added incrementally over releases.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-arraybuffer-objects">ArrayBuffer</a></td>
<td>ES2015</td>
<td>Partial</td>
<td>1.3.0</td>
<td>Original Duktape implementation was based on the Khronos specification.
    Detached ArrayBuffers are not yet supported.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-typedarray-objects">Typed arrays</a></td>
<td>ES2015</td>
<td>Partial</td>
<td>1.3.0</td>
<td>Original Duktape implementation was based on the Khronos specification.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-dataview-objects">DataView</a></td>
<td>ES2015</td>
<td>Partial</td>
<td>1.3.0</td>
<td>Original Duktape implementation was based on the Khronos specification.</td>
</tr>

<tr>
<td><a href="https://nodejs.org/api/buffer.html">Node.js Buffer</a></td>
<td>Node.js v6.9.1</td>
<td>Partial</td>
<td>1.3.0</td>
<td>Original implementation was based on Node.js Buffer v0.12.1, current goal
    is Node.js v6.9.1 but not all methods are yet implemented.  Duktape tracks
    the latest Node.js Buffer API.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-let-and-const-declarations">const declaration</a></td>
<td>ES2015</td>
<td>Partial</td>
<td>1.4.0</td>
<td>Support is partial, <code>const</code> is mostly just an alias for
    <code>var</code> except that an initializer is required: const
    variables are writable and function scope rather than block scope.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-object-initializer-runtime-semantics-evaluation">Computed property names</a></td>
<td>ES2015</td>
<td>Partial</td>
<td>2.0.0</td>
<td>Computed method name in object literal not yet supported.
    Example: <code>{ [1+2]: 'three' }</code>.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-literals-numeric-literals">Octal number literal</a></td>
<td>ES2015</td>
<td>Full</td>
<td>2.0.0</td>
<td>Example: <code>0o755</code>.  Legacy octal literals
    like <code>0755</code> are also supported.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-literals-numeric-literals">Binary number literal</a></td>
<td>ES2015</td>
<td>Full</td>
<td>2.0.0</td>
<td>Example: <code>0b10001010</code>.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-literals-string-literals">\u{H+} Unicode escape</a></td>
<td>ES2015</td>
<td>Partial</td>
<td>2.0.0</td>
<td>The escape syntax is allowed in both string literals and identifier
    names.  Not yet supported in RegExps (requires /u flag support which
    is not yet implemented).  Non-BMP escapes decode to surrogate pairs.
    Example: <code>"pile of \u{1f4a9}"</code>.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-reflect-object">Reflect object</a></td>
<td>ES2015</td>
<td>Partial</td>
<td>2.0.0</td>
<td>Provides access to several fundamental Ecmascript primitives as function
    calls.  For example, <code>Reflect.construct()</code> behaves like
    <code>new</code>.  Currently has some limitations, e.g. explicit
    <code>newTarget</code> is not supported in <code>Reflect.construct()</code>.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-ordinary-object-internal-methods-and-internal-slots-ownpropertykeys">ES2015 enumeration order</a></td>
<td>ES2015</td>
<td>Full</td>
<td>2.0.0</td>
<td><code>Object.getOwnPropertyNames()</code> follows the
    <a href="http://www.ecma-international.org/ecma-262/6.0/#sec-ordinary-object-internal-methods-and-internal-slots-ownpropertykeys">ES2015 [[OwnPropertyKeys]]</a>
    enumeration order: (1) array indices in ascending order, (2) other properties
    in insertion order, (3) symbols in insertion order.  While ES2015 or ES2016 don't
    require it, Duktape follows this same order also for <code>for-in</code>,
    <code>Object.keys()</code>, and <code>duk_enum()</code> in general.  As in V8,
    the rule is applied for every "inheritance level" in turn, i.e. inherited
    non-duplicate properties always follow child properties.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/7.0/#sec-exp-operator">Exponentiation operator</a></td>
<td>ES2016</td>
<td>Full</td>
<td>2.0.0</td>
<td>Example: <code>x ** y</code>, <code>x **= y</code>.</td>
</tr>

<tr>
<td><a href="https://github.com/tc39/ecma262/pull/263">RegExp getter lenience</a></td>
<td>ES2017 draft</td>
<td>n/a</td>
<td>2.0.0</td>
<td>RegExp.prototype.flags and other getters accept the RegExp.prototype
    object as a this binding without throwing a TypeError.
    See  <a href="https://github.com/tc39/ecma262/pull/263">RegExp.prototype issues</a>.</td>
</tr>

<tr>
<td><a href="http://www.ecma-international.org/ecma-262/6.0/#sec-symbol-objects">Symbol object</a></td>
<td>ES2015</td>
<td>Full</td>
<td>2.0.0</td>
<td>Experimental, <code>Symbol</code> binding is disabled by default in
    Duktape 2.0.0, enable using <code>DUK_USE_SYMBOL_BUILTIN</code>.</td>
</tr>

<tr>
<td><a href="https://encoding.spec.whatwg.org/">Encoding API</a></td>
<td>WHATWG</td>
<td>Full</td>
<td>2.0.0</td>
<td>TextEncoder() and TextDecoder(), supports UTF-8 encoding.</td>
</tr>

<tr>
<td><a href="https://github.com/tc39/proposal-global">"global" binding</td>
<td>TC39 proposal</td>
<td>Full</td>
<td>2.1.0</td>
<td>Named binding "global" for the global object.</td>
</tr>
</tr>

</table>

## Proxy handlers (traps)

The Ecmascript ES2015 `Proxy` object allows property virtualization
and fine-grained access control for accessing an underlying plain object.
Duktape implements a strict subset of the `Proxy` object from ES2015.
Status of trap implementation:

<table>
<tr><th>Trap</th><th>Implemented</th><th>Notes</th></tr>
<tr><td>getPrototypeOf</td><td>no</td><td></td></tr>
<tr><td>setPrototypeOf</td><td>no</td><td></td></tr>
<tr><td>isExtensible</td><td>no</td><td></td></tr>
<tr><td>preventExtension</td><td>no</td><td></td></tr>
<tr><td>getOwnPropertyDescriptor</td><td>no</td><td></td></tr>
<tr><td>defineProperty</td><td>no</td><td></td></tr>
<tr><td>has</td><td>yes</td><td><code>Object.hasOwnProperty()</code> does not invoke the trap at the moment, <code>key in obj</code> does.</td></tr>
<tr><td>get</td><td>yes</td><td></td></tr>
<tr><td>set</td><td>yes</td><td></td></tr>
<tr><td>deleteProperty</td><td>yes</td><td></td></tr>
<tr><td>enumerate</td><td>no (*)</td><td>The "enumerate" trap was removed in ES7 and for-in uses "ownKeys" trap; Duktape 1.x supports "enumerate" trap in for-in.</td></tr>
<tr><td>ownKeys</td><td>yes</td><td>Some trap result validation (non-configurable properties, non-extensible target) not yet implemented.</td></tr>
<tr><td>apply</td><td>no</td><td></td></tr>
<tr><td>construct</td><td>no</td><td></td></tr>
</table>

Limitations include:

* Only about half of the ES2015 traps have been implemented.  This causes odd
  behavior if you e.g. call `Object.defineProperty()` on a proxy object.

* Proxy trap results are not validated, e.g. `ownKeys` trap result validation
  steps described in
  [[[OwnPropertyKeys]] \(\)](http://www.ecma-international.org/ecma-262/6.0/#sec-proxy-object-internal-methods-and-internal-slots-ownpropertykeys)
  for non-configurable target properties and/or non-extensible target object
  are not yet implemented.

* Proxy revocation feature of ES2015 is not supported.

* The target and handler objects given to `new Proxy()` cannot be Proxy
  objects themselves.  ES2015 poses no such limitation, but Duktape enforces
  it for now to simplify the internal implementation.
