#!/bin/bash
#
#

width=$(zenity --title 'Export SVG as PNG' --text 'Width de la imagen: ' --entry)
height=$(zenity --title 'Export SVG as PNG' --text 'Height de la imagen: ' --entry)
if [ $# -eq 0 ]; then
files=$(zenity --text 'Directorio: ' --file-selection --multiple)
files=${files//|/ }
else
files=$@
fi

for f in $files ; do
	if [ "$(file -i "$f")"="image/svg+xml" ]; then
		inkscape "$f" -e "${f/.svg/.png}" -w "$width" -h "$height"
	fi
done


