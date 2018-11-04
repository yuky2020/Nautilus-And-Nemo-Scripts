#!/bin/sh
#Nautilus Script to convert selected document file(s) to TXT
#v.1.0
OLDIFS=$IFS
IFS="
"
for filename in $@; do
unoconv --doctype=document --format=txt "$filename"
done
IFS=$OLDIFS