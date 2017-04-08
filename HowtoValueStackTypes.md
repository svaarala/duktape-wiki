# How to work with value stack types

## Reading values

The table below summarizes API calls to read a value of a certain type
(e.g. a string).

<table>
<tr>
<th>Value stack entry type</th>
<th>duk_get_xxx()</th>
<th>duk_require_xxx()</th>
<th>duk_opt_xxx()</th>
<th>duk_to_xxx()</th>
</tr>

<tr>
<td>none (index out of bounds)</td>
<td>default (automatic)</td>
<td>TypeError</td>
<td>default (explicit)</td>
<td>TypeError</td>
</tr>

<tr>
<td>undefined</td>
<td>default (automatic)</td>
<td>TypeError</td>
<td>default (explicit)</td>
<td>coercion</td>
</tr>

<tr>
<td>null</td>
<td>default (automatic)</td>
<td>TypeError</td>
<td>TypeError</td>
<td>coercion</td>
</tr>

<tr>
<td>Matching type</td>
<td>as is</td>
<td>as is</td>
<td>as is</td>
<td>as is</td>
</tr>

<tr>
<td>Non-matching type</td>
<td>default (automatic)</td>
<td>TypeError</td>
<td>TypeError</td>
<td>coercion</td>
</tr>

</table>

Concrete example for string values:

<table>
<tr>
<th>Value stack entry type</th>
<th>duk_get_string()</th>
<th>duk_require_string()</th>
<th>duk_opt_string()</th>
<th>duk_to_string()</th>
</tr>

<tr>
<td>none (index out of bounds)</td>
<td>NULL</td>
<td>TypeError</td>
<td>default (explicit)</td>
<td>TypeError</td>
</tr>

<tr>
<td>undefined</td>
<td>NULL</td>
<td>TypeError</td>
<td>default (explicit)</td>
<td>"undefined"</td>
</tr>

<tr>
<td>null</td>
<td>NULL</td>
<td>TypeError</td>
<td>TypeError</td>
<td>"null"</td>
</tr>

<tr>
<td>boolean</td>
<td>NULL</td>
<td>TypeError</td>
<td>TypeError</td>
<td>"true"</td>
</tr>

<tr>
<td>number</td>
<td>NULL</td>
<td>TypeError</td>
<td>TypeError</td>
<td>"123.4"</td>
</tr>

<tr>
<td>string</td>
<td>"hello"</td>
<td>"hello"</td>
<td>"hello"</td>
<td>"hello"</td>
</tr>

<tr>
<td>object</td>
<td>NULL</td>
<td>TypeError</td>
<td>TypeError</td>
<td>"[object Object]"</td>
</tr>

<tr>
<td>buffer</td>
<td>NULL</td>
<td>TypeError</td>
<td>TypeError</td>
<td>"[object ArrayBuffer]"</td>
</tr>

<tr>
<td>pointer</td>
<td>NULL</td>
<td>TypeError</td>
<td>TypeError</td>
<td>"0xdeadbeef"</td>
</tr>

<tr>
<td>lightfunc</td>
<td>NULL</td>
<td>TypeError</td>
<td>TypeError</td>
<td>"function light_08062727_0a11() { [lightfunc code] }"</td>
</tr>

</table>

Notes:

* Integer getters do a double-to-integer coercion for the API return value.
  This coercion does not change the number on the value stack which remains
  a double.
