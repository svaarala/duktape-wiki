# ((o) Duktape Wiki

Welcome to the official Duktape Wiki!

## Documentation

* <http://duktape.org/guide.html> - older:
  [1.5](http://duktape.org/1.5.0/guide.html)
  [1.4](http://duktape.org/1.4.0/guide.html)
  [1.3](http://duktape.org/1.3.0/guide.html)
  [1.2](http://duktape.org/1.2.0/guide.html)
  [1.1](http://duktape.org/1.1.0/guide.html)
  [1.0](http://duktape.org/1.0.0/guide.html)
* <http://duktape.org/api.html> - older:
  [1.5](http://duktape.org/1.5.0/api.html)
  [1.4](http://duktape.org/1.4.0/api.html)
  [1.3](http://duktape.org/1.3.0/api.html)
  [1.2](http://duktape.org/1.2.0/api.html)
  [1.1](http://duktape.org/1.1.0/api.html)
  [1.0](http://duktape.org/1.0.0/api.html)

## Getting started

* [Getting started: line processing](GettingStartedLineProcessing.md)
* [Getting started: primality testing](GettingStartedPrimalityTesting.md)

## How-To

* [How to handle fatal errors](HowtoFatalErrors.md)
* [How to work with value stack types](HowtoValueStackTypes.md)
* [How to make function calls](HowtoFunctionCalls.md)
* [How to use virtual properties](HowtoVirtualProperties.md)
* [How to use finalization](HowtoFinalization.md)
* [How to work with buffers](HowtoBuffers.md) ([Duktape 1.x](HowtoBuffers1x.md), [Duktape 2.x](HowtoBuffers2x.md))
* [How to work with lightfuncs](HowtoLightfuncs.md)
* [How to use modules](HowtoModules.md)
* [How to use coroutines](HowtoCoroutines.md)
* [How to use logging](HowtoLogging.md)
* [How to persist object references in native code](HowtoNativePersistentReferences.md)
* [How to write a native constructor function](HowtoNativeConstructor.md)
* [How to iterate over an array](HowtoIterateArray.md)
* [How to augment error objects](HowtoAugmentErrorObjects.md)
* [How to decode Duktape bytecode](HowtoDecodeBytecode.md)
* [How to work with non-BMP characters](HowtoNonBmpCharacters.md)
* [How to get a reference to the global object](HowtoGlobalObjectReference.md)
* [How to run on bare metal platforms](HowtoBareMetal.md)
* [How to enable debug prints](HowtoDebugPrints.md)

## Frequently asked questions

* [Development setup for developing Duktape](DevelopmentSetup.md)
* [Internal and external prototype](InternalExternalPrototype.md)
* [API C types](ApiCTypes.md)
* [Post-ES5 features](PostEs5Features.md)

## Config and feature options

* [Configuring Duktape for build](Configuring.md)
* [Config options](ConfigOptions.md) (DUK_USE_xxx) used in [duk_config.h](https://github.com/svaarala/duktape/blob/master/doc/duk-config.rst)
* Feature options (DUK_OPT_XXX) used as compiler command line options (up to Duktape 1.3), see https://github.com/svaarala/duktape/tree/master/config/feature-options

## Portability and compatibility

* [Portability](Portability.md) notes for various compilers and target, compilation and troubleshooting tips
* platforms
* architectures
* compilers
* standard libraries: musl, uclibc
* [Compatibility with TypeScript](CompatibilityTypeScript.md)

## Performance

* <http://duktape.org/benchmarks.html>
* [How to optimize performance](Performance.md)
* [Duktape 1.3.0 performance measurement](Performance130.md)
* [Duktape 1.4.0 performance measurement](Performance140.md)
* [Duktape 1.5.0 performance measurement](Performance150.md)
* [Duktape 2.0.0 performance measurement](Performance200.md)
* [Duktape 2.1.0 performance measurement](Performance210.md)
* [Duktape 2.2.0 performance measurement](Performance220.md)

## Low memory optimization

* Low memory environments: [low-memory.rst](https://github.com/svaarala/duktape/blob/master/doc/low-memory.rst)
* Low memory config option suggestions: [low-memory.yaml](https://github.com/svaarala/duktape/blob/master/config/examples/low_memory.yaml)
* Hybrid pool allocator example: [alloc-hybrid](https://github.com/svaarala/duktape/tree/master/examples/alloc-hybrid)

## Miscellaneous

* [Projects using Duktape](ProjectsUsingDuktape.md)
* [Debug clients](DebugClients.md)

## Contributing, copyright, and license

* <https://github.com/svaarala/duktape-wiki>
