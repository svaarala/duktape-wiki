#!/bin/sh
#
#  Rebuild wiki.  This is executed on wiki.duktape.org server side (though
#  this script is not used directly, but is manually copied and edited).
#  Expects gollum-site to be installed and working.
#

STATIC_SITE=/srv/duktape-wiki

set -e  # exit on error

cd /tmp
rm -rf wiki-rebuild-tmp
rm -rf wiki-output-tmp
mkdir wiki-rebuild-tmp
mkdir wiki-output-tmp

# Fresh clone of duktape-wiki repository (the wiki is quite small)
cd /tmp/wiki-rebuild-tmp
git clone --depth 1 https://github.com/svaarala/duktape-wiki.git

# Fresh clone of duktape repository
cd /tmp/wiki-rebuild-tmp
git clone --depth 1 https://github.com/svaarala/duktape.git

# Genconfig generated files
cd /tmp/wiki-rebuild-tmp/duktape
python tools/genconfig.py \
	--metadata config \
	--output /tmp/wiki-rebuild-tmp/duktape-wiki/ConfigOptions.rst \
	config-documentation
#python tools/genconfig.py \
#	--metadata config \
#	--output /tmp/wiki-rebuild-tmp/duktape-wiki/FeatureOptions.rst \
#	feature-documentation

# Internal doc/ files are .rst and supported by Gollum, copy them over
cd /tmp/wiki-rebuild-tmp/duktape
cp doc/*.rst /tmp/wiki-rebuild-tmp/duktape-wiki/

# Import templates; for now they're not committed
cd /tmp/wiki-rebuild-tmp/duktape-wiki
gollum-site import

# Generate site to /tmp, remember --working because templates are not committed
gollum-site generate --working --output_path /tmp/wiki-output-tmp

# Copy final site on success to statically served site
if [ ! -d $STATIC_SITE ]; then
	echo "Invalid static site: $STATIC_SITE"
fi
rm -rf $STATIC_SITE/*
cp -r /tmp/wiki-output-tmp/* $STATIC_SITE/
