#!/bin/sh
#Nautilus Script to convert selected document file(s) to ODS
#v.1.0
OLDIFS=$IFS
IFS="
"
for filename in $@; do
unoconv --doctype=spreadsheet --format=ods "$filename"
done
IFS=$OLDIFS