######################################################################################################################################################
################################### MY SCRIPT FILE ################################### MY SCRIPT FILE ################################### MY SCRIPT FILE
######################################################################################################################################################








#!/bin/bash
##################################################
# TV.sh						 #
# Creator:		Inameiname		 #
# Original Creator:	Jose Catre-Vandis	 #
# Version: 1.1			 		 #
# Last modified: 18 November 2011		 #
#						 #
# Change log:					 #
# 1.01 - 18/11/11 - Added audio quality options	 #
# 						 #
# 1.00 - 24/09/11 - Complete overhaul of Jose	 #
# Catre-Vandis's original script, including 	 #
# adding dvb/analog playing options, as well as	 #
# combining the original three scripts into one	 #
#			 			 #
# Requirements: mencoder & zenity		 #
# sudo apt-get install mencoder zenity		 #
#			 			 #
# THINGS YOU WILL NEED TO DO:			 #
# 1. A working dvb card and/or analog tv card	 #
# 2. If dvb, a ~/.mplayer/channels.conf		 #
# - can scan dvb channels and create this by:	 #
#	- sudo scan /usr/share/dvb/atsc/us-ATSC- #
#	- center-frequencies-8VSB > ~/.mplayer/	 #
#	- channels.conf				 #
# 3. If analog, a channel list, and tuned in! 	 #
# - (all channels must have no spaces!)		 #
# - can scan analog channels and tune in by:	 #
# 	- tvtime-scanner			 #
# 4. Determine where your tv card is located, and#
# change if need be (script set on 'video1')	 #
# - tvtime-configure -d /dev/video0 # if tvtime	 #
# - otherwise, change 'video1' to 'video0' below #
#						 #
# Installation:					 #
# Place the script wherever you like, I use 	 #
# ($HOME/.gnome2/nemo-scripts/My_Scripts/TV) #
# Make sure the script file is executable 	 #
#						 #
# Background and Credits:			 #
# Thanks also goes to Craig Szymanski, whose 	 #
# video-convert script inspired Jose Catre-Vandis#
# who first created this script, which was later #
# heavily tweaked by Inameiname			 #
# 						 #
# License:					 #
# This program is free software; you can 	 #
# redistribute it and/or modify it under the 	 #
# terms of the GNU General Public License as 	 #
# published by the Free Software Foundation; 	 #
# either version 2 of the License, or (at your 	 #
# option) any later version.			 #
#						 #
# This program is distributed in the hope that it#
# will be useful, but WITHOUT ANY WARRANTY; 	 #
# without even the implied warranty of 		 #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR 	 #
# PURPOSE. See the GNU General Public License 	 #
# for more details.				 #
##################################################








######################################################################################################################################################
###### SOFTWARE CHECK ###### SOFTWARE CHECK ###### SOFTWARE CHECK ###### SOFTWARE CHECK ###### SOFTWARE CHECK ###### SOFTWARE CHECK ###### SOFTWARE CHECK
######################################################################################################################################################








##################################################
# Check for required software...		 #
##################################################

mencoder_bin=`which mencoder | grep -c "mencoder"`



###### check for mencoder (also requires 'zenity')
if [ $mencoder_bin -eq "0" ]; then
zenity --error --title="Error - Missing Software" \
 --text="You do not have the mencoder package installed
Please install it in order to use this script.
Make sure that the Multiverse repositories are enabled and
then type: 'sudo apt-get install mencoder' at a terminal."
exit
fi








######################################################################################################################################################
###### CHOOSE TV TYPE ###### CHOOSE TV TYPE ###### CHOOSE TV TYPE ###### CHOOSE TV TYPE ###### CHOOSE TV TYPE ###### CHOOSE TV TYPE ###### CHOOSE TV TYPE
######################################################################################################################################################








##################################################
# What type of TV TYPE do you want?		 #
##################################################

###### you can edit these entries to suit
title="Which TV type do you want ?"
tv_type=`zenity  --width="480" --height="300" --title="$title" --list --radiolist --column="Click Here" \
	--column="Channel" --column="Description" \
	FALSE "DVB_RECORD" "Records dvb tv"\
	FALSE "ANALOG_RECORD" "Records analog tv"\
	FALSE "DVB_TV" "Watch dvb tv through mplayer"\
	TRUE "ANALOG_TV" "Watch analog tv through mplayer"\
	FALSE "ANALOG_TV1" "Watch analog tv through tvtime 1"\
	FALSE "ANALOG_TV2" "Watch analog tv through tvtime 2"\
	FALSE "ANALOG_TV3" "Watch analog tv through tvtime 3"\
	| sed 's/ max//g' `
echo "$tv_type chosen as the channel to record."



###### user must select a target type (Check if they cancelled)
if [ ! "$tv_type" ]; then
	zenity --error --title="Error" --text="You must select a TV type!"
	exit
fi








######################################################################################################################################################
###### TV TYPES ###### TV TYPES ###### TV TYPES ###### TV TYPES ###### TV TYPES ###### TV TYPES ###### TV TYPES ###### TV TYPES ###### TV TYPES ######
######################################################################################################################################################








if [ "$tv_type" = "DVB_RECORD" ]; then

	##################################################
	# RECORD DVB TV					 #
	##################################################



	###### Which DVB TV Channel? ######



	###### YOU NEED TO EDIT THIS SECTION FOR YOUR ENVIRONMENT
	# just change the channel names to reflect your channels.conf file
	# ensure there are no spaces in channel names here or in your channels.conf file
	# can scan dvb channels and create this by:
	# sudo scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB > ~/.mplayer/channels.conf
	title="Which DVB-T Channel do you want to record ?"
	dchan_type=`zenity  --width="380" --height="500" --title="$title" --list --radiolist --column="Click Here" \
		--column="Channel" --column="Description" \
		TRUE "WSYX-DT" "" \
		FALSE "MYTV" "" \
		FALSE "WCMH-DT" "" \
		FALSE "RTN" "" \
		FALSE "WBNSTV" "" \
		FALSE "WBNSTV2" "" \
		FALSE "WSFJ-TBN" "" \
		FALSE "WTTE-DT" "" \
		FALSE "WOSU-HD" "" \
		FALSE "WOSU-D1" "" \
		FALSE "WOSU-D2" "" \
		FALSE "0005" "" \
		FALSE "0008" "" \
		FALSE "0009" "" \
		FALSE "WWHO-DT" "" \
		FALSE "Custom" "Input your own channel: 'NBC'"\
		| sed 's/ max//g' `
	echo "$dchan_type chosen as the channel to record."



	###### user must select a target type (Check if they cancelled)
	if [ ! "$dchan_type" ]; then
		zenity --error --title="Error" --text="You must select a Channel!"
		exit
	fi



	###### How Long Do You Want To Record? ######



	###### how long?
	title="How long do you want to record for ?"
	time_type=`zenity  --width="380" --height="500" --title="$title" --list --radiolist --column="Click Here" \
		--column="Record Time" --column="Description" \
		TRUE "00:00:20" "20 seconds for testing" \
		FALSE "00:01:00" "1 minute" \
		FALSE "00:05:00" "5 minutes" \
		FALSE "00:10:00" "10 minutes" \
		FALSE "00:15:00" "15 minutes" \
		FALSE "00:30:00" "30 minutes" \
		FALSE "00:45:00" "45 minutes" \
		FALSE "01:00:00" "1 hour" \
		FALSE "01:15:00" "1:15 minutes" \
		FALSE "01:30:00" "1:30 minutes" \
		FALSE "01:45:00" "1:45 minutes" \
		FALSE "02:00:00" "2 hours" \
		FALSE "02:15:00" "2:15 minutes" \
		FALSE "02:30:00" "2:30 minutes" \
		FALSE "02:45:00" "2:45 minutes" \
		FALSE "03:00:00" "3 hours" \
		FALSE "03:15:00" "3:15 minutes" \
		FALSE "03:30:00" "3:30 minutes" \
		FALSE "03:45:00" "3:45 minutes" \
		FALSE "04:00:00" "4 hours" \
		FALSE "04:15:00" "4:15 minutes" \
		FALSE "04:30:00" "4:30 minutes" \
		FALSE "04:45:00" "4:45 minutes" \
		FALSE "05:00:00" "5 hours" \
		FALSE "05:15:00" "5:15 minutes" \
		FALSE "05:30:00" "5:30 minutes" \
		FALSE "05:45:00" "5:45 minutes" \
		FALSE "06:00:00" "6 hours" \
		FALSE "06:15:00" "6:15 minutes" \
		FALSE "06:30:00" "6:30 minutes" \
		FALSE "06:45:00" "6:45 minutes" \
		FALSE "07:00:00" "7 hours" \
		FALSE "07:15:00" "7:15 minutes" \
		FALSE "07:30:00" "7:30 minutes" \
		FALSE "07:45:00" "7:45 minutes" \
		FALSE "08:00:00" "8 hours" \
		FALSE "08:15:00" "8:15 minutes" \
		FALSE "08:30:00" "8:30 minutes" \
		FALSE "08:45:00" "8:45 minutes" \
		FALSE "09:00:00" "9 hours" \
		FALSE "09:15:00" "9:15 minutes" \
		FALSE "09:30:00" "9:30 minutes" \
		FALSE "09:45:00" "9:45 minutes" \
		FALSE "10:00:00" "10 hours" \
		FALSE "10:15:00" "10:15 minutes" \
		FALSE "10:30:00" "10:30 minutes" \
		FALSE "10:45:00" "10:45 minutes" \
		FALSE "11:00:00" "11 hours" \
		FALSE "11:15:00" "11:15 minutes" \
		FALSE "11:30:00" "11:30 minutes" \
		FALSE "11:45:00" "11:45 minutes" \
		FALSE "12:00:00" "12 hours" \
		FALSE "12:15:00" "12:15 minutes" \
		FALSE "12:30:00" "12:30 minutes" \
		FALSE "12:45:00" "12:45 minutes" \
		FALSE "13:00:00" "13 hours" \
		FALSE "13:15:00" "13:15 minutes" \
		FALSE "13:30:00" "13:30 minutes" \
		FALSE "13:45:00" "13:45 minutes" \
		FALSE "14:00:00" "14 hours" \
		FALSE "14:15:00" "14:15 minutes" \
		FALSE "14:30:00" "14:30 minutes" \
		FALSE "14:45:00" "14:45 minutes" \
		FALSE "15:00:00" "15 hours" \
		FALSE "15:15:00" "15:15 minutes" \
		FALSE "15:30:00" "15:30 minutes" \
		FALSE "15:45:00" "15:45 minutes" \
		FALSE "16:00:00" "16 hours" \
		FALSE "16:15:00" "16:15 minutes" \
		FALSE "16:30:00" "16:30 minutes" \
		FALSE "16:45:00" "16:45 minutes" \
		FALSE "17:00:00" "17 hours" \
		FALSE "17:15:00" "17:15 minutes" \
		FALSE "17:30:00" "17:30 minutes" \
		FALSE "17:45:00" "17:45 minutes" \
		FALSE "18:00:00" "18 hours" \
		FALSE "18:15:00" "18:15 minutes" \
		FALSE "18:30:00" "18:30 minutes" \
		FALSE "18:45:00" "18:45 minutes" \
		FALSE "19:00:00" "19 hours" \
		FALSE "19:15:00" "19:15 minutes" \
		FALSE "19:30:00" "19:30 minutes" \
		FALSE "19:45:00" "19:45 minutes" \
		FALSE "20:00:00" "20 hours" \
		FALSE "20:15:00" "20:15 minutes" \
		FALSE "20:30:00" "20:30 minutes" \
		FALSE "20:45:00" "20:45 minutes" \
		FALSE "21:00:00" "21 hours" \
		FALSE "21:15:00" "21:15 minutes" \
		FALSE "21:30:00" "21:30 minutes" \
		FALSE "21:45:00" "21:45 minutes" \
		FALSE "22:00:00" "22 hours" \
		FALSE "22:15:00" "22:15 minutes" \
		FALSE "22:30:00" "22:30 minutes" \
		FALSE "22:45:00" "22:45 minutes" \
		FALSE "23:00:00" "23 hours" \
		FALSE "23:15:00" "23:15 minutes" \
		FALSE "23:30:00" "23:30 minutes" \
		FALSE "23:45:00" "23:45 minutes" \
		FALSE "24:00:00" "24 hours" \
		| sed 's/ max//g' `
	echo "$time_type chosen as the record time."



	###### user must select a target type (Check if they cancelled)
	if [ ! "$time_type" ]; then
		zenity --error --title="Error" --text="You must select a Time!"
		exit
	fi



	###### Choose a Filename? ######



	###### user must enter a filename
	title="Please enter a filename for your recording, no spaces"
	file_name=`zenity  --width="480" --height="150" --title="$title" --entry`
	echo "$file_name entered as the file name."



	###### user must select a target type (Check if they cancelled)
	if [ ! "$file_name" ]; then
		zenity --error --title="Error" --text="You must enter a Filename!"
		exit
	fi



	###### Select the Quality of Your Recording? ######



	###### video quality?
	title="What video quality do you want to record at ?"
	qual_type_video=`zenity  --width="380" --height="380" --title="$title" --list --radiolist --column="Click Here" \
		--column="Record Quality" --column="Description" \
		FALSE "500" "Passable Quality"\
		FALSE "900" "OK Quality"\
		FALSE "1100" "VHS Quality"\
		FALSE "1300" "SVHS Quality"\
		FALSE "1500" "VCD Quality"\
		TRUE "1600" "MY Quality"\
		FALSE "1800" "SVCD Quality" \
		FALSE "2000" "Very Good Quality"\
		FALSE "2500" "High Quality" \
		FALSE "3000" "Excellent Quality"\
		FALSE "MPEG-TS" "Raw dvb in ts format"\
		| sed 's/ max//g' `
	echo "$qual_type_video chosen as the encoding video quality."



	###### video - user must select a target type (Check if they cancelled)
	if [ ! "$qual_type_video" ]; then
		zenity --error --title="Error" --text="You must select an encoding video quality!"
		exit
	fi



	###### audio quality?
	title="What audio quality do you want to record at ?"
	qual_type_audio=`zenity  --width="380" --height="380" --title="$title" --list --radiolist --column="Click Here" \
		--column="Record Quality" --column="Description" \
		FALSE "48" "Very Low Quality"\
		FALSE "64" "Low Quality"\
		FALSE "128" "OK Quality"\
		FALSE "160" "Medium Quality"\
		TRUE "192" "MY Quality"\
		FALSE "224" "High Quality"\
		FALSE "256" "Very High Quality" \
		FALSE "320" "Excellent Quality"\
		| sed 's/ max//g' `
	echo "$qual_type_audio chosen as the encoding audio quality."



	###### audio - user must select a target type (Check if they cancelled)
	if [ ! "$qual_type_audio" ]; then
		zenity --error --title="Error" --text="You must select an encoding audio quality!"
		exit
	fi



	###### Start Time, Now or a Set Time Later? ######



	###### date-time timer
	# enter required time:
	title="Please enter a start time..."
	starttime=`zenity  --width="480" --height="150" --title="$title" --entry --entry-text="now" --text="Enter Start Time in 00:00 format
	or click 'OK' for immediate start"`
	echo "$starttime entered as the start time."
	curtime=$(date --utc --date now +%s)
	echo "$curtime entered as the current time."
	righttime=$(date --utc --date $starttime +%s)
	echo "$righttime entered as the start time."
	# this bit copes with the starting time for the encode
	# beginning after midnight the following day
	if (($righttime<$curtime)); then
	     newtime=$(($righttime+86400))
	else
	     newtime=$righttime
	fi
	waittime=$(($newtime - $curtime))
	echo "$waittime entered as time to wait before encoding starts"



	###### user must select a target type (Check if they cancelled)
	if [ ! "$newtime" ]; then
		zenity --error --title="Error" --text="You must enter a Start Time!"
		exit
	fi
	echo Channel= $dchan_type
	echo Filename= $file_name
	echo Encode length= $time_type
	echo Quality of encode= $qual_type_video
	echo Quality of encode= $qual_type_audio
	sleep $waittime



	###### The Actual DVB Video Encoding? ######



	###### video encoding DVB
	# YOU NEED TO EDIT THIS SECTION FOR YOUR ENVIRONMENT
	if [ "$qual_type_video" = "MPEG-TS" ]; then
		mencoder dvb://$dchan_type -ovc copy -oac copy -o $HOME/Temp/$file_name.mpg -endpos $time_type | zenity --progress --percentage=0 --title="DVB Recording Script" --text="Processing Video...
		$file_name"
	elif [ "$dchan_type" = "Custom" ]; then
		# custom channel
		custom_dchannel="Please enter custom digital channel, no spaces"
		dchan_type_custom=`zenity  --width="480" --height="150" --title="$custom_dchannel" --entry`
		echo "$dchan_type_custom entered as the dvb channel."
		mencoder dvb://$dchan_type_custom -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=$qual_type_video:vhq:v4mv:keyint=250 -vf pp=de,pullup,softskip,scale -zoom -xy 624 -oac mp3lame -lameopts abr:br=$qual_type_audio:vol=2 -ffourcc xvid -o $HOME/Temp/$file_name.avi -endpos $time_type | zenity --progress --percentage=0 --title="DVB Recording Script" --text="Processing Video...
		$file_name"
	else
		mencoder dvb://$dchan_type -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=$qual_type_video:vhq:v4mv:keyint=250 -vf pp=de,pullup,softskip,scale -zoom -xy 624 -oac mp3lame -lameopts abr:br=$qual_type_audio:vol=2 -ffourcc xvid -o $HOME/Temp/$file_name.avi -endpos $time_type | zenity --progress --percentage=0 --title="DVB Recording Script" --text="Processing Video...
		$file_name"
	fi



elif [ "$tv_type" = "ANALOG_RECORD" ]; then

	##################################################
	# RECORD ANALOG TV				 #
	##################################################



	###### Which Analog TV Channel? ######



	###### YOU NEED TO EDIT THIS SECTION FOR YOUR ENVIRONMENT
	# just change the channel names to reflect your analog channels list
	# you need to keep the "31-BBC1" style and format, if applicable.
	# this is "channelnumber-channelname"
	# can scan analog channels and tune in by (at least with tvtime):
	# tvtime-scanner
	title="Which Analog Channel do you want to record ?"
	achan_type=`zenity  --width="380" --height="500" --title="$title" --list --radiolist --column="Click Here" \
		--column="Channel" --column="Description" \
		TRUE "Composite" "Records from Composite Input" \
		FALSE "SVIDEO" "Records from S-Video Input" \
		FALSE "1" ""\
		FALSE "2" ""\
		FALSE "3" ""\
		FALSE "4" ""\
		FALSE "5" ""\
		FALSE "6" ""\
		FALSE "7" ""\
		FALSE "8" ""\
		FALSE "9" ""\
		FALSE "10" ""\
		FALSE "11" ""\
		FALSE "12" ""\
		FALSE "13" ""\
		FALSE "14" ""\
		FALSE "15" ""\
		FALSE "16" ""\
		FALSE "17" ""\
		FALSE "18" ""\
		FALSE "19" ""\
		FALSE "20" ""\
		FALSE "21" ""\
		FALSE "22" ""\
		FALSE "23" ""\
		FALSE "24" ""\
		FALSE "25" ""\
		FALSE "26" ""\
		FALSE "27" ""\
		FALSE "28" ""\
		FALSE "29" ""\
		FALSE "30" ""\
		FALSE "31" ""\
		FALSE "32" ""\
		FALSE "33" ""\
		FALSE "34" ""\
		FALSE "35" ""\
		FALSE "36" ""\
		FALSE "37" ""\
		FALSE "38" ""\
		FALSE "39" ""\
		FALSE "40" ""\
		FALSE "41" ""\
		FALSE "42" ""\
		FALSE "43" ""\
		FALSE "44" ""\
		FALSE "45" ""\
		FALSE "46" ""\
		FALSE "47" ""\
		FALSE "48" ""\
		FALSE "49" ""\
		FALSE "50" ""\
		FALSE "51" ""\
		FALSE "52" ""\
		FALSE "53" ""\
		FALSE "54" ""\
		FALSE "55" ""\
		FALSE "56" ""\
		FALSE "57" ""\
		FALSE "58" ""\
		FALSE "59" ""\
		FALSE "60" ""\
		FALSE "61" ""\
		FALSE "62" ""\
		FALSE "63" ""\
		FALSE "64" ""\
		FALSE "65" ""\
		FALSE "66" ""\
		FALSE "67" ""\
		FALSE "68" ""\
		FALSE "69" ""\
		FALSE "70" ""\
		FALSE "71" ""\
		FALSE "72" ""\
		FALSE "73" ""\
		FALSE "74" ""\
		FALSE "75" ""\
		FALSE "76" ""\
		FALSE "77" ""\
		FALSE "78" ""\
		FALSE "79" ""\
		FALSE "80" ""\
		FALSE "81" ""\
		FALSE "82" ""\
		FALSE "83" ""\
		FALSE "84" ""\
		FALSE "85" ""\
		FALSE "86" ""\
		FALSE "87" ""\
		FALSE "88" ""\
		FALSE "89" ""\
		FALSE "90" ""\
		FALSE "91" ""\
		FALSE "92" ""\
		FALSE "93" ""\
		FALSE "94" ""\
		FALSE "95" ""\
		FALSE "96" ""\
		FALSE "97" ""\
		FALSE "98" ""\
		FALSE "99" ""\
		FALSE "100" ""\
		FALSE "101" ""\
		FALSE "102" ""\
		FALSE "103" ""\
		FALSE "104" ""\
		FALSE "105" ""\
		FALSE "106" ""\
		FALSE "107" ""\
		FALSE "108" ""\
		FALSE "109" ""\
		FALSE "110" ""\
		FALSE "111" ""\
		FALSE "112" ""\
		FALSE "113" ""\
		FALSE "114" ""\
		FALSE "115" ""\
		FALSE "116" ""\
		FALSE "117" ""\
		FALSE "118" ""\
		FALSE "119" ""\
		FALSE "120" ""\
		FALSE "121" ""\
		FALSE "122" ""\
		FALSE "123" ""\
		FALSE "124" ""\
		FALSE "125" ""\
		FALSE "Custom" "Input your own channel: '234'"\
		| sed 's/ max//g' `
	echo "$achan_type chosen as the channel to record."



	###### user must select a target type (Check if they cancelled)
	if [ ! "$achan_type" ]; then
		zenity --error --title="Error" --text="You must select a Channel!"
		exit
	fi



	###### How Long Do You Want To Record? ######



	###### how long?
	title="How long do you want to record for ?"
	time_type=`zenity  --width="380" --height="500" --title="$title" --list --radiolist --column="Click Here" \
		--column="Record Time" --column="Description" \
		TRUE "00:00:20" "20 seconds for testing" \
		FALSE "00:01:00" "1 minute" \
		FALSE "00:05:00" "5 minutes" \
		FALSE "00:10:00" "10 minutes" \
		FALSE "00:15:00" "15 minutes" \
		FALSE "00:30:00" "30 minutes" \
		FALSE "00:45:00" "45 minutes" \
		FALSE "01:00:00" "1 hour" \
		FALSE "01:15:00" "1:15 minutes" \
		FALSE "01:30:00" "1:30 minutes" \
		FALSE "01:45:00" "1:45 minutes" \
		FALSE "02:00:00" "2 hours" \
		FALSE "02:15:00" "2:15 minutes" \
		FALSE "02:30:00" "2:30 minutes" \
		FALSE "02:45:00" "2:45 minutes" \
		FALSE "03:00:00" "3 hours" \
		FALSE "03:15:00" "3:15 minutes" \
		FALSE "03:30:00" "3:30 minutes" \
		FALSE "03:45:00" "3:45 minutes" \
		FALSE "04:00:00" "4 hours" \
		FALSE "04:15:00" "4:15 minutes" \
		FALSE "04:30:00" "4:30 minutes" \
		FALSE "04:45:00" "4:45 minutes" \
		FALSE "05:00:00" "5 hours" \
		FALSE "05:15:00" "5:15 minutes" \
		FALSE "05:30:00" "5:30 minutes" \
		FALSE "05:45:00" "5:45 minutes" \
		FALSE "06:00:00" "6 hours" \
		FALSE "06:15:00" "6:15 minutes" \
		FALSE "06:30:00" "6:30 minutes" \
		FALSE "06:45:00" "6:45 minutes" \
		FALSE "07:00:00" "7 hours" \
		FALSE "07:15:00" "7:15 minutes" \
		FALSE "07:30:00" "7:30 minutes" \
		FALSE "07:45:00" "7:45 minutes" \
		FALSE "08:00:00" "8 hours" \
		FALSE "08:15:00" "8:15 minutes" \
		FALSE "08:30:00" "8:30 minutes" \
		FALSE "08:45:00" "8:45 minutes" \
		FALSE "09:00:00" "9 hours" \
		FALSE "09:15:00" "9:15 minutes" \
		FALSE "09:30:00" "9:30 minutes" \
		FALSE "09:45:00" "9:45 minutes" \
		FALSE "10:00:00" "10 hours" \
		FALSE "10:15:00" "10:15 minutes" \
		FALSE "10:30:00" "10:30 minutes" \
		FALSE "10:45:00" "10:45 minutes" \
		FALSE "11:00:00" "11 hours" \
		FALSE "11:15:00" "11:15 minutes" \
		FALSE "11:30:00" "11:30 minutes" \
		FALSE "11:45:00" "11:45 minutes" \
		FALSE "12:00:00" "12 hours" \
		FALSE "12:15:00" "12:15 minutes" \
		FALSE "12:30:00" "12:30 minutes" \
		FALSE "12:45:00" "12:45 minutes" \
		FALSE "13:00:00" "13 hours" \
		FALSE "13:15:00" "13:15 minutes" \
		FALSE "13:30:00" "13:30 minutes" \
		FALSE "13:45:00" "13:45 minutes" \
		FALSE "14:00:00" "14 hours" \
		FALSE "14:15:00" "14:15 minutes" \
		FALSE "14:30:00" "14:30 minutes" \
		FALSE "14:45:00" "14:45 minutes" \
		FALSE "15:00:00" "15 hours" \
		FALSE "15:15:00" "15:15 minutes" \
		FALSE "15:30:00" "15:30 minutes" \
		FALSE "15:45:00" "15:45 minutes" \
		FALSE "16:00:00" "16 hours" \
		FALSE "16:15:00" "16:15 minutes" \
		FALSE "16:30:00" "16:30 minutes" \
		FALSE "16:45:00" "16:45 minutes" \
		FALSE "17:00:00" "17 hours" \
		FALSE "17:15:00" "17:15 minutes" \
		FALSE "17:30:00" "17:30 minutes" \
		FALSE "17:45:00" "17:45 minutes" \
		FALSE "18:00:00" "18 hours" \
		FALSE "18:15:00" "18:15 minutes" \
		FALSE "18:30:00" "18:30 minutes" \
		FALSE "18:45:00" "18:45 minutes" \
		FALSE "19:00:00" "19 hours" \
		FALSE "19:15:00" "19:15 minutes" \
		FALSE "19:30:00" "19:30 minutes" \
		FALSE "19:45:00" "19:45 minutes" \
		FALSE "20:00:00" "20 hours" \
		FALSE "20:15:00" "20:15 minutes" \
		FALSE "20:30:00" "20:30 minutes" \
		FALSE "20:45:00" "20:45 minutes" \
		FALSE "21:00:00" "21 hours" \
		FALSE "21:15:00" "21:15 minutes" \
		FALSE "21:30:00" "21:30 minutes" \
		FALSE "21:45:00" "21:45 minutes" \
		FALSE "22:00:00" "22 hours" \
		FALSE "22:15:00" "22:15 minutes" \
		FALSE "22:30:00" "22:30 minutes" \
		FALSE "22:45:00" "22:45 minutes" \
		FALSE "23:00:00" "23 hours" \
		FALSE "23:15:00" "23:15 minutes" \
		FALSE "23:30:00" "23:30 minutes" \
		FALSE "23:45:00" "23:45 minutes" \
		FALSE "24:00:00" "24 hours" \
		| sed 's/ max//g' `
	echo "$time_type chosen as the record time."



	###### user must select a target type (Check if they cancelled)
	if [ ! "$time_type" ]; then
		zenity --error --title="Error" --text="You must select a Time!"
		exit
	fi



	###### Choose a Filename? ######



	###### user must enter a filename
	title="Please enter a filename for your recording, no spaces"
	file_name=`zenity  --width="480" --height="150" --title="$title" --entry`
	echo "$file_name entered as the file name."



	###### user must select a target type (Check if they cancelled)
	if [ ! "$file_name" ]; then
		zenity --error --title="Error" --text="You must enter a Filename!"
		exit
	fi



	###### Select the Quality of Your Recording? ######



	###### video quality?
	title="What video quality do you want to record at ?"
	qual_type_video=`zenity  --width="380" --height="380" --title="$title" --list --radiolist --column="Click Here" \
		--column="Record Quality" --column="Description" \
		FALSE "500" "Passable Quality"\
		FALSE "900" "OK Quality"\
		FALSE "1100" "VHS Quality"\
		FALSE "1300" "SVHS Quality"\
		FALSE "1500" "VCD Quality"\
		TRUE "1600" "MY Quality"\
		FALSE "1800" "SVCD Quality" \
		FALSE "2000" "Very Good Quality"\
		FALSE "2500" "High Quality" \
		FALSE "3000" "Excellent Quality"\
		| sed 's/ max//g' `
	echo "$qual_type_video chosen as the encoding video quality."



	###### video - user must select a target type (Check if they cancelled)
	if [ ! "$qual_type_video" ]; then
		zenity --error --title="Error" --text="You must select an encoding video quality!"
		exit
	fi



	###### audio quality?
	title="What audio quality do you want to record at ?"
	qual_type_audio=`zenity  --width="380" --height="380" --title="$title" --list --radiolist --column="Click Here" \
		--column="Record Quality" --column="Description" \
		FALSE "48" "Very Low Quality"\
		FALSE "64" "Low Quality"\
		FALSE "128" "OK Quality"\
		FALSE "160" "Medium Quality"\
		TRUE "192" "MY Quality"\
		FALSE "224" "High Quality"\
		FALSE "256" "Very High Quality" \
		FALSE "320" "Excellent Quality"\
		| sed 's/ max//g' `
	echo "$qual_type_audio chosen as the encoding audio quality."



	###### audio - user must select a target type (Check if they cancelled)
	if [ ! "$qual_type_audio" ]; then
		zenity --error --title="Error" --text="You must select an encoding audio quality!"
		exit
	fi



	###### Start Time, Now or a Set Time Later? ######



	###### date-time timer
	# enter required time:
	title="Please enter a start time..."
	starttime=`zenity  --width="480" --height="150" --title="$title" --entry --entry-text="now" --text="Enter Start Time in 00:00 format
	or click 'OK' for immediate start"`
	echo "$starttime entered as the start time."
	curtime=$(date --utc --date now +%s)
	echo "$curtime entered as the current time."
	newtime=$(date --utc --date $starttime +%s)
	echo "$newtime entered as the start time."
	waittime=$(($newtime - $curtime))
	echo "$waittime entered as time to wait before encoding starts"



	###### user must select a target type (Check if they cancelled)
	if [ ! "$newtime" ]; then
		zenity --error --title="Error" --text="You must enter a Start Time!"
		exit
	fi
	echo Channel= $achan_type
	echo Filename= $file_name
	echo Encode length= $time_type
	echo Quality of encode= $qual_type_video
	echo Quality of encode= $qual_type_audio
	sleep $waittime



	###### The Actual Analog Video Encoding? ######



	###### video encoding analog
	# YOU NEED TO EDIT THIS SECTION FOR YOUR ENVIRONMENT
	# In the third script (after "else") just change the
	# chanlist value from us-cable to your chanlist region
	# AND change device (video1) to video0 or whatever if need be
	if [ "$achan_type" = "Composite" ]; then
		input_type=1
		mencoder -tv driver=v4l2:device=/dev/video1:input=$input_type:norm=ntsc:alsa=1:adevice=hw.1:audiorate=48000:immediatemode=0:amode=1 tv:// -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=$qual_type_video:vhq:v4mv:keyint=250 -vf pp=de,pullup,softskip -oac mp3lame -lameopts abr:br=$qual_type_audio:vol=2 -ffourcc xvid -o $HOME/Temp/$file_name.avi -endpos $time_type | zenity --progress --percentage=0 --title="COMPOSITE Recording Script" --text="Processing Video...
		$file_name"
	elif [ "$achan_type" = "SVIDEO" ]; then
		input_type=2
		mencoder -tv driver=v4l2:device=/dev/video1:input=$input_type:norm=ntsc:alsa=1:adevice=hw.1:audiorate=48000:immediatemode=0:amode=1 tv:// -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=$qual_type_video:vhq:v4mv:keyint=250 -vf pp=de,pullup,softskip -oac mp3lame -lameopts abr:br=$qual_type_audio:vol=2 -ffourcc xvid -o $HOME/Temp/$file_name.avi -endpos $time_type | zenity --progress --percentage=0 --title="SVIDEO Recording Script" --text="Processing Video...
		$file_name"
	elif [ "$achan_type" = "Custom" ]; then
		# custom channel
		custom_achannel="Please enter custom analog channel, no spaces"
		achan_type_custom=`zenity  --width="480" --height="150" --title="$custom_achannel" --entry`
		echo "$achan_type_custom entered as the analog channel."
		mencoder -tv driver=v4l2:device=/dev/video1:input=0:norm=ntsc:chanlist=us-cable:channel=$achan_type_custom:alsa=1:adevice=hw.1:audiorate=48000:immediatemode=0:amode=1 tv:// -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=$qual_type_video:vhq:v4mv:keyint=250 -vf pp=de,pullup,softskip -oac mp3lame -lameopts abr:br=$qual_type_audio:vol=2 -ffourcc xvid -o $HOME/Temp/$file_name.avi -endpos $time_type | zenity --progress --percentage=0 --title="ANALOG TV Recording Script" --text="Processing Video...
		$file_name"
	else
		mencoder -tv driver=v4l2:device=/dev/video1:input=0:norm=ntsc:chanlist=us-cable:channel=$achan_type:alsa=1:adevice=hw.1:audiorate=48000:immediatemode=0:amode=1 tv:// -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=$qual_type_video:vhq:v4mv:keyint=250 -vf pp=de,pullup,softskip -oac mp3lame -lameopts abr:br=$qual_type_audio:vol=2 -ffourcc xvid -o $HOME/Temp/$file_name.avi -endpos $time_type | zenity --progress --percentage=0 --title="ANALOG TV Recording Script" --text="Processing Video...
		$file_name"
	fi



elif [ "$tv_type" = "DVB_TV" ]; then

	##################################################
	# WATCH DVB TV (through MPlayer)		 #
	##################################################

	# YOU NEED TO EDIT THIS SECTION FOR YOUR ENVIRONMENT
	# gives you list of your current dvb channels
	dchan_type=$(zenity --entry --text="What digital tv channel would you like to watch?:

	ATSC/NTSC local digital channel list:
	WSYX-DT
	MYTV
	WCMH-DT
	RTN
	WBNSTV
	WBNSTV2
	WSFJ-TBN
	WTTE-DT
	WOSU-HD
	WOSU-D1
	WOSU-D2
	0005
	0008
	0009
	WWHO-DT ")
	mplayer dvb://$dchan_type



	###### user must select a target type (Check if they cancelled)
	if [ ! "$dchan_type" ]; then
		zenity --error --title="Error" --text="You must select a Channel!"
		exit
	fi



elif [ "$tv_type" = "ANALOG_TV" ]; then

	##################################################
	# WATCH Analog TV (through MPlayer)		 #
	##################################################

	achan_type=$(zenity --entry --text="What analog/cable tv channel would you like to watch?: ")
	sh -c "mplayer -tv driver=v4l2:device=/dev/video1:input=0:norm=ntsc:chanlist=us-cable:channel=$achan_type tv:// & sox -r 48000 -t alsa hw:1,0 -t alsa hw:0,0"



	###### user must select a target type (Check if they cancelled)
	if [ ! "$achan_type" ]; then
		zenity --error --title="Error" --text="You must select a Channel!"
		exit
	fi



elif [ "$tv_type" = "ANALOG_TV1" ]; then

	##################################################
	# WATCH Analog TV (through TVtime 1)		 #
	##################################################

	sox -s -r 32000 -c 2 -t alsa hw:1,0 -s -r 32000 -c 2 -t alsa hw:0,0 &
	tvtime
	t=`pidof sox`;
	kill $t;



elif [ "$tv_type" = "ANALOG_TV2" ]; then

	##################################################
	# WATCH Analog TV (through TVtime 2)		 #
	##################################################

	sh -c "tvtime & sox -r 48000 -t alsa hw:1,0 -t alsa hw:0,0"



else

	##################################################
	# WATCH Analog TV (through TVtime 2)		 #
	##################################################

	# add following line via visudo or put "snd_mixer_oss" in rc.conf MODULES array
	# %wheel ALL=(root) NOPASSWD: /sbin/modprobe snd_mixer_oss
	sudo modprobe snd_mixer_oss
	# modify string for your language regarding aplay -l
	SEARCHSTRING="Karte"
	CARDS="$(aplay -l | grep -i "$SEARCHSTRING" | cut -d \: -f1 | cut -d \  -f2 | sort -u)"
	LASTCARD=$(echo $CARDS | rev | cut -d " " -f1)
	TVCARD=$((LASTCARD+1))
	for i in $(seq 0 $LASTCARD) ; do
	    aplay -l | grep "$SEARCHSTRING ${i}:" >/dev/null
	    [ $? = 1 ] && TVCARD=$i
	done
	sox -t alsa hw:$TVCARD,0 -t alsa default --no-show-progress &
	/usr/bin/tvtime "$@"
	# close sox session
	kill %%﻿



fi








######################################################################################################################################################
#----- SCRIPT ENDS HERE ------ SCRIPT ENDS HERE ------ SCRIPT ENDS HERE ------ SCRIPT ENDS HERE ------ SCRIPT ENDS HERE ------ SCRIPT ENDS HERE ------
######################################################################################################################################################








exit








######################################################################################################################################################
################################### MY SCRIPT FILE ################################### MY SCRIPT FILE ################################### MY SCRIPT FILE
#####################################################################################################################################################

