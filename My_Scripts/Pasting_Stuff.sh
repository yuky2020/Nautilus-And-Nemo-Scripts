#!/bin/bash

# Pasting_Stuff.sh
# Creator: Inameiname
# Date: 20 August 2011
# Version: 1.0
#
#
# This is a simple nautilus script to copy and paste
# files and folders
#
#
# Useful for when the normal Nautilus copy and paste functioning fails
# and you do not feel like 'nautilus -q' just yet



# Set IFS so that it won't consider spaces as entry separators.
# Without this, spaces in file/folder names can make the loop go wacky.
IFS=$'\n'

# See if the Nautilus environment variable is empty
if [ -z $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS ]; then
    # If it's blank, set it equal to $1
    NAUTILUS_SCRIPT_SELECTED_FILE_PATHS=$1
fi

# Loop through the list (from either Nautilus or the command line)
for ARCHIVE_FULLPATH in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
    NEWDIRNAME=${ARCHIVE_FULLPATH%.*}
    FILENAME=${ARCHIVE_FULLPATH##*/}
    NAME=${ARCHIVE_FULLPATH##*/.*}

    if zenity --question --text="Press \"Yes\" to copy/paste or \"No\" to move the selected"; then
      # Copy and paste stuff
        progID=$(zenity --entry --text="Please enter the full path of where you want to copy/paste the selected (without parentheses)?")
        cp -fv -R "$ARCHIVE_FULLPATH" "$progID"
    else
      # Moving stuff
        progID=$(zenity --entry --text="Please enter the full path of where you want to move the selected (without parentheses)?")
        mv -fv -R "$ARCHIVE_FULLPATH" "$progID"
    fi

done

# Add a notification when finished, if desired
    notify-send -t 2000 -i /usr/share/icons/gnome/32x32/status/info.png "Job Finished"
