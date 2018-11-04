#!/bin/sh
#Nautilus Script to convert selected LibreOffice-compatible file(s) to PDF
#v.1.0
OLDIFS=$IFS
IFS="
"
for filename in $@; do
unoconv --doctype=document --format=pdf "$filename"
done
IFS=$OLDIFS