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

file_name=$( echo $NAUTILUS_SCRIPT_SELECTED_URIS | sed -e 's/file:\/\///g' -e 's/\%20/\ /g')

gconftool-2 --set --type string  /desktop/gnome/background/picture_filename "$file_name"

type=$(zenity --list --radiolist --width="270" --height="265"
	--text "Displaying Type" --title "Displaying Type"
	--column "Pick" --column "Option"
	TRUE "none"
	FALSE "wallpaper"
	FALSE "centered"
	FALSE "scaled"
	FALSE "stretched"
	FALSE "zoom"
        FALSE "spanned"	)

gconftool-2 --set --type string /desktop/gnome/background/picture_options "$type"
