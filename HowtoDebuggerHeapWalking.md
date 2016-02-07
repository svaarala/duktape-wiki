# How to use debugger heap walking

## Overview

Starting from Duktape 1.5.0 the debugger protocol has support for inspecting
heap objects and walking the heap object graph using the following debugger
commands:

* InspectHeapObject: inspect an arbitrary heap pointer to get the object's
  "own" properties and Duktape internal fields encoded as artificial
  properties.

* FIXME: heap locking, to ensure heap pointers given to InspectHeapObject
  don't become stale because of garbage collection.

Because InspectHeapObject only returns the object's "own" properties, the
debug client must follow the prototype chain manually to discover any
inherited properties.  The benefit of doing so is that the inheritance
details are visible to the debug client which can e.g. see if there are
shadowing properties.

## Memory safety and ensuring valid pointers

One central issue in heap walking is memory safety: the debug client is
responsible for ensuring InspectHeapObject is never given a potentially
stale pointer, i.e. a pointer which may have been garbage collected by
Duktape (or was not a valid heap pointer to begin with).  There are two
basic approaches to this:

* The debug client can "lock" the garbage collector to ensure no objects
  are freed while heap walking may happen.  For example, the debug client
  can lock the garbage collector, execute an Eval which returns an object
  result unreachable from anywhere else, and then safely inspect that object.

* If the debug client knows for sure that the value is reachable for Duktape
  GC there's no need to for locking the garbage collector.  However, it's
  quite difficult to be 100% sure about this so locking is strongly
  recommended.

## InspectHeapObject concrete example

FIXME: up-to-date protocol dumps, JSON proxy format.  Point to property
format description, and illustrate format with the example.

## Inspecting the prototype chain

FIXME: describe the process, including sanity limit.  Example.

## Accessor properties

FIXME: no primitive to call these now.
