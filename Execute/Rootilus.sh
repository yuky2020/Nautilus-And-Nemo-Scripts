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

if [[ $(which gksu) != "" ]]; then
	gksu -u root "nautilus --no-desktop $NAUTILUS_SCRIPT_CURRENT_URI"
else 	zenity --info --text="gksu is not installed or not in $PATH" --title="Error"
fi
