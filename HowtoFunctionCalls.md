# How to make function calls

[API calls for invoking functions](http://duktape.org/api.html#taglist-call)
are mostly quite straightforward: they are given a target function and a list
of arguments.  However, the following Ecmascript specific details complicate
matters a bit:

- Ecmascript function/method calls involve a "this" binding which varies
  between API calls and Ecmascript call idioms.  If not given, the "this"
  binding defaults to `undefined` (but coerces to the global object unless
  the target function is strict; Duktape/C functions are always strict).

- Constructor calls have special behavior for their "this" binding and their
  return value.  The "this" binding is initialized to a "default instance"
  and the return value has special handling, allowing the default instance to
  be replaced.  See
  [[Internal and external prototype|InternalExternalPrototype]].

The C API provides protected and unprotected variants.  Their difference is
that protected calls catch errors; an error is indicated by the C API call
return value, and the error object is placed on the value stack.  One can
then e.g. read the traceback of the error.

The table below summarizes API calls, using unprotected calls as examples:

<table>
<tr>
<th>Ecmascript idiom</th>
<th>Duktape C API idiom</th>
<th>This binding</th>
<th>Value stack</th>
</tr>

<tr>
<td>var result = func('foo', 'bar');</td>
<td>duk_get_global_string(ctx, "func");<br />
duk_push_string(ctx, "foo");<br />
duk_push_string(ctx, "bar")<br />
<a href="http://duktape.org/api.html#duk_call">duk_call</a>(ctx, 2 /*nargs*/);<br />
/* result on stack top */</td>
<td>undefined</td>
<td>[ func "foo" "bar" ] -&gt;</br>
[ result ]</td>
</tr>

<tr>
<td>var result = func.call('myThis', 'foo', 'bar');</td>
<td>duk_get_global_string(ctx, "func");<br />
duk_push_string(ctx, "myThis");</br />
duk_push_string(ctx, "foo");<br />
duk_push_string(ctx, "bar")<br />
<a href="http://duktape.org/api.html#duk_call_method">duk_call_method</a>(ctx, 2 /*nargs*/);<br />
/* result on stack top */</td>
<td>"myThis"</td>
<td>[ func "myThis" "foo" "bar" ] -&gt;</br>
[ result ]</td>
</tr>

<tr>
<td>var result = obj.func('foo', 'bar');</td>
<td>duk_push_string(ctx, "func");<br />
duk_push_string(ctx, "foo");<br />
duk_push_string(ctx, "bar")<br />
<a href="http://duktape.org/api.html#duk_call_prop">duk_call_prop</a>(ctx, obj_idx, 2 /*nargs*);<br />
/* result on stack top */</td>
<td>obj</td>
<td>[ "func" "foo" "bar" ] -&gt;</br>
[ result ]</td>
</tr>

</table>
