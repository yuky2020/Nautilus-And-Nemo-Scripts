#!/bin/bash
#########################################################
#							#
# 	FourCC Changer by Alpha-Thinker			#
#	version 0.1 (2009)				#
# 	Licensed under GPL 3				#
#	Changes "used" codec of AVI file to XviD	#
#							#
#							#
#########################################################

# Tweaked by: Inameiname
# 11 September 2011

#Check for required software...
cfourcc_bin=$(dpkg -l | grep cfourcc)

# Check for cfourcc
if [ -z "$cfourcc_bin" ] ; then
zenity --error --title="Error - Missing Software" \
 --text="You do not have the cfourcc package installed
Please install it in order to use this script.
Type 'sudo apt-get install cfourcc' in the terminal."
exit
fi

echo $NAUTILUS_SCRIPT_SELECTED_URIS > /dev/shm/tobechanged

zenity --question --title "FourCC Changer by Alpha-Thinker" --text "Change the FourCC of $(cat /dev/shm/tobechanged | sed -e 's/\%20/\ /g' -e 's/.*\///g') to XviD?"

if (( $? == 0 )); then
	for file in $(cat /dev/shm/tobechanged); do

		shortfile=$(echo $file | sed -e 's/\%20/\ /g' -e 's/.*\///g')
		file_name=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g')

		cfourcc -u XVID "$file_name"

		if (( $? == 0 )); then
			zenity --info --text="$shortfile changed to XviD" --title "Success !"
		else	zenity --info --text="$shortfile couldn't be changed !&%#@" --title "Failure :("
		fi
	done
fi

rm -f /dev/shm/tobechanged
unset XRETURN

