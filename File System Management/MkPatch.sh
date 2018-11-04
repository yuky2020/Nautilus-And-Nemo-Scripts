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

orig_file=$(zenity --file-selection --title "Original File")

modi_file=$(zenity --file-selection --title "Modified File")

short_orig_file=$(echo $orig_file | sed -e 's#.*/##g')

diff -u "$orig_file" "$modi_file" >"$HOME/Desktop/$short_orig_file.patch"

zenity --text-info --title "Result" --width=640 --height=480 --filename="$HOME/Desktop/$short_orig_file.patch"
