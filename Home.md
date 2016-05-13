# ((o) Duktape Wiki

Welcome to the official Duktape Wiki!

## Documentation

* http://duktape.org/guide.html - older:
  [1.5](http://duktape.org/1.5.0/guide.html)
  [1.4](http://duktape.org/1.4.0/guide.html)
  [1.3](http://duktape.org/1.3.0/guide.html)
  [1.2](http://duktape.org/1.2.0/guide.html)
  [1.1](http://duktape.org/1.1.0/guide.html)
  [1.0](http://duktape.org/1.0.0/guide.html)
* http://duktape.org/api.html - older:
  [1.5](http://duktape.org/1.5.0/api.html)
  [1.4](http://duktape.org/1.4.0/api.html)
  [1.3](http://duktape.org/1.3.0/api.html)
  [1.2](http://duktape.org/1.2.0/api.html)
  [1.1](http://duktape.org/1.1.0/api.html)
  [1.0](http://duktape.org/1.0.0/api.html)

## Getting started

* [[Getting started: line processing|GettingStartedLineProcessing]]
* [[Getting started: primality testing|GettingStartedPrimalityTesting]]

## How-To

* [[How to use virtual properties|HowtoVirtualProperties]]
* [[How to use finalization|HowtoFinalization]]
* [[How to work with buffers|HowtoBuffers]]
* [[How to use modules|HowtoModules]]
* [[How to use coroutines|HowtoCoroutines]]
* [[How to use logging|HowtoLogging]]
* [[How to persist object references in native code|HowtoNativePersistentReferences]]
* [[How to write a native constructor function|HowtoNativeConstructor]]
* [[How to iterate over an array|HowtoIterateArray]]
* [[How to augment error objects|HowtoAugmentErrorObjects]]
* [[How to decode Duktape bytecode|HowtoDecodeBytecode]]
* [[How to work with non-BMP characters|HowtoNonBmpCharacters]]
* [[How to get a reference to the global object|HowtoGlobalObjectReference]]
* [[How to run on bare metal platforms|HowtoBareMetal]]
* [[How to use enable debug prints|HowtoDebugPrints]]

## Frequently asked questions

* [[Development setup for developing Duktape|DevelopmentSetup]]
* [[Internal and external prototype|InternalExternalPrototype]]
* [[API C types|ApiCTypes]]
* [[Post-ES5 features|PostEs5Features]]

## Config and feature options

* [[Configuring Duktape for build|Configuring]]
* [[Feature options|FeatureOptions]] (DUK_OPT_xxx) used as compiler command line options (up to Duktape 1.3)
* [[Config options|ConfigOptions]] (DUK_USE_xxx) used in [duk_config.h](https://github.com/svaarala/duktape/blob/master/doc/duk-config.rst)

## Portability and compatibility

* [[Portability|Portability]] notes for various compilers and target, compilation and troubleshooting tips
* platforms
* architectures
* compilers
* standard libraries: musl, uclibc
* [[Compatibility with TypeScript|CompatibilityTypeScript]]

## Performance

* [[How to optimize performance|Performance]]
* [[Duktape 1.3.0 performance measurement|Performance130]]
* [[Duktape 1.4.0 performance measurement|Performance140]]
* [[Duktape 1.5.0 performance measurement|Performance150]]
* [[Duktape 2.0.0 performance measurement|Performance200]]

## Low memory optimization

* Low memory environments: [low-memory.rst](https://github.com/svaarala/duktape/blob/master/doc/low-memory.rst)
* Low memory config option suggestions: [low-memory.yaml](https://github.com/svaarala/duktape/blob/master/config/examples/low_memory.yaml)
* Hybrid pool allocator example: [alloc-hybrid](https://github.com/svaarala/duktape/tree/master/examples/alloc-hybrid)

## Miscellaneous

* [[Projects using Duktape|ProjectsUsingDuktape]]
* [[Debug clients|DebugClients]]

## Contributing, copyright, and license

* https://github.com/svaarala/duktape-wiki
