# Docker image to build duktape-wiki as HTML and TXT (for diffing).
FROM ubuntu:18.04

# Packages.  This set should cover everything necessary to build duktape-wiki.
RUN apt-get update && \
	apt-get install -qy \
	vim git \
	build-essential python python-yaml python-bs4 tidy \
	wget curl source-highlight rst2pdf pandoc html2text \
	zip unzip

WORKDIR /build

COPY run.py .
RUN chmod 755 run.py

ENTRYPOINT ["/build/run.py"]
