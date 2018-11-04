#!/bin/bash

# Set IFS so that it won't consider spaces as entry separators.  Without this, spaces in file/folder names can make the loop go wacky.
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

# convert .toc to .cue
toc2cue $ARCHIVE_FULLPATH $NEWDIRNAME.cue

# convert .bin/.cue to .iso using bchunk
bchunk $ARCHIVE_FULLPATH.bin $NEWDIRNAME.cue $NEWDIRNAME.iso

# notification when finished
notify-send -t 3000 -i /usr/share/icons/gnome/32x32/status/info.png "Job Finished"

done
