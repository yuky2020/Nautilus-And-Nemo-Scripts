#!/bin/bash

###############################################
##
##	07.16.2010 - First release
##
###############################################

IFS=$'\t\n'

transcode_install=$(dpkg -l | grep "transcode")		# Dependencies
avisplit_install=$(dpkg -l | grep "transcode-utils")

if [ -z "$transcode_install" ]
then
	zenity --warning --text="The packages \"transcode and transcode-utils\" are required. One or both are not installed. \n\nRun \"sudo apt-get install transcode transcode-utils\" in a terminal and then re-run this script."
	exit 0
elif [ -z "$avisplit_install" ]
then
	zenity --warning --text="The packages \"transcode and transcode-utils\" are required. One or both are not installed. \n\nRun \"sudo apt-get install transcode transcode-utils\" in a terminal and then re-run this script."
	exit 0
fi

if [ -z "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]
then
	zenity --warning --text="No files have been selected. Try again!"
else
	splitsize=`zenity --entry --title="Enter split size MB:"`	# ask user for filesize
	actsize=$(($splitsize-1))					# slightly reduce it for files that will go slightly over
#	filesize=$(du -b $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS | cut -f1 -s)
#	splitnumber=$((($filesize/1048576)/$fileqty))
	format=$(tcprobe -X -H 50 -i $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS | grep format | tail -n 1 | sed 's/.*format: //g')	# find video format
	filebase=$(echo $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS | sed 's/\(.*\)\..*/\1/;s/.*\///g')				# find filename minus file extension
	ext=$(echo $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS | sed 's/.*\././g')							# find file extension
	tempfilename="$filebase.temp$ext"
	transcode -i $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS -P1 -N $format -y raw -o $tempfilename	# re-encode the file to match a/v frames, which will keep a/v in sync.
	avisplit -i "$tempfilename" -s "$actsize" -o "$filebase"
	cd $NAUTILUS_SCRIPT_CURRENT_URI									# move into dir
	mv -t ~/.local/share/Trash/files/ $tempfilename							# send temp file to trash
	zenity --warning --text="Done!"
fi

