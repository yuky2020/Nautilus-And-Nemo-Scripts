#!/bin/bash

###############################################################################
# Display a fullscreen slideshow of the selected files
###############################################################################
#
# AUTHOR:	Karl Bowden <kbowden@pacificspeed.com.au>
# MODIFIED BY:	rpgmaker <http://gnome-look.org/usermanager/search.php?username=rpgmaker>
#
# CREDITS:	Brian Connelly <pub@bconnelly.net> - For the slideshow script
#		that I based this script on.
#
# DESCRIPTION:	This script sets the background in Gnome2 the the selected
#		filename.
#
# REQUIREMENTS:	Nautilus file manager
#		Gnome2
#		gdialog, which is usually included in the gnome-utils package
#
# INSTALLATION:	copy to the ~/.gnome2/nemo-scripts directory
#
# USAGE:	Select the file that you would like to use as your wallpaper
#		in Nautilus, right click, go to Scripts, and then select this
#		script. You will then be asked to selest how you would like
#		the image displayed.
#
# VERSION INFO:
#		0.1 (20020928) - Initial public release
#		0.2 (20121231) - Modified to use gsettings
#
# COPYRIGHT:	Copyright (C) 2002 Karl Bowden <kbowden@pacificspeed.com.au>
#
# LICENSE:	GNU GPL
#
###############################################################################

WALLPAPER=$(gdialog --title "Wallpaper Options" --radiolist "Picture Options:" 60 100 10 1 Wallpaper off 2 Zoom off 3 Scaled off 4 Stretched off 5 Centered off 6 Spanned off 7 None off 2>&1)

if [ $WALLPAPER = "1" ]; then
	gsettings set org.gnome.desktop.background picture-options wallpaper
	gsettings set org.gnome.desktop.background picture-uri $NAUTILUS_SCRIPT_SELECTED_URIS
fi
if [ $WALLPAPER = "2" ]; then
	gsettings set org.gnome.desktop.background picture-options zoom
	gsettings set org.gnome.desktop.background picture-uri $NAUTILUS_SCRIPT_SELECTED_URIS
fi
if [ $WALLPAPER = "3" ]; then
	gsettings set org.gnome.desktop.background picture-options scaled
	gsettings set org.gnome.desktop.background picture-uri $NAUTILUS_SCRIPT_SELECTED_URIS
fi
if [ $WALLPAPER = "4" ]; then
	gsettings set org.gnome.desktop.background picture-options stretched
	gsettings set org.gnome.desktop.background picture-uri $NAUTILUS_SCRIPT_SELECTED_URIS
fi
if [ $WALLPAPER = "5" ]; then
	gsettings set org.gnome.desktop.background picture-options centered
	gsettings set org.gnome.desktop.background picture-uri $NAUTILUS_SCRIPT_SELECTED_URIS
fi
if [ $WALLPAPER = "6" ]; then
	gsettings set org.gnome.desktop.background picture-options spanned
	gsettings set org.gnome.desktop.background picture-uri $NAUTILUS_SCRIPT_SELECTED_URIS
fi
if [ $WALLPAPER = "7" ]; then
	gsettings set org.gnome.desktop.background picture-options none
	gsettings set org.gnome.desktop.background picture-uri $NAUTILUS_SCRIPT_SELECTED_URIS
fi
