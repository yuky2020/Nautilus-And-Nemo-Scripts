#!/bin/bash
mkdir Foto-rid
largh=$(zenity --text "Larghezza?" --entry) 
cp *.* Foto-rid
cd Foto-rid

mogrify -resize $largh *.*
