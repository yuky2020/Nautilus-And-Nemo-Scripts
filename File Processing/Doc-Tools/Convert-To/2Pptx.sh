#!/bin/sh
#Nautilus Script to convert selected document file(s) to PPTX
#v.1.0
OLDIFS=$IFS
IFS="
"
for filename in $@; do
unoconv --doctype=presentation --format=pptx "$filename"
done
IFS=$OLDIFS