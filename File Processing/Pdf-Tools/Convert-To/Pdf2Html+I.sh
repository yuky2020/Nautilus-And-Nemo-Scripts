#!/bin/bash
#Nautilus Script to convert a PDF document to HTML file with images (don't use frames and generate a single file, quietly, converting any pdf links to html links, with complex formatting)
#V.1.0
#Requires "poppler-utils" package which includes "pdftohtml"
#
pdftohtml -noframes -q -p -c "$1" "${1%\.pdf}-img.html"