#!/bin/sh
#made by tester8, based on Orlando De Giorgi's scripts

for file in "$@"
do
new=$(basename "$file" | sed -re 's/.(jpe?g|bmp|tif|gif)$/.png/i')
if [ "$file" != "$new" ]
then
	convert  "$file" "$new"
fi
done
