# Internal and external prototype

Ecmascript has two different prototype concepts which can be confusing:

* Internal prototype: present for all objects, controls actual property and
  method lookups.

* External prototype: the `.prototype` property of a constructor function,
  used to initialize the internal prototype of objects created using
  constructor calls (`new MyConstructor()`).

"Internal prototype" and "external prototype" are not standard terms, but used
in Duktape documentation for clarity.

See also:

* [[How to write a native constructor function|HowtoNativeConstructor]]

* https://developer.mozilla.org/en/docs/Web/JavaScript/Inheritance_and_the_prototype_chain

* http://stackoverflow.com/questions/383201/relation-between-prototype-and-prototype-in-javascript

## Internal prototype

The internal prototype, also referred to simply as "prototype", is
specified as the internal property `[[Prototype]]` in the Ecmascript
specification:

* http://www.ecma-international.org/ecma-262/5.1/#sec-8.6.2

It affects actual property lookups such as `obj.prop`.  To simplify a bit, a
property lookup:

* Checks if the property is found in the target object directly as a so-called
  "own property".

* If the property is found, the lookup finishes.

* If the property is not found, the internal prototype of the object is looked
  up.  If the internal prototype is `null`, the lookup fails.  Otherwise the
  property is looked up from the prototype object recursively.  The sequence of
  objects looked up is called the "prototype chain".

Being an internal property, the `[[Prototype]]` property is not directly
accessible, but it can be interacted with using:

* `obj.__proto__`: an accessor property inherited from `Object.prototype`
  which allows the internal prototype to be read/written for objects which
  inherit from `Object.prototype` (not all objects do!).  Specified in ES2015,
  also non-standard implementations before ES2015.

* `Object.getPrototypeOf()` and `Object.setPrototypeOf()`: explicit methods
  added in ES2015 to read/write the internal prototype.

* `duk_get_prototype()` and `duk_set_prototype()`: Duktape C API calls to
  read/write the internal prototype.

The Ecmascript APIs (`__proto__` and `Obj.setPrototypeOf`) prevent creation
of prototype loops; an attempt to create one fails with a TypeError:

```
duk> var obj1 = {}; var obj2 = {};
= undefined
duk> Object.setPrototypeOf(obj1, obj2); Object.setPrototypeOf(obj2, obj1);
TypeError: type error (rc -105)
	setPrototypeOf  native strict preventsyield
	global input:1 preventsyield
```

However, the Duktape C API is lower level and allows you to create a prototype
loop (which should generally be avoided).  Duktape has sanity limits to
terminate lookups from looped prototype chains.

## External prototype

The external prototype is the `.prototype` property present in most Ecmascript
functions.  It's present in all functions by default, but can be removed
manually (also some built-ins don't have the property).  The `.prototype`
property only has an effect when a function is called as a constructor, i.e.:

```
var obj = new MyConstructor();
```

When the constructor call happens (see
http://www.ecma-international.org/ecma-262/5.1/#sec-13.2.2 for details):

* Duktape will create a new empty object (the "default instance") whose
  internal prototype is initialized to the current value of the constructor's
  `.prototype` property.  If the `.prototype` value is not an object or is
  missing, the internal prototype is initialized to `Object.prototype`.

* The constructor function is called with the `this` binding pointing to the
  newly created default instance.  The constructor can then add properties to
  the default instance e.g. as `this.name = "my object";`.

* Normally the constructor function has no return value (or returns
  `undefined` explicitly) in which case the default instance is returned as
  the value of `new MyConstructor()`.

* However, if the constructor function explicitly returns an object value,
  e.g. using `var ret = { foo: 123 }; return ret;`, the default instance will
  be ignored and the returned object will become the value of the
  `new MyConstructor()` call.  This allows a constructor to return a function
  or a Proxy object, for example.

The only point where the external prototype has an effect is in initializing
the default instance.  In particular, if you ignore the default instance and
explicitly return an object value from the constructor, the external prototype
has no effect on the objects created.

## Default external prototype object of Ecmascript functions

When you declare a function in Ecmascript code the Ecmascript semantics
provide an automatic external `.prototype` object.  For example, when
declaring:

```js
function MyConstructor() {
    // ...
}
```

the following objects are automatically created:

* `MyConstructor`: the constructor function itself.

* `MyConstructor.prototype`: points to a newly created prototype object.

The prototype object is empty except for a `.constructor` property which
points back to the constructor function, so that:

```
MyConstructor.prototype.constructor === MyConstructor
```

The internal prototype of `MyConstructor.prototype` is `Object.prototype`
so that when properties are looked up from objects created using
`new MyConstructor()`, the prototype chain is by default:

* The object itself

* `MyConstructor.prototype`

* `Object.prototype`

For simple objects a common idiom is for inherited methods to be added to
`MyConstructor.prototype`.

There are many ways to control the eventual prototype chain of instance
objects:

* You can edit or replace `MyConstructor.prototype` to point to a different
  object.  This will only affects objects created after the change.

* You can change the internal prototype of `MyConstructor.prototype` so that
  another object (perhaps an ancestor) will be included in the prototype chain:
  `Object.setPrototypeOf(MyConstructor.prototype, MyAncestor.prototype)`.
  This will affect also objects already created.

* You can replace the "default instance" given to the constructor call with a
  different object, which gives full control over the prototype chain of the
  instance.  This will obviously affect only new instances created.

* Finally, you can edit object instances after they've been created.

## No default external prototype object for Duktape/C functions

Duktape/C functions behave identically to Ecmascript functions when called
as constructors: a default instance is created based on the `.prototype`
property of the Duktape/C function, etc.

However, to minimize memory usage, Duktape/C functions don't have an external
prototype (`.prototype` property) by default.  This means that the default
instance will inherit from `Object.prototype` unless you:

* Add a `.prototype` property for the Duktape/C function explicitly.

* Ignore the "default instance", creating and returning the instance object
  explicitly in the Duktape/C function.

* Editi the internal prototype of an instance after its creation.

See: [[How to write a native constructor function|HowtoNativeConstructor]].
