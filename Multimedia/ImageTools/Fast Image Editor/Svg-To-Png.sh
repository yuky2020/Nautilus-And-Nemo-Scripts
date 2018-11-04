#!/bin/sh
#made by tester8, based on Orlando De Giorgi's scripts

for file in "$@"
do
new=$(basename "$file" | sed s/.svg$/.png/i)
if [ "$file" != "$new" ]
then
	inkscape --export-png="$new" "$file"
fi
done
