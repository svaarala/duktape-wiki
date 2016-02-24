# Compatibility with TypeScript

## Running TypeScript compiled code with Duktape

No known issues.

## Running the TypeScript compiler with Duktape

It's possible to run the Microsoft TypeScript compiler with Duktape.
Since Duktape 1.5.0 no regexp fixes are necessary; prior to Duktape
1.5.0 unescaped curly braces in regexps needed to be fixed.

See:

- https://github.com/svaarala/duktape/issues/523#issuecomment-172391196

- https://github.com/AtomicGameEngine/AtomicGameEngine/pull/614
