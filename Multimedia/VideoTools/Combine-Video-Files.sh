#!/bin/bash

##################################################################
#
# Combines two or more avi files and prompts for the file name.
#
# 1) checks to make sure "mencoder" is installed. If not,
#    the program won't run.
# 2) handles filenames with spaces just fine.
#
##################################################################
#
# Changelog
#
# 06/02/2010 v1.0 - Initial public release. Includes support for spaces
#                   in file paths.
#
# 06/03/2010 v1.5 - Now moves seed video files to the user's Trash
#                   folder rather than 'rm' removing them.
#
##################################################################

package_check=$(dpkg -l | grep mencoder)
IFS=$'\t\n'

if [ -z "$package_check" ]
then
	zenity --warning --text="The package \"mencoder\" is required and is not installed. \n\nRun \"sudo apt-get install mencoder\" in a terminal and then re-run this script."
	exit 0
fi

if [ -z "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]
then
	zenity --warning --text="No files have been selected"
else
	name=`zenity --entry --title="Type the file name"`
	cd $NAUTILUS_SCRIPT_CURRENT_URI
	cat $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS > "$name.temp.avi";
	mencoder -forceidx -oac copy -ovc copy "$name.temp.avi" -o "$name.avi";
	rm "$name.temp.avi";
	trash_paths=$(echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | sed 's/.*\///g')
	mv -t ~/.local/share/Trash/files/ $trash_paths
fi
