#!/bin/bash

# to get desired device
df -h -x tmpfs -x usbfs
DVDDEVICE=$(zenity --entry --text="Using the information in the terminal window, please enter the appropriate DVD drive:")
XVIDNAME=$(zenity --entry --text="Please enter a name for the ISO file you will create:")
dd if="$DVDDEVICE" of="$XVIDNAME".iso
