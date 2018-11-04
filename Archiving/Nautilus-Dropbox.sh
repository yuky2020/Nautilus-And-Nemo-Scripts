#!/bin/sh
#
# W.H. Kalpa Pathum <callkalpa@gmail.com>
# 1st June, 2010
#

# Dropbox directory
DROPBOX_DIR="$HOME/Dropbox/"

# creates a temporary file
file_list=$(mktemp)

# writes the URIs of the selected file to the temp file
echo $NAUTILUS_SCRIPT_SELECTED_URIS | sed 's/ \//\n/g' > $file_list

# iterete through the file list
for file in $(cat $file_list)
  do
	# extract the last filed from the URI, that is the file name
    filename="$(echo $file | awk -F'/' '{print $NF}' | sed 's/%20/ /g')"
    
    # creates the symbolic link
    ln -s "$(pwd)/$filename" "$DROPBOX_DIR$filename"
    
    # sets the emblem
    gvfs-set-attribute -t stringv "$filename" metadata::emblems default
    done

exit 0
