#!/bin/sh
#made by tester8, based on Orlando De Giorgi's scripts
for file in "$@"
do
convert "$file" -scale 1024x1024 "$file"
done

