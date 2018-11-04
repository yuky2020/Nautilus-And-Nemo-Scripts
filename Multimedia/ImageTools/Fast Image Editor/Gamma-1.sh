#!/bin/sh
#made by tester8, based on Orlando De Giorgi's scripts
for file in "$@"
do
convert -gamma 1.4 "$file" "$file"
done

