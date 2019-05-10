#!/usr/bin/env python2

import os
import sys
import subprocess
import zipfile
import StringIO

def main():
    # Unpack ZIP from stdin, contains input repo snapshot etc.
    zf = zipfile.ZipFile(StringIO.StringIO(sys.stdin.read()))
    zf.extractall()

    os.chdir('duktape-wiki')

    # Actual dist build.
    os.system('bash build_pandoc.sh')
    os.system('cd /tmp/wiki-output-tmp && zip /tmp/duktape-wiki-dist-html.zip *')

    # Text conversion from HTML files, allows diffing dists easily.
    os.system('cd /tmp && mkdir wiki-output-txt && cd wiki-output-tmp && for i in *.html; do html2text -o ../wiki-output-txt/${i%%.html}.txt $i; done')
    os.system('cd /tmp/wiki-output-txt && zip /tmp/duktape-wiki-dist-txt.zip *')

    # Create output ZIP.  Output ZIP file must appear last in stdout with no
    # trailing garbage.  Leading garbage is automatically ignored by ZIP.
    os.system('cd /tmp && zip out.zip duktape-wiki-dist-html.zip duktape-wiki-dist-txt.zip')
    os.system('cat /tmp/out.zip')

if __name__ == '__main__':
    main()
