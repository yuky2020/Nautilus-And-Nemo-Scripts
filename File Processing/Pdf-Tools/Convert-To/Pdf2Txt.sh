#!/bin/bash
#Nautilus Script to convert a PDF document to TXT, quietly
#V.1.0
#Requires "poppler-utils" package which includes "pdftotext"
#
pdftotext -q "$1" "${1%\.pdf}.txt"
