#!/bin/bash
#
# Nautilus script to easily toggle (Show/Hide) desktop
#
# Owner : Peeyoosh Sangolekar
#         piyush_sangolekar@hotmail.com
#         http://enli.co.cc
#
# Installation : Place in ~/.gnome2/nemo-scripts/
#
# Typical Usage : Execute script from any folder by right clicking in empty space > Scripts > Toggle-Desktop.sh
# If currently Desktop is hidden, open any folder and execute above as Desktop won't be clickable.
#
# Licence : GNU GPL 
#
# Copyright (C) EnLi
#
# Ver. 0.1 Date: 16.06.2009
# Initial release
#
# Dependencies : Nautilus

hide="gconftool -s --type bool /apps/nautilus/preferences/show_desktop false"
show="gconftool -s --type bool /apps/nautilus/preferences/show_desktop true"
test=$( gconftool-2 --get /apps/nautilus/preferences/show_desktop )

if [ $test = "true" ]; then
	eval $hide
else
	eval $show
fi
