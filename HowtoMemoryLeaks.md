# How to diagnose memory leaks

Memory leaks can be difficult to pinpoint so this document describes a
few common causes and possible diagnosis steps.

## Common causes of memory leaks

* Application code unrelated to Duktape.  Duktape and application code often
  share the same allocator functions (e.g. `malloc()`, `realloc()`, and
  `free()`) which can complicate diagnosis.

* Application code using `duk_alloc()` without a corresponding `duk_free()`.
  While `duk_alloc()` is provided by Duktape and may invoke garbage collection
  to satisfy the allocation request, the allocated memory is not automatically
  freed, even on `duk_destroy_heap()`.

* Application code using `duk_get_heapptr()` and `duk_push_heapptr()` without
  guaranteeing that the value is reachable (from Duktape point of view) at all
  times.  Because of reference counting, the value may be freed immediately
  when it becomes unreachable, invalidating the pointer.  If that happens and
  `duk_push_heapptr()` is called, the result is unpredictable and may include
  memory unsafe behavior or memory leak like behavior.

* Application code failing to free native resources in a finalizer.  Because
  finalizers errors are silently ignored, any bugs in finalizers can cause
  memory leaks.

  - Finalizers should be wrapped in a `duk_safe_call()` or, if written in
    Ecmascript, in a try-catch block.

  - Note that Ecmascript finalizers will not execute if a script timeout has
    occurred (requires application to provide a script timeout macro) which
    may cause apparent leaks.  When using script timeouts, it's safest to
    write finalizers as Duktape/C functions.

* Application code "leaking" references accidentally.  For example, references
  to callback functions may be stored in a timer data structure but fail to be
  deleted when timers expire.  This causes the functions to remain reachable
  which looks like a memory leak.  The cause here is an actual live reference,
  not a memory leak as such.

  - These can be diagnosed by printing out application specific tracking
    structures, the global object, etc periodically and seeing if anything
    accumulates in the data structures.

  - This memory is not permanently lost: `duk_destroy_heap()` will cause the
    memory to be freed.

* Application code accidentally accumulating values in the value stack of one
  or more Duktape contexts.  This is easy to do e.g. in an event loop which
  does a protected call but fails to pop the result.  The value stack will
  keep on growing.  This looks like a memory leak but is similar to leaving
  references laying around accidentally.

* Circular references in objects (typically function instances) prevent the
  objects in question from being collected by reference counting.  The objects
  will be collected by mark-and-sweep, but this may take a relatively long
  time and it may appear as if the memory had leaked.

  - This memory is collected by doing a forced `duk_gc(ctx, 0)` (or
    equivalently, `Duktape.gc()`).  This shouldn't be necessary in normal
    code of course, but helps diagnose the issue.

* Reference count bugs in Duktape may cause a value to have an incorrect
  reference count.  If the count is too small, the value may be freed too
  early causing memory safety issues (= segfaults).  If the count is too
  large, the value may stay around longer than it is referenced, but should
  eventually be collected by mark-and-sweep which doesn't assume refcounts
  are correct.

  - This memory is collected by doing a forced `duk_gc(ctx, 0)`.

* Memory corruption may cause unpredictable behavior; often memory unsafe
  behavior results (= segfault) but it's also possible to cause situations
  which look like memory leaks but won't cause crashes.

## Diagnosis tips

* Run Duktape with valgrind, reproduce the problem, exit.  Check Valgrind
  output related to memory leaks; valgrind can usually provide some indication
  where the leaked memory block was allocated.

* To rule out the possibility of a long garbage collection delay being
  confused with a memory leak, add `duk_gc(ctx, 0)` calls to see if the
  problem disappears.  If so, it's quite likely there isn't an actual memory
  leak.  It's still possible for Duktape refcounts to be out of sync, with
  memory normally freed via refcounting being freed only by mark-and-sweep.

* Call `duk_destroy_heap(ctx)` and see if allocated memory remains.

* Print `duk_get_top(ctx)` periodically from the top level code, e.g. an
  event loop.  This rules out value stack accumulation quickly.
