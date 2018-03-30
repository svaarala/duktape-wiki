STATIC_SITE=/srv/duktape-wiki
MARKUP=markdown  # commonmark

set -e  # exit on error

if [ ! -d $STATIC_SITE ]; then
    echo "Invalid static site: $STATIC_SITE"
fi

cd /tmp
rm -rf wiki-rebuild-tmp
rm -rf wiki-output-tmp
mkdir wiki-rebuild-tmp
mkdir wiki-output-tmp

# Fresh clone of duktape-wiki repository (the wiki is quite small)
cd /tmp/wiki-rebuild-tmp
git clone --depth 1 https://github.com/svaarala/duktape-wiki.git
#cp -r /home/duktape/duktape-wiki /tmp/wiki-rebuild-tmp/

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

# Internal doc/ files are .rst and supported by pandoc, copy them over
cd /tmp/wiki-rebuild-tmp/duktape
cp doc/*.rst /tmp/wiki-rebuild-tmp/duktape-wiki/

# Convert wiki links to pandoc compatible ones.
cd /tmp/wiki-rebuild-tmp/duktape-wiki
python convert_links.py *.md

cd /tmp/wiki-rebuild-tmp/duktape-wiki
for fn in /tmp/wiki-rebuild-tmp/duktape-wiki/*.md; do
    # --number-sections ?
    # --toc ?
    # --title ?
    echo $fn
    pandoc -r $MARKUP --highlight-style haddock -w html5 \
        --css style-top.css \
        --css github-pandoc-adapted.css \
        --include-in-header in_header.html \
        --include-before-body before_body.html \
        --include-after-body after_body.html \
        -o "${fn%%.md}.html" "$fn"
done
for fn in /tmp/wiki-rebuild-tmp/duktape-wiki/*.rst; do
    # --number-sections ?
    # --toc ?
    # --title ?
    echo $fn
    pandoc -r rst --highlight-style haddock -w html5 \
        --css style-top.css \
        --css github-pandoc-adapted.css \
        --include-in-header in_header.html \
        --include-before-body before_body.html \
        --include-after-body after_body.html \
        -o "${fn%%.rst}.html" "$fn"
done

cp /tmp/wiki-rebuild-tmp/duktape-wiki/*.html /tmp/wiki-output-tmp/
cp /tmp/wiki-rebuild-tmp/duktape/website/style-top.css /tmp/wiki-output-tmp/
cp /tmp/wiki-rebuild-tmp/duktape-wiki/github-pandoc-adapted.css /tmp/wiki-output-tmp/

# Copy final site on success to statically served site
if [ ! -d $STATIC_SITE ]; then
    echo "Invalid static site: $STATIC_SITE"
fi
rm -rf $STATIC_SITE/*
cp -r /tmp/wiki-output-tmp/* $STATIC_SITE/
