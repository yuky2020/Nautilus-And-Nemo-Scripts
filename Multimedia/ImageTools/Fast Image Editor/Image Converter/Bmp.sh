#!/bin/sh
#made by tester8, based on Orlando De Giorgi's scripts

for file in "$@"
do
new=$(basename "$file" | sed -re 's/.(jpe?g|png|tif|gif)$/.bmp/i')
if [ "$file" != "$new" ]
then
	convert  "$file" "$new"
fi
done
