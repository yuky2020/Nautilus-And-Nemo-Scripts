#!/bin/bash
# leogutierrezramirez@gmail.com

while read url
do
	echo -e "$url" | grep -i "^http:.*" &> /dev/null && {
		wget "$url"
	}
done < "$1"
