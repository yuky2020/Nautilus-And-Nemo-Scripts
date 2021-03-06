#!/bin/bash

###############################################################################
# Display a fullscreen slideshow of the selected files
###############################################################################
#
# AUTHOR:       Brian Connelly <pub@bconnelly.net>
#
# DESCRIPTION:  This script displays a fullscreen slideshow of the files which
#               have been selected in Nautilus.
#
# REQUIREMENTS: Nautilus file manager
#               feh (see http://www.linuxbrit.co.uk)
#               gdialog, which is usually included in the gnome-utils package
#
# INSTALLATION: GNOME 1.4.x: copy this script to the ~/Nautilus/scripts
#                       directory
#               GNOME 2.x: copy to the ~/.gnome2/nemo-scripts directory
#
# USAGE:        Select the files that you would like to display in Nautilus,
#               right click, go to Scripts, and then select this script.
#               You will then be asked to enter a Delay time.  This is the
#               length of time that each image will be shown.  If you enter
#               0, the image will be displayed until you either click on the
#               image, hit the right arrow, hit N or n, or the space key.
#               For more options, run "feh --help" (without quotation marks)
#
# VERSION INFO:
#               0.1 (20020923) - Initial public release
#
# COPYRIGHT:    Copyright (C) 2002 Brian Connelly <connelly@purdue.edu>
#
# LICENSE:      GNU GPL
#
###############################################################################
#DELAY=$(gdialog --title "Slideshow Properties" --inputbox "Enter Delay (Seconds)" 20 50 0 2>&1) || exit
DELAY=4
if [ $DELAY -eq 0 ]; then
  feh --title "Slideshow" -rFx -S name $NEMO_SCRIPT_SELECTED_URIS
else
  feh --title "Slideshow" -rFx -S name -D $DELAY
  $NEMO_SCRIPT_SELECTED_URIS
fi
