#!/bin/bash

OLDIFS=$IFS;
IFS=$'\n';
for path in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
do
	gnome-terminal -x "$HOME/.gnome2/nemo-scripts/System Configuration/Generate Dynamic Wallpaper XML/.dynamic-wallpaper-xml-generater.sh" $path &
	break;
done
IFS=$OLDIFS;
