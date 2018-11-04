#!/bin/bash

###### DVD to MPG
# to get desired device
df -h -x tmpfs -x usbfs
DVDDEVICE=$(zenity --entry --text="Using the information in the terminal window, please enter the appropriate DVD drive:")
# to get desired title on dvd
# requires lsdvd: sudo apt-get install lsdvd
lsdvd "$DVDDEVICE"
DVDTITLE=$(zenity --entry --text="Using the information in the terminal window, please enter the title number you will convert (usually the longest one):")
MPEGNAME=$(zenity --entry --text="Please enter a name for the MPG/MPEG file you will convert:")
mplayer dvd://"$DVDTITLE" -dumpstream -alang es -dumpfile "$MPEGNAME".mpg
