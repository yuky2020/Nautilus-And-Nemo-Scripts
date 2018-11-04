#!/bin/bash

# Set IFS so that it won't consider spaces as entry separators.  Without this, spaces in file/folder names can make the loop go wacky.
IFS=$'\n'

# Ensure the proper permissions are set
    SUDO="/usr/bin/sudo"
if [ -t 1 ]; then
    "$SUDO" "$@";
else
    gksudo -- "$SUDO" "$@";
fi

# Actual commands
    sync
    umount /media/truecrypt*
    /home/$USER/.gnome2/nemo-scripts/My_Scripts/TrueCrypt/.truecrypt -d
    notify-send -t 5000 -i /usr/share/icons/gnome/32x32/status/info.png "Job Finished"
done
