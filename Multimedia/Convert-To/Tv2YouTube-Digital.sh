#!/bin/bash



###### DIGITAL TV to YouTube-compliant AVI
# ok quality (YouTube) (5mb/min)
dtvchannels
DIGITALSTATION=$(zenity --entry --text="What digital tv channel would you like to convert?:")
AVINAME=$(zenity --entry --text="Please enter a name for the AVI file you will convert:")
ENDPOSITION=$(zenity --entry --text="Please enter how long you want to record (in this format: 02:08:17):")
mencoder dvb://"$DIGITALSTATION" -oac mp3lame -lameopts cbr=128 -ovc lavc -lavcopts vcodec=mpeg4 -ffourcc xvid -vf scale=320:-2,expand=:240:::1 -o "$AVINAME".avi -endpos "$ENDPOSITION"
