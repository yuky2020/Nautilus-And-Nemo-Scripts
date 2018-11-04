#!/bin/sh
#Nautilus Script to convert selected document file(s) to ODP
#v.1.0
OLDIFS=$IFS
IFS="
"
for filename in $@; do
unoconv --doctype=presentation --format=odp "$filename"
done
IFS=$OLDIFS