#!/bin/bash

########################################
## This script toggles the file preview
## thumbnailer on/off.
########################################

status=$(gconftool-2 --get "/apps/nautilus/preferences/show_image_thumbnails")

if [ "$status" = "always" ]
then
	gconftool-2 --set "/apps/nautilus/preferences/show_image_thumbnails" --type string "never"
elif [ "$status" = "never" ]
then
	gconftool-2 --set "/apps/nautilus/preferences/show_image_thumbnails" --type string "always"
fi
exit 0
