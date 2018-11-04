#!/bin/bash

#credits for the Dropbox Unshare script: Nicolas @ http://blog.nicolargo.com/2010/09/scripts-nautilus-pour-partagerdepartager-ses-fichiers-avec-dropbox.html

LOCATION="`cat ~/.dropbox/host.db | sed -n 2p | base64 -d`/Public"

#-------------------------- remove emblems for files which have been manually removed from the Dropbox Public folder -------------

if [[ ! -e ~/.dropboxshare/history ]]; then
	mkdir -p ~/.dropboxshare
	touch ~/.dropboxshare/history
fi

ISINHISTORY=$(cat ~/.dropboxshare/history | awk -F/ '{print $NF}')
IFS=$'\n'
for PUBLICFILE in $ISINHISTORY; do
	ISINDROPBOX=$(ls $LOCATION | grep "$PUBLICFILE")
	if [[ ! $ISINDROPBOX ]]; then
		REMOVEEMBLEM=$(cat ~/.dropboxshare/history | grep "$PUBLICFILE")
		gvfs-set-attribute "$REMOVEEMBLEM" -t unset metadata::emblems
		FORMATFORSEDREMOVEEMBLEM=$(echo $REMOVEEMBLEM | sed -e 's/\//\\\//g')
 		sed -i "/$FORMATFORSEDREMOVEEMBLEM/d" ~/.dropboxshare/history
	else
		return
	fi
done

#------------------------------------------------------------------------------------------------------


#setting the file emblems needs to be done immediately after the user shares them, or else Nautilus is not refreshed and the emblems do not show up. For this reason, we'll have the "for" loop twice: once for the emblems metadata and a second time for actually sharing the folders and copying the URLs to the clipboad:

IFS=$'\n'
for FILENAME in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
do
	gvfs-set-attribute "$FILENAME" -t unset metadata::emblems  

done
#refresh Nautilus. It's a hack, but there is no other way of doing this (really!):
xsendkeycode 71 1
xsendkeycode 71 0     


IFS=$'\n'
for FILENAME in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
do
	DROPBOXFILE=`echo $FILENAME | awk -F/ '{print $NF}'`
	rm -f "$LOCATION"/"$DROPBOXFILE"
	FORMATFORSEDREMOVEEMBLEM=$(echo $FILENAME | sed -e 's/\//\\\//g')
 	sed -i "/$FORMATFORSEDREMOVEEMBLEM/d" ~/.dropboxshare/history

	list="$list $LOCATION/$DROPBOXFILE"
done
notify-send --icon="dropbox" "UnShared from Dropbox" "Unshared: $list"
