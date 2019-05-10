.PHONY: all
all:
	@echo "No default target, see Makefile for targets."

.PHONY: clean
clean:
	rm -rf build

.PHONY: cleanall
cleanall: clean
	rm -rf deps

build:
	mkdir $@

deps:
	mkdir $@

deps/duktape: deps
	git clone https://github.com/svaarala/duktape.git deps/duktape

.PHONY: docker-images
docker-images:
	docker build -t duktape-wiki-build docker/duktape-wiki-build-ubuntu-18.04

# Build wiki.duktape.org using a docker image.  Input and output data are
# passed via stdin/stdout as ZIP files to avoid Docker uid issues.  ZIP is
# also lenient in that it allows leading garbage.
.PHONY: docker-build
docker-build: deps/duktape build deps
	rm -rf build/tmp-zip && mkdir build/tmp-zip
	rm -rf build/output && mkdir build/output
	rm -f build/docker-input.zip build/docker-output.zip
	cd deps/duktape && git pull && git archive --format=zip --output=../../build/duktape-snapshot.zip HEAD
	git archive --format=zip --output=build/duktape-wiki-snapshot.zip HEAD
	cd build/tmp-zip && mkdir duktape-wiki && mkdir duktape-wiki/duktape
	cd build/tmp-zip/duktape-wiki && unzip -q ../../duktape-wiki-snapshot.zip
	cd build/tmp-zip/duktape-wiki/duktape && unzip -q ../../../duktape-snapshot.zip
	rm -rf build/tmp-zip/duktape-wiki/duktape/references/  # remove some paths with non-ASCII characters
	cd build/tmp-zip && zip -r -q ../docker-input.zip *
	docker run -i duktape-wiki-build < build/docker-input.zip > build/docker-output.zip
	cd build/output && unzip -q ../docker-output.zip ; true  # avoid failure due to leading garbage
	ls -lh build/output
