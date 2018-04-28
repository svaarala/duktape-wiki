# How to write a native constructor function

A native constructor function works essentially the same way an ECMAScript
constructor does, except that Duktape/C functions don't have a `.prototype`
property by default.

There are two basic ways (in ECMAScript) to create a new instance through
a constructor call:

* Using the **default instance** given to the constructor automatically

* Returning a **replacement instance** from the constructor

## Using the default instance

When an ECMAScript constructor function is called as `new MyObject()`:

* A default instance object is created automatically before the call happens.
  This object will be empty, and its internal prototype is set to
  `MyObject.prototype` if that exists, or `Object.prototype` otherwise.

* The default instance is bound to `this` for the constructor call.

This default instance will be the result of `new MyObject()` unless the
constructor returns an object value.

In ECMAScript this basic idiom looks like:

```js
function MyObject(name) {
    // When called as new MyObject(), "this" will be bound to the default
    // instance object here.

    this.name = name;

    // Return undefined, which causes the default instance to be used.
}

// For an ECMAScript function an automatic MyObject.prototype value will be
// set.  That object will also have a .constructor property pointing back to
// Myobject.  You can add instance methods to MyObject.prototype.

MyObject.prototype.printName = function () {
    print('My name is: ' + this.name);
};

var obj = new MyObject('test object');
obj.printName();  // My name is: test object
```

When implementing the equivalent in C, the only difference is that Duktape/C
functions don't automatically have a `.prototype` property.  This means that
the default instance will inherit from `Object.prototype` unless you set the
`.prototype` property manually, as is done below:

```c
/* MyObject.prototype.printName */
duk_ret_t myobject_print_name(duk_context *ctx) {
	/* Stack at entry is: [ ] */

	/* Get access to the 'this' binding. */
	duk_push_this(ctx);  /* -> stack: [ this ] */

	/* Read this.name */
	duk_get_prop_string(ctx, -1, "name");

	printf("My name is: %s\n", duk_safe_to_string(ctx, -1));

	return 0;  /* no return value (= undefined) */
}

/* MyObject */
duk_ret_t myobject_constructor(duk_context *ctx) {
	/* Stack at entry is: [ name ] */

	/* All Duktape/C functions can be called both as constructors
	 * ("new func()") and functions ("func()").  Sometimes objects
	 * allow both calls, sometimes not.  Here we reject a normal
	 * non-constructor call.
	 */
	if (!duk_is_constructor_call(ctx)) {
		return DUK_RET_TYPE_ERROR;
	}

	/* Get access to the default instance. */
	duk_push_this(ctx);  /* -> stack: [ name this ] */

	/* Set this.name to name. */
	duk_dup(ctx, 0);  /* -> stack: [ name this name ] */
	duk_put_prop_string(ctx, -2, "name");  /* -> stack: [ name this ] */

	/* Return undefined: default instance will be used. */
	return 0;
}

/* Initialize MyObject into global object. */
void myobject_init(duk_context *ctx) {
	/* Push constructor function; all Duktape/C functions are
	 * "constructable" and can be called as 'new Foo()'.
	 */
	duk_push_c_function(ctx, myobject_constructor, 1 /*nargs*/);

	/* Push MyObject.prototype object. */
	duk_push_object(ctx);  /* -> stack: [ MyObject proto ] */

	/* Set MyObject.prototype.printName. */
	duk_push_c_function(ctx, myobject_print_name, 0 /*nargs*/);
	duk_put_prop_string(ctx, -2, "printName");

	/* Set MyObject.prototype = proto */
	duk_put_prop_string(ctx, -2, "prototype");  /* -> stack: [ MyObject ] */

	/* Finally, register MyObject to the global object */
	duk_put_global_string(ctx, "MyObject");  /* -> stack: [ ] */
}

void test(duk_context *ctx) {
	myobject_init(ctx);

	/* Test creation of a new object from ECMAScript code. */
	duk_eval_string(ctx, "new MyObject('test object')");
	/* ... stack top has result ... */
	duk_get_prop_string(ctx, -1, "printName");  /* call obj.printName(); */
	duk_dup(ctx, -2);
	duk_call_method(ctx, 0 /*nargs*/);
	duk_pop(ctx);  /* pop call result */
	duk_pop(ctx);  /* pop instance */

	/* Test creation of a new object from C code. */
	duk_get_global_string(ctx, "MyObject");
	duk_push_string(ctx, "test object");  /* name argument */
	duk_new(ctx, 1 /*nargs*/);
	/* ... stack top has result ... */
	duk_get_prop_string(ctx, -1, "printName");  /* call obj.printName(); */
	duk_dup(ctx, -2);
	duk_call_method(ctx, 0 /*nargs*/);
	duk_pop(ctx);  /* pop call result */
	duk_pop(ctx);  /* pop instance */
}
```

Or, cutting out the verbose comments:

```c
/* MyObject.prototype.printName */
duk_ret_t myobject_print_name(duk_context *ctx) {
	duk_push_this(ctx);
	duk_get_prop_string(ctx, -1, "name");
	printf("My name is: %s\n", duk_safe_to_string(ctx, -1));
	return 0;
}

/* MyObject */
duk_ret_t myobject_constructor(duk_context *ctx) {
	if (!duk_is_constructor_call(ctx)) {
		return DUK_RET_TYPE_ERROR;
	}

	/* Set this.name = name; */
	duk_push_this(ctx);
	duk_dup(ctx, 0);
	duk_put_prop_string(ctx, -2, "name");

	return 0;  /* use default instance */
}

/* Initialize MyObject into global object. */
void myobject_init(duk_context *ctx) {
	duk_push_c_function(ctx, myobject_constructor, 1 /*nargs*/);
	duk_push_object(ctx);
	duk_push_c_function(ctx, myobject_print_name, 0 /*nargs*/);
	duk_put_prop_string(ctx, -2, "printName");
	duk_put_prop_string(ctx, -2, "prototype");
	duk_put_global_string(ctx, "MyObject");
}

void test(duk_context *ctx) {
	myobject_init(ctx);

	/* Test creation of a new object from ECMAScript code. */
	duk_eval_string(ctx, "new MyObject('test object')");
	/* ... stack top has result ... */
	duk_get_prop_string(ctx, -1, "printName");  /* call obj.printName(); */
	duk_dup(ctx, -2);
	duk_call_method(ctx, 0 /*nargs*/);
	duk_pop(ctx);  /* pop call result */
	duk_pop(ctx);  /* pop instance */

	/* Test creation of a new object from C code. */
	duk_get_global_string(ctx, "MyObject");
	duk_push_string(ctx, "test object");  /* name argument */
	duk_new(ctx, 1 /*nargs*/);
	/* ... stack top has result ... */
	duk_get_prop_string(ctx, -1, "printName");  /* call obj.printName(); */
	duk_dup(ctx, -2);
	duk_call_method(ctx, 0 /*nargs*/);
	duk_pop(ctx);  /* pop call result */
	duk_pop(ctx);  /* pop instance */
}
```

This C version is almost identical to the ECMAScript version in function.
There are at least two clear differences however:

* The ECMAScript version of `MyObject` allows both constructor and normal
  function call invocations.  The C version rejects a non-constructor call
  which is less error prone.

* The ECMAScript version of `MyObject.prototype` has a `.constructor` back
  reference, so that `MyObject.prototype.constructor === MyObject`.  The
  C version lacks this, but the reference would be easy to add.  The
  `.constructor` back reference has no function from the ECMAScript engine
  point of view, but some calling code may expect to find it.

## Using a replacement value

This is a less often used approach, but still fully supported by the
ECMAScript standard.

In ECMAScript code:

```js
var MyObject_prototype = {};
MyObject_prototype.printName = function () {
    print('My name is: ' + this.name)
};

function MyObject(name) {
    // "this" binding has the default instance, ignore it.
    // Create result object explicitly.
    var result = {};
    result.name = name;

    // You can set the internal prototype for the result explicitly.
    Object.setPrototypeOf(result, MyObject_prototype);

    // Important: by returning an object value the constructor
    // indicates that the return value should be used instead
    // of the default instance (which is always created).
    return result;
}

var obj = new MyObject('test object');
obj.printName();  // My name is: test object
```

In Duktape/C this approach has the advantage that you don't need to set a
`.prototype` object for the Duktape/C function; the default instance will
inherit from `Object.prototype` but since we ignore the default instance,
this won't matter:

```c
/* MyObject_prototype.printName */
duk_ret_t myobject_print_name(duk_context *ctx) {
	duk_push_this(ctx);  /* -> stack: [ this ] */
	duk_get_prop_string(ctx, -1, "name");
	printf("My name is: %s\n", duk_safe_to_string(ctx, -1));
	return 0;
}

/* MyObject */
duk_ret_t myobject_constructor(duk_context *ctx) {
	/* Stack at entry is: [ name ] */

	if (!duk_is_constructor_call(ctx)) {
		return DUK_RET_TYPE_ERROR;
	}

	/* Push explicitly created instance and set its prototype. */
	duk_push_object(ctx);
	duk_get_global_string(ctx, "MyObject_prototype");
	duk_set_prototype(ctx, -2);  /* -> stack: [ name result ] */

	/* Set result.name to name. */
	duk_dup(ctx, 0);
	duk_put_prop_string(ctx, -2, "name");  /* -> stack: [ name result ] */

	/* Return the 'result' object: replaces the default instance. */
	return 1;
}

/* Initialize MyObject into global object. */
void myobject_init(duk_context *ctx) {
	/* Register MyObject_prototype. */
	duk_push_object(ctx);
	duk_push_c_function(ctx, myobject_print_name, 0 /*nargs*/);
	duk_put_prop_string(ctx, -2, "printName");
	duk_put_global_string(ctx, "MyObject_prototype");

	/* Register MyObject. */
	duk_push_c_function(ctx, myobject_constructor, 1 /*nargs*/);
	duk_put_global_string(ctx, "MyObject");  /* -> stack: [ ] */
}

void test(duk_context *ctx) {
	myobject_init(ctx);

	/* Test creation of a new object from ECMAScript code. */
	duk_eval_string(ctx, "new MyObject('test object')");
	/* ... stack top has result ... */
	duk_get_prop_string(ctx, -1, "printName");  /* call obj.printName(); */
	duk_dup(ctx, -2);
	duk_call_method(ctx, 0 /*nargs*/);
	duk_pop(ctx);  /* pop call result */
	duk_pop(ctx);  /* pop instance */

	/* Test creation of a new object from C code. */
	duk_get_global_string(ctx, "MyObject");
	duk_push_string(ctx, "test object");  /* name argument */
	duk_new(ctx, 1 /*nargs*/);
	/* ... stack top has result ... */
	duk_get_prop_string(ctx, -1, "printName");  /* call obj.printName(); */
	duk_dup(ctx, -2);
	duk_call_method(ctx, 0 /*nargs*/);
	duk_pop(ctx);  /* pop call result */
	duk_pop(ctx);  /* pop instance */
}
```
