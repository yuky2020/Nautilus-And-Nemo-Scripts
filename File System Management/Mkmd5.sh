#!/bin/bash
#########################################################
#							#
# This are NScripts v3.6				#
#							#
# Licensed under the GNU GENERAL PUBLIC LICENSE 3	#
#							#
# Copyright 2007 - 2009 Christopher Bratusek		#
#							#
#########################################################

for file in $NAUTILUS_SCRIPT_SELECTED_URIS ; do

	if [[ -d "$file" ]]; then
		exit
	fi

	filename=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g')
	shortfile=$(echo $file | sed -e 's/.*\///g' -e 's/\%20/\ /g')
	md5sum "$filename" > "$shortfile.md5"

	if [[ ! -a $shortfile.md5 ]]; then
		echo -e "========================================================" >> ~/.gnome2/mkmd5_result
		echo "\nMD5-Sum for $shortfile failed to create!\n" >> ~/.gnome2/mkmd5_result;
	fi

done

zenity --text-info --title "Result" --width=640 --height=480 --filename=$HOME/.gnome2/mkmd5_result
rm $HOME/.gnome2/mkmd5_result
