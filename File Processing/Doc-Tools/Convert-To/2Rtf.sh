#!/bin/sh
#Nautilus Script to convert selected document file(s) to RTF
#v.1.0
OLDIFS=$IFS
IFS="
"
for filename in $@; do
unoconv --doctype=document --format=rtf "$filename"
done
IFS=$OLDIFS