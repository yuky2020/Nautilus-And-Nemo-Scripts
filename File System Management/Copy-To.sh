#!/bin/bash

###############################################################################
#
# AUTHOR:	Bruno Casella (brunocasella@gmail.com)
#
# 
# DESCRIPTION:	copy a selected file or folder to a destiny folder
#				
#
# REQUIREMENTS:	Nautilus file manager
#		Gnome2
#		gdialog, which is usually included in the gnome-utils package
#
# INSTALLATION:	copy to the ~/.gnome2/nemo-scripts directory
#		
# USAGE:	Select the file or folder you would like to copy, right click
#			and execute this script. Then select the destination folder.
#
# VERSION INFO:	0.1  
#
#
# LICENSE:	GNU GPL
#
###############################################################################


FILE=`echo -n $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS`

DESTINO=$(zenity --title "Select a folder to move" --file-selection --directory)
cp -uR "$FILE" "$DESTINO"
exit


