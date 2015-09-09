# Configuring Duktape for build

## Duktape 1.2

In Duktape 1.2 Duktape features are configured through feature options:

* If defaults are acceptable, compile Duktape as is.  Otherwise use
  `DUK_OPT_xxx` feature options when compiling both Duktape and the
  application.  For available feature options, see:
  https://github.com/svaarala/duktape/blob/master/doc/feature-options.rst

## Duktape 1.3

In Duktape 1.3 there are three supported ways of configuring Duktape features
for build:

* Use the `duk_config.h` in the distributable (`src/duk_config.h` or
  `src-separate/duk_config.h`).  If default features are not desirable,
  provide `DUK_OPT_xxx` feature options when compiling both Duktape and
  the application.  This matches Duktape 1.2, but there's an external
  `duk_config.h` header.

* Generate a new autodetect `duk_config.h` using `genconfig` with config
  option overrides given either on the command line or in YAML/header
  files.  For example, to enable fastint support and to disable
  bufferobjects:

      $ sudo apt-get install python-yaml

      $ python config/genconfig.py \
              --metadata config/genconfig_metadata.tar.gz \
              --output duk_config.h \
              -DDUK_USE_FASTINT \
              -UDUK_USE_BUFFEROBJECT_SUPPORT \
              autodetect-header

      # Then use duk_config.h in build

  There are several alternatives to defining option overrides, see:
  https://github.com/svaarala/duktape/blob/master/doc/duk-config.rst#genconfig-option-overrides

  NOTE: config options (`DUK_USE_xxx`) used to be Duktape internal, and are
  being cleaned up after Duktape 1.3 release.  Some config options may change
  in Duktape 1.4.

* Edit `duk_config.h` manually.  This is a bit messy but allows everything
  to be modified, e.g. typedefs and `#include` directives.

## Duktape 1.4 (planned)

In Duktape 1.4 the `DUK_OPT_xxx` options will be removed and configuration
is done only through `genconfig` and `DUK_USE_xxx` config options.  This
removes one level of indirection and avoids compiler command line defines
entirely, but requires build scripts to run `genconfig` if the default
options are not desirable.
