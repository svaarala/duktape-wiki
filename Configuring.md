# Configuring Duktape for build

## Duktape 2.x

See [Configuring Duktape 2.x for build](Configuring2x.md).

## Duktape 1.x

See [Configuring Duktape 1.x for build](Configuring1x.md).

## Options for specific environments

### Timing sensitive

Timing sensitive applications include e.g. games.  For such environments
steady, predictable performance is important, often more important than
absolute performance.  Duktape provides some options to improve use in these
environments; for instance, you can disable automatic mark-and-sweep and rely
on reference counting and manually requested mark-and-sweep for garbage
collection.

See:

* [timing-sensitive.rst](https://github.com/svaarala/duktape/blob/master/doc/timing-sensitive.rst)
* [timing_sensitive.yaml](https://github.com/svaarala/duktape/blob/master/config/examples/timing_sensitive.yaml)

### Memory constrained

Duktape can work in 192kB flash memory (code footprint) and 64kB system
RAM (including Duktape and a minimal OS), and provides a lot of feature
options to minimize memory footprint.  These feature options are often
useful for systems with less than 256kB of system RAM.

See:

* [low-memory.rst](https://github.com/svaarala/duktape/blob/master/doc/low-memory.rst)
* [low_memory.yaml](https://github.com/svaarala/duktape/blob/master/config/examples/low_memory.yaml)
* [low_memory_strip.yaml](https://github.com/svaarala/duktape/blob/master/config/examples/low_memory_strip.yaml)

### Performance sensitive

The default Duktape build has reasonable performance options for most
environments.  Even so there are some feature options which
may be used to improve performance by e.g. enabling fast paths, enabling
"fastint" support, or trading some API safety for performance.

See:

* [performance-sensitive.rst](https://github.com/svaarala/duktape/blob/master/doc/performance-sensitive.rst)
* [performance_sensitive.yaml](https://github.com/svaarala/duktape/blob/master/config/examples/performance_sensitive.yaml)
