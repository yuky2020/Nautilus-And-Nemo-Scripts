#!/bin/sh
#made by tester8, based on Orlando De Giorgi's scripts
for file in "$@"
do
convert -rotate -90 "$file" "$file"
done


