#!/bin/bash

if [ $# -eq 0 ]; then exit 1; fi
target=$( zenity --entry --title="Create new folder" --text="Enter new folder name:" )
if [ -z "$target" ]; then exit 0; fi
while [ -e "$target" ]; do
	target=$( zenity --entry --title="Create new folder" --text="\"$target\" existed. Enter other name:" )
	if [ -z "$target" ]; then exit 0; fi
done
mkdir "$target"
if [ ! -e "$target" ]; then
	zenity --error --text="Failed to create folder \"$target\"!"
	exit 1
fi
gvfs-move $NAUTILUS_SCRIPT_SELECTED_URIS "$target"
