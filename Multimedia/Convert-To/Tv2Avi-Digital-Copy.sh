#!/bin/bash



# best quality; big file size (100mb/min), but needs strong signal
dtvchannels
DIGITALSTATION=$(zenity --entry --text="What digital tv channel would you like to convert?:")
AVINAME=$(zenity --entry --text="Please enter a name for the AVI file you will convert:")
ENDPOSITION=$(zenity --entry --text="Please enter how long you want to record (in this format: 02:08:17):")
mencoder dvb://"$DIGITALSTATION" -o "$AVINAME".avi -oac copy -ovc copy -endpos "$ENDPOSITION"
