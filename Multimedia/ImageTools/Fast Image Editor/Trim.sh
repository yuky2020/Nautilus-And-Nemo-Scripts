#!/bin/bash
#by tester8 originally by Orlando De Giorgi
for file in "$@"
do
convert "$file" -trim "$file"
done


