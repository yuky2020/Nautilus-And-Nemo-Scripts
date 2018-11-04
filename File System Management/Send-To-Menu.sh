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

for file in $NAUTILUS_SCRIPT_SELECTED_URIS; do \

	file_name=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g')

	if [[ -a $HOME/.local/share/applications/ ]]; then
		cp $file_name $HOME/.local/share/applications
	else	mkdir -p $HOME/.local/share/applications
		cp $file_name $HOME/.local/share/applications
	fi
done
