#!/bin/bash



##################################################
# Random-Gnome3-Wallpaper.sh 			 #
# Creator:          	Inameiname		 #
# Major Contributor:    hwttdz 			 #
#			(did most of work :P)	 #
# Version:           	1.1			 #
# Last modified:       	18 October 2011		 #
# License:          	GPLv3+			 #
#						 #
# Descripton:					 #
# Script to randomly set desktop/gdm background  #
# from files in a directory(s) in GNOME3	 #
#						 #
# Requires: sudo-apt get install randomize-lines #
#						 #
# Installation Instructions:			 #
# Put in ~/.gnome2/nemo-scripts directory 	 #
# and right click to run.			 #
# Can also put as startup script in Startup 	 #
# Applications so will run at every startup for  #
# rotating backgrounds				 #
##################################################



###### just add/remove as many directories as wish
# find "/usr/share/backgrounds" "$HOME/Pictures/Backgrounds" -type f \( -name "*.bmp" -or -name "*.BMP" -or -name "*.jpeg" -or -name "*.JPEG" -or -name "*.jpg" -or -name "*.JPG" -or -name "*.png" -or -name "*.PNG" -or -name "*.svg" -or -name "*.SVG" \)|rl|head -n 1|xargs -I{} bash -c "gsettings set org.gnome.desktop.background picture-uri \"file://{}\""

find "/usr/share/backgrounds" "$HOME/Pictures/Backgrounds" -type f \( -name "*.bmp" -or -name "*.BMP" -or -name "*.jpeg" -or -name "*.JPEG" -or -name "*.jpg" -or -name "*.JPG" -or -name "*.png" -or -name "*.PNG" -or -name "*.svg" -or -name "*.SVG" \)|rl|head -n 1|xargs -I{} bash -c "gsettings set org.cinnamon.desktop.background picture-uri \"file://{}\""
