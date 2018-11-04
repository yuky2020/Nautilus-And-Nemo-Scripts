#!/bin/bash



##################################################
# Random-Gnome3-Wallpaper-2.sh 			 #
# Creator:          	Inameiname		 #
# Version:           	1.0			 #
# Last modified:       	18 October 2011		 #
# License:          	GPLv3+			 #
#						 #
# Descripton:					 #
# Script to randomly set desktop/gdm background  #
# from files in a directory(s) in GNOME3	 #
#						 #
# Installation Instructions:			 #
# Put in ~/.gnome2/nemo-scripts directory 	 #
# and right click to run.			 #
# Can also put as startup script in Startup 	 #
# Applications so will run at every startup for  #
# rotating backgrounds				 #
##################################################



###### Directories Containing Pictures (to add more folders here, just "/path/to/your/folder")
arr[0]="/usr/share/backgrounds"
arr[1]="$HOME/Pictures/Backgrounds"
# arr[2]=
# arr[3]=
# arr[4]=
# arr[5]=
# arr[6]=
# arr[7]=
# arr[8]=
# arr[9]=
# arr[10]=



###### How many picture folders are there? (currently = 2)
rand=$[ $RANDOM % 2 ]



###### Command to select a random folder
DIR=`echo ${arr[$rand]}`



###### Command to select a random file from directory
# The *.* should select only files (ideally, pictures, if that's all that's inside)
PIC=$(ls $DIR/*.* | shuf -n1)



###### Command to set background Image
# gsettings set org.gnome.desktop.background picture-uri "file://$PIC"

gsettings set org.cinnamon.desktop.background picture-uri "file://$PIC"
