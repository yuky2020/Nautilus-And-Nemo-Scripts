#!/usr/bin/env sh

if [ -z "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]; then
gnome-terminal
else
# if clicking happens on (a file\folder on) Desktop
# (and so, &1 is a path, having "/" in it)
if echo $1 | grep -q "/"; then
# then if it's a file
if [ -f "$1" ]; then
dir=`dirname "$1"`
# or it's a directory
else
dir="$1"
fi
else
base="`echo $NAUTILUS_SCRIPT_CURRENT_URI | cut -d'/' -f3- | sed 's/%20/ /g'`"

while [ ! -z "$1" -a ! -d "$base/$1" ]; do shift; done
dir="$base/$1"

fi
gnome-terminal --working-directory="$dir"
fi
