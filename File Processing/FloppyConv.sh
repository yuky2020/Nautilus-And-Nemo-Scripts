#!/bin/bash
#
# Floppy Conv v0.1
# Last modifed: 12-29-2010
# Language : English
#
# FILE LOADED VAR
echo "[`date +%T`] Selection of .IMA file" >>/tmp/log.txt
FLOPPY_IN=`zenity --file-selection --title="Please select a .IMA floppy image"`
# IF CANCEL CLICKED
if [ $? == 1 ]; then
{
	rm -rf /tmp/log.txt
	exit 2;
}
fi
echo "[`date +%T`] Image file selected." >>/tmp/log.txt
# OUTPUT FILE VAR
echo "[`date +%T`] Selection of the save directory and filename" >>/tmp/log.txt
FLOPPY_OUT=`zenity --file-selection --title="Save converted file" --save`
# IF CANCEL CLICKED
if [ $? == 1 ]; then
{
	rm -rf /tmp/log.txt
	exit 3;
}
fi
echo "[`date +%T`] Save directory and filename set." >>/tmp/log.txt
# RUN CONVERSION
echo "[`date +%T`] Run conversion." >>/tmp/log.txt
echo "[`date +%T`] Conversion details :" >>/tmp/log.txt
dd if="$FLOPPY_IN" of="$FLOPPY_OUT".IMG 2>>/tmp/log.txt
echo "[`date +%T`] Conversion finished. Check if the file exists..." >>/tmp/log.txt
# CHECK IF THE FILE EXISTS
# IF FILE EXISTS = SUCCESS
if [ -e "$FLOPPY_OUT.IMG" ]; then
{
	echo "[`date +%T`] File exists ! Conversion successful !" >>/tmp/log.txt
	zenity --info --text="Conversion of "$FLOPPY_OUT".IMG successful !"
}
# ELSE CONVERSION ERROR
else
{
	echo "[`date +%T`] Something went wrong... Check the conversion details above" >>/tmp/log.txt
	zenity --error --text="Conversion error. Click to see and check the log file."
}
fi
# CONVERSION LOG
LOG=/tmp/log.txt
zenity --text-info --width=600 --height=400 --title="$LOG" --filename="$LOG"
if [ $? == 0 ]; then
{
	rm -rf /tmp/log.txt
}
else
{
	exit 1;
}
fi
# SCRIPT END
exit 0;

