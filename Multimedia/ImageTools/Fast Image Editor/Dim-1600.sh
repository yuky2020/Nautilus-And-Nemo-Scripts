#!/bin/sh
#made by tester8, based on Orlando De Giorgi's scripts
for file in "$@"
do
convert "$file" -scale 1600x1600 "$file"
done


