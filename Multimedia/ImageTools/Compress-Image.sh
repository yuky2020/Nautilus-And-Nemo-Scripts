#!/bin/bash

# Nautilus script: Compress image
# Decrease quality of JPEG file to decrease file size

# Author: soleilpqd@gmail.com
# License: GNU GPL

# INSTALL:
#	Copy into ~/.gnome2/nemo-scripts, add executable permission (if needed).

function doCompress() {
	if [ $overwritable -eq 1 ] && [ ! -e "_compressed" ]; then
		mkdir "_compressed"
		if [ ! $? -eq 0 ]; then
			zenity --error --title="Compress image" --text="Can not create destination folder"
			exit 1
		fi
	fi
	failedCount=0
	tmp=$IFS
	IFS=$'\n'
	for f in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
		s=$( identify -format "%m" "$f" )
		if [ "$s" == "JPEG" ]; then
			if [ $overwritable -eq 1 ]; then
				dest="_compressed/$( basename "$f" )"
			else
				dest=$f
			fi
			echo "Proccessing $f"
			convert "$f" -quality $ratio "$dest"
			if [ ! $? -eq 0 ]; then
				let failedCount++
			fi
		else
			let failedCount++
		fi
	done
	IFS=$tmp
	if [ $failedCount -eq 0 ]; then
		zenity --info --title="Compress image" --text="All files was compressed successfully"
	else
		zenity --warning --title="Compress image" --text="There were $failedCount files failed"
	fi
}

# checking input file & get 1 file to preview simple
imgAvailable=0
tmp=$IFS
IFS=$'\n'
for f in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
	s=$( identify -format "%m" "$f" )
	if [ "$s" == "JPEG" ]; then
		imgAvailable=1
		previewFile=$f
		break
	fi
done
IFS=$tmp

if [ $imgAvailable -eq 0 ]; then
	zenity --error --title="Compress images" --text="Please select JPEG file(s)"
	exit 1
fi

zenity --question --title="Compress images" --text="Overwrite the original file?"
overwritable=$?
zenity --question --title="Compress images" --text="Preview?"
previewable=$?
stopable=0
ratio=90
while [ $stopable -eq 0 ]; do
	# Ask for compress ratio
	ratio=$( zenity --scale --title="Compress images ratio" --text="High number make high quality image but big file size" --min-value=1 --max-value=100 --value=$ratio )

	if [ $? -eq 0 ]; then
		if [ $previewable -eq 0 ]; then
			previewedFile=$( echo "/tmp/$( basename "$previewFile" )")
			if [ -e "$previewedFile" ]; then
				rm "$previewedFile"
			fi
			convert "$previewFile" -quality $ratio "$previewedFile" | zenity --progress --title="Making preview..." --auto-close --no-cancel --pulsate
			gvfs-open "$previewedFile"
			zenity --question --title="Agree with ratio $ratio?" --text="Origin: $( du -h "$previewFile" ). Result: $( du -h "$previewedFile" )."
			if [ $? -eq 0 ]; then
				doCompress | zenity --progress --title="Compressing..." --auto-close --no-cancel --pulsate
				stopable=1
			fi
			rm "$previewedFile"
		else
			doCompress | zenity --progress --title="Compressing..." --auto-close --no-cancel --pulsate
			stopable=1
		fi
	else
		stopable=1
	fi
done
