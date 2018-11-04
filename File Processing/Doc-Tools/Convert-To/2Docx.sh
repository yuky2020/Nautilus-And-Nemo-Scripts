#!/bin/sh
#Nautilus Script to convert selected document file(s) to DOCX
#v.1.0
OLDIFS=$IFS
IFS="
"
for filename in $@; do
unoconv --doctype=document --format=docx "$filename"
done
IFS=$OLDIFS