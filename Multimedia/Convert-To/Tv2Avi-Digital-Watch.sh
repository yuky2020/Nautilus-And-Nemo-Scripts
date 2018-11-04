#!/bin/bash


# great xvid quality (13mb/min) (watch the recording at the same time)
dtvchannels
DIGITALSTATION=$(zenity --entry --text="What digital tv channel would you like to convert?:")
AVINAME=$(zenity --entry --text="Please enter a name for the AVI file you will convert:")
ENDPOSITION=$(zenity --entry --text="Please enter how long you want to record (in this format: 02:08:17):")
mencoder dvb://"$DIGITALSTATION" -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=1600:v4mv:keyint=250 -vf softskip,scale=624:352 -oac mp3lame -lameopts br=128 -ffourcc xvid -o "$AVINAME".avi -endpos "$ENDPOSITION" & (sleep 5 && mplayer "$AVINAME".avi)
