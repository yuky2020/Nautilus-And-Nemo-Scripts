#!/bin/bash
#Nautilus Script to convert a PDF document to HTML file (don't use frames and generate a single file, quietly, converting any pdf links to html links, with complex formatting, excluding any images)
#V.1.0
#Requires "poppler-utils" package which includes "pdftohtml"
#
pdftohtml -noframes -q -p -c -i "$1" "${1%\.pdf}.html"