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

if [[ $(which gksu) == "" ]]; then
	destination=$(zenity --list --radiolist --width="270" --height="350"
		--text "Where to install Theme?" --title "Destination ..."
		--column "Pick" --column "Destination"
		TRUE "$HOME/.themes/"
		FALSE "$HOME/.sawfish/themes/"
		FALSE "$HOME/.icons/"
		FALSE "$HOME/.mplayer/skins/"
		FALSE "$HOME/.cairo-clock/theme/"
		FALSE "$HOME/.emerald/themes/"
		FALSE "$HOME/.fluxbox/styles/"
		FALSE "$HOME/.icewm/themes/")
else	destination=$(zenity --list --radiolist --width="270" --height="400"
		--text "Where to install Theme?" --title "Destination ..."
		--column "Pick" --column "Destination"
		TRUE "$HOME/.themes/"
		FALSE "$HOME/.sawfish/themes/"
		FALSE "/usr/share/sawfish/themes/"
		FALSE "/usr/share/themes/"
		FALSE "$HOME/.icons/"
		FALSE "/usr/share/icons/"
		FALSE "$HOME/.mplayer/skins/"
		FALSE "/usr/share/mplayer/skins/"
		FALSE "/usr/share/gdm/"
		FALSE "$HOME/.cairo-clock/theme/"
		FALSE "/usr/share/cairo-clock/themes/"
		FALSE "/boot/grub/"
		FALSE "/usr/share/emerald/themes/"
		FALSE "$HOME/.fluxbox/styles/"
		FALSE "/usr/share/fluxbox/styles/"
		FALSE "$HOME/.icewm/themes/"
		FALSE "/usr/share/icewem/themes/")
fi

if [[ ! -e $destination ]]; then
	mkdir -p $destination || gksu -u root "mkdir -p $destination"
fi

for file in $NAUTILUS_SCRIPT_SELECTED_URIS; do

	file_name=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g')
	shortfile=$(echo $file | sed -e 's/\%20/\\ /g' -e 's/.*\///g' -e 's/.tar.*//g')

	if [[ "$file_name" == *tar* ]]; then \
		action=unpack;
	else	action=copy;
	fi

	if [[ $destination != /usr* ]]; then \
		if [[ $action == unpack ]]
			tar xf "$file_name" -C $destination
		else	cp -r "$file_name" $destination
		fi
	else 	if [[ $action == unpack ]]; then
			gksu -u root "tar xf '$file_name' -C $destination"
		else 	gksu -u root "cp -r '$file_name' $destination"
		fi
	fi

	if (( $? == 0 )); then
		zenity --info --title "Success" --text "$shortfile installed";
	else	zenity --info --title "Failure" --text "$shortfile failed to install";
	fi

done
