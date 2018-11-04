#!/bin/sh
#Nautilus Script to convert selected document file(s) to HTML
#v.1.0
OLDIFS=$IFS
IFS="
"
for filename in $@; do
unoconv --doctype=document --format=html "$filename"
done
IFS=$OLDIFS