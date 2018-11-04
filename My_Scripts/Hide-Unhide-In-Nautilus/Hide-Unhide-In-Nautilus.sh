#!/bin/bash

# Hide-Unhide-In-Nautilus.sh
# Creator: Inameiname
# Date: 21 June 2011
# Version: 1.0
#
#
# This is a simple nautilus script to automatically add file(s)/folder(s)
# to a ".hidden" file so Nautilus will hide them, just like ".*" files
# Instructions:
# - decide what file(s)/folder(s) you want to hide inside a particular folder,
# - highlight them, and right click and select the script
# - it will automatically add the filenames to a created ".hidden" file inside the directory
# - if ".hidden" isn't there, it will add it
# - if you decide to unhide things, simply highlight and select the script again,
# - and it will automatically remove the filenames from the ".hidden" file
# - if ".hidden" contains no filenames, it will remove it
#
#
# Optionals:
# - Add the option to change the owner and group for whatever is selected to hide/unhide
# - Add the option to add the permissions for whatever is selected to hide/unhide
# - Add the option to make executable whatever is selected to hide/unhide
#
#
# Remember this only works inside the current directory/opened folder and files/folders inside that folder.
# Just comment out or uncomment whatever desired.
# Currently, only the ability to hide/unhide stuff is uncommented,
# but you can always just comment it out, and uncomment one of the "Make Executable" commands,
# and/or one of the "Change the owner and/or group of each file" commands,
# and/or one of the "Add permissions" commands, or mix and match whatever you want.
#
#
# For the changes to take effect to the file(s)/folder(s) you hid/unhid, you may have to refresh the folder, or even Nautilus



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

    # Hide/Unhide file(s)/folder(s) using ".hidden" file within the current folder
      # Copies all selected files/folders filenames to ".hidden"
        echo $FILENAME >> .hidden
      # Sorts and Checks ".hidden" for any duplicates
        sort .hidden | uniq -u > .hidden_temp
        rm .hidden
        mv .hidden_temp .hidden
      # Checks ".hidden" to see if there is anything there; if not, it removes it
        for file in .hidden
        do
          if [ `wc -l < $file` -eq 0 ]; then
             # file is empty
             rm $file
          fi
        done
    # Change the owner and/or group of each FILE to OWNER and/or GROUP, if desired
      # chown -R $USER:$USER $ARCHIVE_FULLPATH # set owner:group to current user
      # gnome-terminal -x sudo chown -R root:root $ARCHIVE_FULLPATH # set owner:group to root
      # gnome-terminal -x sudo chown -R $USER:$USER $ARCHIVE_FULLPATH # set owner:group to current user
    # Add permissions, if desired
      # chmod 444 $ARCHIVE_FULLPATH # read-only permissions for all
      # chmod 600 $ARCHIVE_FULLPATH # read/write for you, no permissions for rest
      # chmod 644 $ARCHIVE_FULLPATH # read/write for you, read-only permissions for rest (default)
      # sudo chmod 444 $ARCHIVE_FULLPATH # read-only permissions for all
      # sudo chmod 600 $ARCHIVE_FULLPATH # read/write for you, no permissions for rest
      # sudo chmod 644 $ARCHIVE_FULLPATH # read/write for you, read-only permissions for rest (default)
    # Make executable, if desired
      # chmod +x $ARCHIVE_FULLPATH
      # gnome-terminal -x sudo chmod +x $ARCHIVE_FULLPATH

done

# Add a notification when finished, if desired
    notify-send -t 2000 -i /usr/share/icons/gnome/32x32/status/info.png "Job Finished"
