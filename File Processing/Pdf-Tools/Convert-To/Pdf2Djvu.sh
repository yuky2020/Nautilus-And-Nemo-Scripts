#!/bin/bash
#Nautilus Script to convert a PDF document to DJVU, quietly
#V.1.0
#Requires "pdf2djvu" package
#
pdf2djvu -q "$1" -o "${1%\.pdf}.djvu"