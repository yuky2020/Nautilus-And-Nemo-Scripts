#!/bin/bash
#
#Script: Extractor Mp3
#Autor: Jose Daniel Canchila
#WebSite: http://nexxuz.com
#Version: 0.2
#Fecha Lanzamiento: 17 Mayo 2010
while [ $# -gt 0 ]; do
	video=$1
	ext=${video##*.}
	if [ $ext = "flv" ] || [ $ext = "avi" ] || [ $ext = "mpg" ] || [ $ext = "mpeg" ] || [ $ext = "mp4" ] || [ $ext = "mkv" ] || [ $ext = "wmv" ]
	then
		mp3_file=`echo "$video" | sed 's/\.\w*$/.mp3/'`
		/usr/bin/ffmpeg -i "$video"  -b 128 "$mp3_file"  
		notify-send "Procesado | Nexxuz.com" "$video" -i "/usr/share/icons/gnome/32x32/categories/applications-multimedia.png"

	else
		notify-send "Error | Nexxuz.com" "(Formato no compatible) $video" -i "/usr/share/icons/gnome/32x32/categories/applications-multimedia.png"
	exit
	fi
	shift

done
#notify-send "Finalizado" "La extraccion Mp3 ha Finalizado" -i "/usr/share/icons/gnome/32x32/categories/applications-multimedia.png"








