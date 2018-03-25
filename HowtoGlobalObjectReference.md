# How to get a reference to the global object

There is no standard named binding for the global object in Ecmascript, so
scripts access it using various idioms.  Since Duktape 2.1 an explicit
`global` binding is available, based on <https://github.com/tc39/proposal-global>.

The following snippet provides easy (if cryptic) access to the global object
from any context: global (program) code, eval code, and function code,
regardless of whether the context is strict or not:

```js
var globalObject = new Function('return this;')();
```

Because `global` is likely to be standardized, the following polyfill may be
preferable (https://github.com/svaarala/duktape/blob/master/polyfills/global.js):

```js
if (typeof global === 'undefined') {
    (function () {
        var global = new Function('return this;')();
        Object.defineProperty(global, 'global', {
            value: global,
            writable: true,
            enumerable: false,
            configurable: true
        });
    })();
}
```

The `new Function(...)` creates a new function with its body given as an
argument.  Unlike most other contexts, the strictness of the surrounding
code is *not* inherited so that `this` gets consistently bound to the
global object as the function created is not strict.
