# How to get a reference to the global object

The following snippet provides easy (if cryptic) access to the global object
from any context: global (program) code, eval code, and function code,
regardless of whether the context is strict or not:

```js
var globalObject = new Function('return this;')();
```

The `new Function(...)` creates a new function with its body given as an
argument.  Unlike most other contexts, the strictness of the surrounding
code is *not* inherited so that `this` gets consistently bound to the
global object as the function created is not strict.
