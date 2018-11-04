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

destination=$(zenity --file-selection --directory --title "Where to link files?")

for file in $NAUTILUS_SCRIPT_SELECTED_URIS; do

	file_name=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g')

	if [[ -w "$destination" ]]; then
		ln -s "$file_name" "$destination"
		if (( $? != 0 )); then
			zenity --info --text "Something went wrong" --title "Failure"
		fi
	else	zenity --info --title "Failure" --text "$destination does either not\nexist or is not writable"
	fi
done
