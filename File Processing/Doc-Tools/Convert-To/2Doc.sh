#!/bin/sh
#Nautilus Script to convert selected document file(s) to DOC
#v.1.0
OLDIFS=$IFS
IFS="
"
for filename in $@; do
unoconv --doctype=document --format=doc "$filename"
done
IFS=$OLDIFS