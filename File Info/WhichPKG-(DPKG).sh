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

realfile=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g')

pkg=$(grep -w $realfile /var/lib/dpkg/info/*.list | sed -e 's/\.list.*//g' -e 's/.*\/info\///g')

echo -en "\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n" >> /tmp/whichpkg.txt
echo "$realfile belongs to the $pkg package." >> /tmp/whichpkg.txt;

done

zenity --text-info --title "Result" --width=640 --height=480 --filename=/tmp/whichpkg.txt

rm -f /tmp/whichpkg.txt
