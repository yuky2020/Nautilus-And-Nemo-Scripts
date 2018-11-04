#!/bin/bash

# Set IFS so that it won't consider spaces as entry separators.  Without this, spaces in file/folder names can make the loop go wacky.
IFS=$'\n'

# See if the Nautilus environment variable is empty and/or known truecrypt drive
if [ -z $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS ]; then
	if [ -f /media/0DCBECE8506DF4C4/.hf ] ; then
	    "/home/$USER/.gnome2/nemo-scripts/My_Scripts/TrueCrypt/.truecrypt" '/media/0DCBECE8506DF4C4/.hf'
	    notify-send -t 5000 -i /usr/share/icons/gnome/32x32/status/info.png "Job Finished"
	else
 	    # If it's blank, set it equal to $1
 	    NAUTILUS_SCRIPT_SELECTED_FILE_PATHS=$1
	fi
else
   # If it's blank, set it equal to $1
   NAUTILUS_SCRIPT_SELECTED_FILE_PATHS=$1
fi

# Loop through the list (from either Nautilus or the command line)
for ARCHIVE_FULLPATH in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
    NEWDIRNAME=${ARCHIVE_FULLPATH%.*}
    FILENAME=${ARCHIVE_FULLPATH##*/}
    NAME=${ARCHIVE_FULLPATH##*/.*}

    "/home/$USER/.gnome2/nemo-scripts/My_Scripts/TrueCrypt/.truecrypt" "$ARCHIVE_FULLPATH"
    notify-send -t 5000 -i /usr/share/icons/gnome/32x32/status/info.png "Job Finished"
done
