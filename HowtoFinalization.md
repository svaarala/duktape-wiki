# How to use finalization

## Simple example

Finalization example:

```js
// finalize.js
var a;

function init() {
    a = { foo: 123 };

    Duktape.fin(a, function (x) {
        try {
            print('finalizer, foo ->', x.foo);
        } catch (e) {
            print('WARNING: finalizer failed (ignoring): ' + e);
        }
    });
}

// create object, reference it through 'a'
init();

// delete reference, refcount triggers finalization immediately
print('refcount finalizer');
a = null;

// mark-and-sweep finalizing happens here (at the latest) if
// refcounting is disabled
print('mark-and-sweep finalizer')
Duktape.gc();
```

The `try-catch` wrapper inside the finalizer of the above example is
strongly recommended.  An uncaught finalizer error is silently ignored
which can be confusing, as it may seem like the finalizer is not
getting executed at all.

If you run this with the Duktape command line tool (with the default
Duktape profile), you'll get:

```
$ duk finalize.js
refcount finalizer
finalizer, foo -> 123
mark-and-sweep finalizer
Cleaning up...
```

## Adding a finalizer to a prototype object

If you have many objects of the same type, you can add a finalizer to the
prototype to minimize the property count of object instances:

```js
// Example of a hypothetical Socket object which is associated with a
// platform specific file descriptor.

function Socket(host, port) {
    this.host = host;
    this.port = port;
    this.fd = Platform.openSocket(host, port);
}
Duktape.fin(Socket.prototype, function (x) {
    if (x === Socket.prototype) {
        return;  // called for the prototype itself
    }
    if (typeof x.fd !== 'number') {
        return;  // already freed
    }
    try {
        Platform.closeSocket(x.fd);
    } catch (e) {
        print('WARNING: finalizer failed for fd ' + x.fd + ' (ignoring): ' + e);
    }
    delete x.fd;
});

// Any Socket instances are now finalized without registering explicit
// finalizers for them:

var sock = new Socket('localhost', 8080);
```
