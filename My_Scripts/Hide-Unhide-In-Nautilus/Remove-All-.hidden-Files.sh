#!/bin/bash



# Remove-All-.hidden-Files.sh
# Creator: Inameiname
# Date: 22 June 2011
# Version: 1.0
#
#
# This is a simple nautilus script to automatically remove all ".hidden" files
# in your home directory, including those ".hidden" files created using
# "Hide-Unhide-In-Nautilus.sh"



if zenity --question --text "Are you sure you want to remove all of the ".hidden" files in your home directory?" ; then
    # If answer is "yes", then do this:
    # Upon startup, remove all ".hidden" files (that way you can start fresh after each restart, in case you've changed things on this script)
      cd $HOME
      find . -type f -name ".hidden" -exec rm -f {} \;

    # Add a notification when finished, if desired
      notify-send -t 4000 -i /usr/share/icons/gnome/32x32/status/info.png "All ".hidden" files have been removed"
else
    # If answer is "no", then do this:
    # Add a notification when finished, if desired
      notify-send -t 4000 -i /usr/share/icons/gnome/32x32/status/info.png "All ".hidden" files have NOT been removed"
fi
