#!/bin/bash

###### ANALOG TV to AVI
# great xvid quality (11mb/min)
ANALOGSTATION=$(zenity --entry --text="What analog/cable tv channel would you like to convert? (1-99):")
AVINAME=$(zenity --entry --text="Please enter a name for the AVI file you will convert:")
ENDPOSITION=$(zenity --entry --text="Please enter how long you want to record (in this format: 02:08:17):")
mencoder -tv driver=v4l2:device=/dev/video1:input=0:norm=ntsc:chanlist=us-cable:channel="$ANALOGSTATION":alsa=1:adevice=hw.1:audiorate=48000:immediatemode=0:amode=1 tv:// -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=1600:v4mv:keyint=250 -vf softskip -oac mp3lame -lameopts br=128 -ffourcc xvid -o "$AVINAME".avi -endpos "$ENDPOSITION"
