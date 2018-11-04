#!/bin/sh
#Nautilus Script to convert selected document file(s) to XLS
#v.1.0
OLDIFS=$IFS
IFS="
"
for filename in $@; do
unoconv --doctype=spreadsheet --format=xls "$filename"
done
IFS=$OLDIFS