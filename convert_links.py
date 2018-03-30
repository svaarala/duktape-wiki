#!/usr/bin/env python2
#
#  Convert wiki links to be compatible with a pandoc-based build process
#  where inter-wiki links should have the form:
#
#      [Foo bar](FooBar.html)
#
#  Link styles accepted are Gollum-supported links:
#
#      [[Foo bar|FooBar]]
#
#  and plain sibling links that work in Github:
#
#      [Foo bar](FooBar.md)
#
#  Also ensure naked http(s) links have angle brackets surrounding them.
#  This seems to be required by pandoc, but not by Github.  This step
#  was done once manually, with manual fixups.
#

import os
import sys
import re

re_wikilink1 = re.compile(r'\[\[(.*?)\|(.*?)\]\]', re.MULTILINE)
re_wikilink2 = re.compile(r'\[(.*?)\]\((.*?)\)', re.MULTILINE)
re_httplink = re.compile(r'((?:<|>|\(|\")?http[^\s>)"]*(?:<|>|\)|\")?)', re.MULTILINE)

def convert(fn):
    with open(fn, 'rb') as f:
        data = f.read()

    def _repl1(m):
        title = m.group(1)
        target = m.group(2)
        return '[' + title + ']' + '(' + target + '.md' + ')'

    def _repl2(m):
        title = m.group(1)
        target = m.group(2)
        if target.startswith('http'):  # Leave http(s) links alone
            return '[' + title + ']' + '(' + target + ')'
        root, ext = os.path.splitext(target)
        ext = 'html'
        return '[' + title + ']' + '(' + root + '.' + ext + ')'

    # This is not perfect; it will convert links inside e.g. preformatted
    # blocks which is incorrect.  This was only used once manually.
    def _repl3(m):
        link = m.group(1)
        tail = ''
        if link[-1] in '.:;':  # http://foo/bar/quux.html. etc
            tail = link[-1]
            link = link[:-1]
        if not (link[0] in '<>("'):
            link = '<' + link
        if not (link[-1] in '<>)"'):
            link = link + '>'
        return link + tail

    # Take care of Gollum-supported links first, converting them to .md links.
    # (These should no longer occur in the repo, so a no-op.)
    data = re.sub(re_wikilink1, _repl1, data)

    # Then change (or insert) link suffix .html.
    data = re.sub(re_wikilink2, _repl2, data)

    # Fix naked http(s) links.  This was only run once manually because
    # the replacements are not 100% correct and need manual inspection.
    #data = re.sub(re_httplink, _repl3, data)

    # Done, replace source file in-place.
    with open(fn, 'wb') as f:
        f.write(data)

def main():
    for fn in sys.argv[1:]:
        convert(fn)

if __name__ == '__main__':
    main()
