#!/bin/sh
#Nautilus Script to convert selected document file(s) to XLSX
#v.1.0
OLDIFS=$IFS
IFS="
"
for filename in $@; do
unoconv --doctype=spreadsheet --format=xlsx "$filename"
done
IFS=$OLDIFS