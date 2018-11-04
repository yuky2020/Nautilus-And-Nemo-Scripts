#!/bin/bash
# Based on the original script: (C) 2006 AMSOFT - Version 6.10.28-5.00
# Brought to date and improved by BruceLee @ 2010
# This mounts CD images: cue, iso, mds, ccd, nrg

fix_it () { echo $@; }	# lazy method for removing first and last spaces in string
show_info () { zenity --info --window-icon="$app_icon" --title="$app_name $version" --text="$@";  }

app_name="Disc Mount"
version="0.2.1"
app_icon="/usr/share/icons/gnome/scalable/devices/gtk-cdrom.svg"
warning_icon="/usr/share/icons/gnome/scalable/status/dialog-warning.svg"
error_icon="/usr/share/icons/gnome/scalable/status/error.svg"

EXT=`echo "$@" | sed -e 's/.*\.//'`		# extension
EXT_LOW=`echo $EXT | tr 'A-Z' 'a-z'`	# extension lower case
# Main
case "$EXT_LOW" in
cue|iso|mds|ccd|nrg)
	# Find a free DEV to mount
	DEV=$((`cdemu status | cut -f 6 -d " " | grep 0 -n -m 1 | cut -c 1`-3))
	if [ $DEV -lt "0" ]; then
		show_info "You can not mount any more images."; exit 1
	fi
	# Only allow mounting an image once
	if [ ! -z "`cdemu status | grep "$@"`" ]; then
		show_info "Image already mounted."; exit 1
	fi
	# DEV needs to be between 0 and 7
	if [ $DEV -ge "0" ] && [ $DEV -le 7 ]; then
		drives=`ls /media/`
		cdemu load $DEV "$@"
		ok=0
		try=1
		# Wait for the new mounted folder to appear in /media/*
		while [ "$ok" == "0" ] && [ "$try" -le "5" ]; do
			sleep 1s
			new_drive=`ls /media/`
			for each in $drives; do
				new_drive=`echo $new_drive | sed -e 's/'$each'//g'`
			done
			new_drive=`fix_it $new_drive`
			if [ -d "/media/$new_drive" ] && [ ! -z "$new_drive" ]; then ok="1"; fi
			try=$(( $try + 1 ))
		done
		# Check if the image is actually mounted
		if [ -z "`cdemu status | grep "$@"`" ]; then	ok="0";		else	ok="1";		fi
		# Show notification and open mounted disc
		if [ "$ok" == "1" ]; then
			notify-send -i "$app_icon" "Mounted" "`echo $@ | awk -F"/" '{print $NF}'`"
			gnome-open "/media/$new_drive" &
		else
			notify-send -i "$error_icon" "Couldn't Mount:" "`echo $@ | awk -F"/" '{print $NF}'`"
		fi
	fi
	;;
*)
	show_info "The selected file is not a known disc image."; exit 1
	;;
esac
