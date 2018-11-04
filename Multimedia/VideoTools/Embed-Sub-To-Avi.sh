#!/bin/bash

# AUTHOR:	(c) Eugenio F. <eug.alfe@gmail.com>
# VERSION:	1.0
# LICENSE:	GPL (http://www.gnu.org/licenses/gpl.html)
# REQUIRES:	gawk, mencoder, and zenity
# NAME:		Sub>Mov
# INSTALLATION: Copy to the "~/.gnome2/nemo-scripts" directory
# DESCRIPTION:	Add subtitle to avi file
# TWEAKED BY:	Inameiname (11 September 2011)

#Check for required software...
gawk_bin=$(dpkg -l | grep gawk)
mencoder_bin=$(dpkg -l | grep mencoder)

# Check for gawk
if [ -z "$gawk_bin" ] ; then
zenity --error --title="Error - Missing Software" \
 --text="You do not have the gawk package installed
Please install it in order to use this script.
Type 'sudo apt-get install gawk' in the terminal."
exit
fi

# Check for mencoder
if [ -z "$mencoder_bin" ] ; then
zenity --error --title="Error - Missing Software" \
 --text="You do not have the mencoder package installed
Please install it in order to use this script.
Type 'sudo apt-get install mencoder' in the terminal."
exit
fi



for File in "$@"
do
test ! $# -eq 2 && zenity --warning --text "Please select two files (avi/srt)."

IFS="|"
test `echo "$File" | grep ".avi"` = "$File" && AVI="$File"
test `echo "$File" | grep ".srt"` = "$File" && SRT="$File"

if [ -n "$AVI" -a -n "$SRT" ];then
	AVIS=`echo $AVI | sed "s/\.avi/-SUB.avi/"`
	mencoder -oac copy -ovc lavc -sub "$SRT" -subcp ISO-8859-15 -sub-bg-alpha 255 -ffourcc XVID "$AVI" -o "$AVIS" 2>&1 \
	| gawk -F"(" -vRS='\r' '{gsub(/ /,"");gsub(/%).*/,"");print $2"\n#Adding subtitle...\t\t\t\t\t\t\t"$2"%"}' \
	| zenity --progress --percentage=0 --auto-kill --auto-close --title="Working"
fi
done

