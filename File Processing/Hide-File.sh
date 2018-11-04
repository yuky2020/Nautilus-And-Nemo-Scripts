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

for file in $NAUTILUS_SCRIPT_SELECTED_URIS; do
	file_name=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g' -e 's/.*\///g')
	file_folder=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g' -e "s/$file_name//g")
	mv -v "$file_folder"/"$file_name" "$file_folder"/."$file_name"
done
