#!/bin/sh
#Nautilus Script to convert selected document file(s) to ODT
#v.1.0
OLDIFS=$IFS
IFS="
"
for filename in $@; do
unoconv --doctype=document --format=odt "$filename"
done
IFS=$OLDIFS