MARKUP=markdown  # commonmark
ENTRYWD=`pwd`

DUKTAPE_WIKI_REPO=$ENTRYWD
DUKTAPE_REPO=$ENTRYWD/duktape

set -e  # exit on error

cd /tmp
rm -rf wiki-build-tmp
rm -rf wiki-output-tmp
mkdir wiki-build-tmp
mkdir wiki-output-tmp

# Genconfig generated files
cd $DUKTAPE_REPO
python tools/genconfig.py \
	--metadata config \
	--output /tmp/wiki-build-tmp/ConfigOptions.rst \
	config-documentation
#python tools/genconfig.py \
#	--metadata config \
#	--output /tmp/wiki-build-tmp/FeatureOptions.rst \
#	feature-documentation

# Internal doc/ files are .rst and supported by pandoc, copy them over
cd $DUKTAPE_REPO
cp doc/*.rst /tmp/wiki-build-tmp/

# Copy Wiki files over.
cd $DUKTAPE_WIKI_REPO
cp *.md /tmp/wiki-build-tmp/

# Convert wiki links to pandoc compatible ones.
cd /tmp/wiki-build-tmp/
python $DUKTAPE_WIKI_REPO/convert_links.py *.md

cd /tmp/wiki-build-tmp/
for fn in /tmp/wiki-build-tmp/*.md; do
    # --number-sections ?
    # --toc ?
    # --title ?
    echo $fn
    echo $fn >&2
    pandoc -r $MARKUP --highlight-style haddock -w html5 \
        --css style-top.css \
        --css github-pandoc-adapted.css \
        --include-in-header $DUKTAPE_WIKI_REPO/in_header.html \
        --include-before-body $DUKTAPE_WIKI_REPO/before_body.html \
        --include-after-body $DUKTAPE_WIKI_REPO/after_body.html \
        -o "${fn%%.md}.html" "$fn"
done
for fn in /tmp/wiki-build-tmp/*.rst; do
    # --number-sections ?
    # --toc ?
    # --title ?
    echo $fn
    echo $fn >&2
    pandoc -r rst --highlight-style haddock -w html5 \
        --css style-top.css \
        --css github-pandoc-adapted.css \
        --include-in-header $DUKTAPE_WIKI_REPO/in_header.html \
        --include-before-body $DUKTAPE_WIKI_REPO/before_body.html \
        --include-after-body $DUKTAPE_WIKI_REPO/after_body.html \
        -o "${fn%%.rst}.html" "$fn"
done

cp /tmp/wiki-build-tmp/*.html /tmp/wiki-output-tmp/
cp $DUKTAPE_REPO/website/style-top.css /tmp/wiki-output-tmp/
cp $DUKTAPE_WIKI_REPO/github-pandoc-adapted.css /tmp/wiki-output-tmp/

ls -l /tmp/wiki-output-tmp
