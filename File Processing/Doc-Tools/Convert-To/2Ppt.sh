#!/bin/sh
#Nautilus Script to convert selected document file(s) to PPT
#v.1.0
OLDIFS=$IFS
IFS="
"
for filename in $@; do
unoconv --doctype=presentation --format=ppt "$filename"
done
IFS=$OLDIFS