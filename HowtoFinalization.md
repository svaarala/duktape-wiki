# How to use finalization

Guide documentation: http://duktape.org/guide.html#finalization.

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

## Heap destruction

When a Duktape heap is being destroyed finalizers are called normally,
however:

* Objects cannot be rescued.  The finalizer must free native resources on
  the initial finalizer call, because the finalizer won't be called again
  even if new references to the target object are created.

* A finalizer may create new finalizable objects, and these too will be
  finalized.  However, there's a sanity limit to this process to catch
  runaway finalizers.  You shouldn't normally encounter the limit.

The finalizer is given a second argument since Duktape 1.4.0, a boolean
indicating if the object cannot be rescued (i.e. heap destruction is in
progress).  The argument is `true` when rescue is not possible, `false`
otherwise.  Duktape 1.3.0 and prior won't provide the argument.

If a finalizer both (1) manages native resources which must be freed, and
(2) uses object rescuing and relies on the finalizer being called again
later, you should check for the heap destruction case explicitly, e.g.:

```js
function myFinalizer(obj, heapDestruct) {
    if (heapDestruct) {
        // Heap is being destroyed, must free immediately.
        freeNativeResources();
        return;
    }

    // Normal case: may rescue object, with the guarantee that the finalizer
    // will be called later.
}
```

## Current sanity algorithm for finalizers during heap destruction

The finalizer sanity limit in heap destruction works currently roughly as
follows (the exact details may change between releases):

* All allocated heap objects are iterated, with all finalizable objects
  finalized.  A finalizer is never executed again for a certain object,
  which is tracked using `DUK_HEAPHDR_FLAG_FINALIZED`.  Let `n_total` be
  the count of all heap objects, and `n_finalized` be the count of all
  objects whose finalizer we executed (or rather, tried to execute) on
  this round.

* A limit for the number of finalizable objects is computed as:

  - First round: `n_limit = 2 * n_total`.

  - Subsequent rounds: `n_limit = n_limit * 3 / 4`, i.e. decrease
    by roughly 25%.

* If `n_finalized == 0` all finalizers are done and we're finished.

* If `n_finalized >= n_limit` the number of finalizable objects is not
  decreasing as expected, which is probably caused by a runaway
  finalizer.  The finalization process is terminated and remaining
  finalizers won't be executed, which may cause native resource leaks.

* In other cases, restart loop.

The motivation behind this algorithm is to ensure all finalizers are
executed in heap destruction, unless there's clearly a runaway finalizer
which would never allow the process to terminate.

The initial limit is quite large to allow the number of finalizable
objects to grow initially, but it must then decrease at least 25% on
every round or the finalization process aborts.

There's some discussion of heap destruction approaches in:
https://github.com/svaarala/duktape/pull/473.
