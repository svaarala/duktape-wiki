# How to enable debug prints

## Duktape 1.x

- Enable `DUK_OPT_DEBUG` / `DUK_USE_DEBUG`
- Enable `DUK_OPT_DPRINT` / `DUK_USE_DPRINT` for minimal logs
- Enable also `DUK_OPT_DDPRINT` / `DUK_USE_DDPRINT` for verbose logs
- Enable also `DUK_OPT_DDDPRINT` / `DUK_USE_DDDPRINT` for very verbose logs

Logs will be written to `stderr`.

## Duktape 2.x

- Enable `DUK_USE_DEBUG`
- Define `DUK_USE_DEBUG_LEVEL=<n>` where `n` is 0 for minimal logs,
  1 for verbose logs, and 2 for very verbose logs
- Define `DUK_USE_DEBUG_WRITE(level,file,line,func,msg)` to write out log
  entries; this allows you to fully control where debug logs should go

Example of `DUK_USE_DEBUG_WRITE` in manually edited `duk_config.h`:

```c
#define DUK_USE_DEBUG_WRITE(level,file,line,func,msg) do { \
		fprintf(stderr, "D%ld %s:%d (%s): %s\n", \
		        (long) (level), (file), (long) (line), (func), (msg));
	} while (0)
```

Same function as an argument to tools/configure.py:

```
'-DDUK_USE_DEBUG_WRITE(level,file,line,func,msg)=do {fprintf(stderr, "D%ld %s:%ld (%s): %s\n", (long) (level), (file), (long) (line), (func), (msg));} while(0)'
```
