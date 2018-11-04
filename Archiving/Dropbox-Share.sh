#!/bin/bash

#edit:
USENOTIFYOSD=yes #yes or no to use NotifyOSD
#--------------------------

#do not edit:
LOCATION="`cat ~/.dropbox/host.db | sed -n 2p | base64 -d`/Public/"


#check if dropbox is running:
if ps -e | grep dropbox; then
	return
else	
	if [ $USENOTIFYOSD = yes ]; then
		notify-send --icon="dropbox" "Dropbox is not running" "Starting Dropbox..."
	else
		return	
	fi
dropbox start
sleep 15
fi

#--------------------------

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
				echo "$FILENAME" >> ~/.dropboxshare/history				
				#create emblem for the shared files:
				gvfs-set-attribute "$FILENAME" -t stringv metadata::emblems dropbox

		done	
		#refresh Nautilus. It's a hack, but there is no other way of doing this (really!):
		xsendkeycode 71 1
		xsendkeycode 71 0

		if [ $USENOTIFYOSD = yes ]; then
				notify-send --icon="dropbox" "Dropbox Share - Uploading" "Please wait while Dropbox uploads your shared files"
		else
				return	
		fi
		
		
#ok, now the emblems should be ok, we can start uploading the files to dropbox (creating the symbolic links and copying the public URLs to the clipboard):

		IFS=$'\n'
		for FILENAME in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
			do
			
			DROPBOXFILE=`echo $FILENAME | awk -F/ '{print $NF}'`
			if [ -f $FILENAME ]; then #files

			
				ln -s "$FILENAME" "$LOCATION"
				
				#copy the links to the clipboard:
				list="$list `dropbox puburl "$LOCATION"/"$DROPBOXFILE"`"
				echo -n $list | xclip -selection clipboard
				
				
			elif [ -d $FILENAME ]; then #folders
					
			
				DROPBOXFILE=`echo $FILENAME | awk -F/ '{print $NF}'`
				ln -s "$FILENAME" "$LOCATION"

				/usr/bin/dropbox-index.py -R "$LOCATION"/"$DROPBOXFILE" #write index.html for each folder we shared (recursively)
				
				#copy the links to the clipboard:
				list="$list `dropbox puburl "$LOCATION"/"$DROPBOXFILE"`/index.html"
				echo -n $list | xclip -selection clipboard
			
			else #something is wrong
				return
				# notify-send "Something doesnt work" "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" #debugging
			fi
		
		done
		


#find out when Dropbox finishes to upload our files; we don't care about the overall Dropbox status, only about our files status. If this part would have been 6 lines upper in the script, it would have been shorter, but each uploaded file would have been in the loop which checks the file status and that slows down the process, especially when uploading many folders.
		IFS=$'\n'
		for FILENAME in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
			do
				DROPBOXFILE=`echo $FILENAME | awk -F/ '{print $NF}'`
				DROPSTATUS=$(dropbox filestatus "$LOCATION"/"$DROPBOXFILE" | awk -F: '{print $NF}')
				while [ $DROPSTATUS  = " syncing" ]; do
					sleep 5
					DROPSTATUS=$(dropbox filestatus "$LOCATION"/"$DROPBOXFILE" | awk -F: '{print $NF}')
				done
		done	
		if [ $USENOTIFYOSD = yes ]; then
			notify-send --icon="dropbox" "Dropbox Share - DONE!" "Check your clipboard (Ctrl + V)"
			exit
		else
			exit
		fi
