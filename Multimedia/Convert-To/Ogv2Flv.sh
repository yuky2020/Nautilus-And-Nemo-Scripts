#!/bin/bash
#################################################################################################
# Nautilus Ogv to Flv Converter script v.1.3							#
# ------------------------------------------							#
#												#
# A frontend for converting .ogg/.ogv files to flv format made with gtk-recordmydesktop. 	#
# Should work just fine for all .ogg/.ogv formats.						#
#												#
# Code put together by Jean-Claude McGeer, Oct 2008 - https://wiki.ubuntu.com/JeanClaude 	#
# This code is licensed under the General Public License as released by the 			#
# Free Software	Foundation. You may use, modify and distribute as long as you use		#
# the GPL2 or later version. 									#
#												#
# This program is distributed in the hope that it will be useful,				#
# but WITHOUT ANY WARRANTY; without even the implied warranty of				#
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the					#
# GNU General Public License for more details.							#
#												#
#################################################################################################
#
# About:
#
# See README.TXT for more details.
#
# Contact:
#
# Please let me know if you've used this script and how it's working out for you and if you experince 
# any problems on gnome-look.org at the project page,  
# http://gnome-look.org/content/show.php/Ogv+to+Flv+Converter?content=90837. 
# No promises that I'll be able to get back to you, but at least I can try to look at the issue.
#
# https://wiki.ubuntu.com/JeanClaude
#
########################################################



#############################
####                     ####
#### DEFAULT SETTINGS!!! ####
####                     ####
#############################

# Here you can set the user specified video settings; useful if you are repeatedly converting videos with the same settings
# that are different to the "default" settings. 
#
# In order to keep the script working, do not change the name or remove quotes. Only change the number itself. 
# For example, lets say I wish to change the default scale from 640x480 to 704x304, I would change the setting
# below from:
#
# user_scale="640x480"; 
# to
# user_scale="704x304";



user_scale="1280x720";		# THIS IS THE DEFAULT VIDEO SCALE, OPTIONS INCLUDE: 
				# -------------------------------------------------
				# 320x240, 640x480, 704x304 (Widescreen), 800x600, 
				# 1024x768, 1280x720 (HD720) and 1920x1080 (HD1080)



user_vbitrate="1024";		# THIS IS THE VIDEO BITRATE
				# -------------------------------------------------
				# 128, 200, 256, 300, 400, 512, 600, 800, 1024, 1200, 1800



user_abitrate="11025";		# THIS IS THE AUDIO BITRATE
				# -------------------------------------------------
				# 11025, 22050, 32000, 44100



##### DO NOT EDIT BELOW THIS LINE #####





















##### DO NOT EDIT BELOW THIS LINE #####



###################################
###################################
# LETS MAKE SURE ffmpeg IS INSTALLED
ffmpeg_exists=`which ffmpeg | grep -c "ffmpeg"`

	# GIVE ERROR IF ffmpeg IS NOT INSTALLED!
	if [ $ffmpeg_exists -eq 0 ]; then
		ffmpeg_error=`zenity --error --title="Error - Converter Required!" --text="You need to have ffmpeg installed to use this script.\n\nGoing to install ffmpeg for you. If this fails please enable Universe repositories and type 'sudo apt-get install ffmpeg' in a terminal to install."`;

		install_ffmpeg=`gksudo apt-get install ffmpeg | zenity --progress --pulsate --title "Installing files..." --text "Installing ffmpeg." --auto-close`;
	fi
	
	# LETS MAKE SURE ffmpeg IS INSTALLED AGAIN. IF IT DOESN'T, ERROR AGAIN AND EXIT, ELSE JUST CONTINUE. 
	# THIS SECTION PROBABLY NEEDS TO BE REVISED; BUT WORKS.
	ffmpeg_exists2=`which ffmpeg | grep -c "ffmpeg"`

	if [ $ffmpeg_exists2 -eq 0 ]; then
		zenity --error --title="Error!" --text="ERROR: Something went wrong. Please try to manually install ffmpeg with 'sudo apt-get install ffmpeg'.";
		exit;
	fi








####################################
####################################
### WE NEED TO MAKE SURE A FILE IS SELECTED AND THAT THE FILE IS THE ACCEPTED TYPE
	# DETECT MIME TYPE
	mime=`file -bi "$1"`;
	correct_video="0";


	# MAKE SURE FILE IS CORRECT INPUT FORMAT; ogg, ogv, flv, asf, mp4, avi, mkv
	if echo "$1" | grep -q '.ogg'|| echo "$1" | grep -q '.OGG'; then
		echo "File is in .ogg Format"
		video_type="ogg"
		correct_video="1"
	elif echo "$1" | grep -q '.ogv'|| echo "$1" | grep -q '.OGV'; then
		echo "File is in .ogv Format"
		video_type="ogv"
		correct_video="1"
	elif echo "$1" | grep -q '.flv'|| echo "$1" | grep -q '.FLV'; then
		echo "File is in .flv Format"
		video_type="flv"
		correct_video="1"
	elif echo "$1" | grep -q '.asf' || echo "$1" | grep -q '.ASF'; then
		echo "File is in .asf Format"
		video_type="asf"
		correct_video="1"
	elif echo "$1" | grep -q '.mp4'|| echo "$1" | grep -q '.MP4'; then
		echo "File is in .mp4 Format"
		video_type="mp4"
		correct_video="1"
	elif echo "$1" | grep -q '.avi'|| echo "$1" | grep -q '.AVI'; then
		echo "File is in .avi Format"
		video_type="avi"
		correct_video="1"
	elif echo "$1" | grep -q '.mkv'|| echo "$1" | grep -q '.OGV'; then
		echo "File is in .mkv Format"
		video_type="mkv"
		correct_video="1"
	elif [ $1 -eq 0 ]; then
		zenity --error --title="Error" --text="You must select a file to process..."
		exit 1
	elif [ $correct_video -eq 0 ]; then
		zenity --error --title="Error" --text="Please select a valid ogg, ogv, asf, mp4, avi, mkv or flv file for processing."
		exit 1
	else
		zenity --error --title="Error" --text="Unknown error, please try again."
		exit 1
	fi








#################################
#################################
# IF VIDEO FORMAT IS CORRECT, THEN DISPLAY SOME OPTIONS...
if [ $correct_video -eq "1" ]; then
	do_encode="0";


	#################################
	### LET THE USER SELECT OPTIONS 
	option=`zenity --list --radiolist --width="500" --height="210" --title="Use default / saved settings or select your own on the fly?" --column="Check" --column="Option" --column="Description" \
	TRUE "User" "User specified settings" \
	FALSE "Default" "Default options: Resolution = 800x600" \
	FALSE "Select" "Select options for video conversion"`;


	#################################
	### IF USER SPECIFIED IS SELECTED THEN SET OPTIONS SPECIFIED BY USER ABOVE IN THIS FILE...
	if [ "$option" = "User" ]; then
		scale="$user_scale";  	
		vbitrate="$user_vbitrate";	
		abitrate="$user_abitrate";	
		do_encode="1";	
	fi


	#################################
	### IF THE DEFAULT OPTION IS SELECTED THEN SET DEFAULT OPTIONS...
	if [ "$option" = "Default" ]; then
		scale="800x600";  	# 1024x768 - GIVES EXCELLENT QUALITY WITHOUT HUGE FILE SIZE
		vbitrate="1024";	
		abitrate="11025";	
		do_encode="1";	
	fi


	#################################
	### IF THE USER WANTS TO SELECT HIS/HER OWN OPTIONS FOR VIDEO CONVERSION...
	if [ "$option" = "Select" ]; then
		### GIVE RESOLUTION OPTIONS
		scale=`zenity --list --radiolist --width="400" --height="300" --title="Choose Video Scale" \
		--radiolist --column="Check" --column="Size" --column="Description"\
		FALSE "320x240" "" \
		TRUE "640x480" "Fullscreen VGA" \
		FALSE "704x304" "Widescreen" \
		FALSE "800x600" "Fullscreen SVGA"  \
		FALSE "1024x768" ""  \
		FALSE "1280x720" "HD720"  \
		FALSE "1920x1080" "HD1080" `;
		#do_encode="1";


		### GIVE ASPECT OPTIONS
		#aspect=`zenity --list --radiolist --width="400" --height="300" --title="Choose Video Aspect" \
		#--radiolist --column="Check" --column="Aspect" --column="Description"\
		#TRUE "4:3" "Standard Display" \
		#FALSE "16:9" "Widescreen Display"`;
		#do_encode="1";


		### GIVE VIDEO BITRATE OPTIONS
		vbitrate=`zenity --list --radiolist --width="400" --height="300" \
		--title="Choose video bitrate" --radiolist --column="Check" --column="Video Bitrate" \
		FALSE "128" \
		FALSE "200" \
		FALSE "256" \
		FALSE "300" \
		FALSE "400" \
		FALSE "512" \
		FALSE "600" \
		FALSE "800" \
		TRUE "1024" \
		FALSE "1200"`;
		FALSE "1800" \
		#do_encode="1";


		### GIVE AUDIO BITRATE OPTIONS
		abitrate=`zenity --list --radiolist --width="400" --height="300" --title="Choose Audio Bitrate" --radiolist --column="Check" --column="Audio Bitrate" \
		TRUE "11025" \
		FALSE "22050" \
		FALSE "32000" \
		FALSE "44100"`;
		do_encode="1";
	fi
fi







	#################################
	### LET THE USER SELECT OUTPUT FORMAT (AVI or FLV) 
	#option=`zenity --list --radiolist --width="400" --height="200" --title="Output Format" --column="Check" --column="Option" --column="Description" \
	#TRUE "FLV" "FLV - Flash Video"`;
	#FALSE "AVI" "AVI - Audio Video Interleave"`;



		#################################
		#################################
		### LETS ENCODE THE VIDEO!! 
		### THE FOLLOWING CODE SHOULD WORK FOR ALL THE FORMATS ABOVE
		if [[ $do_encode -eq "1" ]]; then


		# NOW CONVERT TO FLV	
		encode_flv=`ffmpeg -i "$1" -s "$scale" -ab 56 -ar "$abitrate" \
		-b "$vbitrate" -r 24 -sameq -f flv -pass 1 "$1".flv \
		| zenity --progress --width="500" --pulsate --title "Converting to FLV..." \
		--text "Converting \"$1\" to FLV format." --auto-close`;




		### succes or error
		if [[ $encode_flv != 0 ]]; then
			zenity --info --title "Success!" --text "Successfully converted \"$1\" to .flv format!";
			echo "Video Conversion Successful!" >> success.txt
			echo "------------------------------------------------" >> success.txt
			echo "The $1 file converted successfully with the following settings." >> success.txt
			echo "" >> success.txt
			echo "Scale: $scale" >> success.txt
			echo "Audio Bitrate: $abitrate" >> success.txt
			echo "Video Bitrate: $vbitrate" >> success.txt
			zenity --text-info --title="-- Results --" --width="400" --height="300" --filename="success.txt"
			rm success.txt
		else
			zenity --error --title "Error!" -- text "An error occured, please try again!";
		fi
fi


### EOF
