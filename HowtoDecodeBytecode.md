# How to decode Duktape bytecode

The term "bytecode" can refer to either the function dump/load format, or more
narrowly just the bytecode opcode format.

## Decoding bytecode opcodes

Duktape opcode format does not have versioning guarantees and is simply an
internal format shared by the run-time compiler and executor components.  The
opcode format has changed several times in minor releases to e.g. extend
bytecode limits and improve performance.  There's no specification for the
opcode format other than the source code at present; such a specification
would easily fall out-of-date.

With that caveat, here are some resources to decode the bytecode opcode format
if you want to do so e.g. in a debug client:

* Bytecode header defines:
  https://github.com/svaarala/duktape/blob/master/src/duk_js_bytecode.h

* Bytecode metadata used by the Node.js debugger web UI to decode instructions
  into a printable form:
  https://github.com/svaarala/duktape/blob/master/debugger/duk_opcodes.yaml

* Node.js debugger web UI decoder/formatting function:
  https://github.com/svaarala/duktape/blob/v1.4.0/debugger/duk_debug.js#L1044-L1133
  (link is for 1.4.0; check master for the most recent version)

## Decoding dump/load bytecode format

The dump/load format includes both the actual bytecode (opcode list) of a
function, but also constants, inner functions, and function metadata.  Like
the opcode format, the dump/load format is version specific and documented
only in source code.  See:

* Documentation for dump/load:
  https://github.com/svaarala/duktape/blob/master/doc/bytecode.rst

* Utility to decode and print a dump file:
  https://github.com/svaarala/duktape/blob/v1.4.0/util/dump_bytecode.py
  (link is for 1.4.0; check master for the most recent version)
