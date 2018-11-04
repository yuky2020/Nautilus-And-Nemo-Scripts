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

gconftool-2 --type string --set /apps/gnome-session/options/splash_image "$file_name"
