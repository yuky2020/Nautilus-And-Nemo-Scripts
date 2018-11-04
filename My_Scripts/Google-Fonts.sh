#!/bin/bash



##################################################
# 						 #
# Google-Fonts.sh				 #
# Version: 		0.1	 		 #
# Last modified: 	04 November 2011	 #
# License:		GPLv3+			 #
# Creator:		Inameiname		 #
#						 #
# Credit also goes to Michalis Georgiou 	 #
# <mechmg93@gmail.com> for his original		 #
# google-font script and to Andrew  		 #
# http://www.webupd8.org <andrew@webupd8.org> for#
# his further modification of it.		 #
#						 #
# Descripton:					 #
# For those who want an extremely easy method to #
# download and install the entire Google font	 #
# repository.					 #
#						 #
# Installation Instructions:			 #
# Just extract and/or place the script inside 	 #
# your ~/.gnome2/nemo-scripts folder.	 #
# 						 #
##################################################



##################################################
# Ensure This Script is Running in Terminal	 #
##################################################

tty -s; if [ $? -ne 0 ]; then gnome-terminal -e "$0"; exit; fi



##################################################
# Installation of Mercurial Needed for 		 #
# Downloading of Fonts				 #
##################################################

sudo apt-get install mercurial



##################################################
# Setting of Default Directories		 #
##################################################

_hgroot="https://googlefontdirectory.googlecode.com/hg/"
_hgrepo="googlefontdirectory"
_hgoutdir="google-fonts"



##################################################
# Google Font Choice Decision			 #
##################################################

echo "
"
echo -n "What do you want to do with the fonts from Google
once they are downloaded?:

(1)  Download Only (and keep all fonts in a single folder)
(2)  Download Only (and keep all fonts in separate folders (pure hg copy))
(3)  Download and Install

Press 'Enter' for default (default is '1')...

"
read GOOGLE_FONT_CHOICE



##################################################
# Actual Downloading of the Google Fonts	 #
##################################################

if [ ! -d $HOME/$_hgrepo ] ; then
echo "
"
echo "Connecting to Mercurial server...."
if [ -d $HOME/$_hgrepo ] ; then
	cd $HOME/$_hgrepo
	hg pull -u || return 1
	echo "The local files have been updated."
	cd ..
else
	hg clone $_hgroot $HOME/$_hgrepo || return 1
fi
echo "Mercurial checkout done or server timeout"
echo "
"
else
echo "The directory $HOME/$_hgrepo already exists."
echo ""
echo "No need to redownload all of the Google fonts."
fi



##################################################
# Google Font Choice Selection			 #
##################################################

###### default
if [[ -z $GOOGLE_FONT_CHOICE ]] ; then
	# If no file passed, default to 1
	mkdir -p $HOME/$_hgoutdir/
	find $HOME/$_hgrepo/ -name "*.ttf"|xargs -I{} bash -c "cp -rf \"{}\" $HOME/$_hgoutdir/"
	rm -rf $HOME/$_hgrepo/
fi
###### preset
if [[ $GOOGLE_FONT_CHOICE = 1 ]] ; then
	mkdir -p $HOME/$_hgoutdir/
	find $HOME/$_hgrepo/ -name "*.ttf"|xargs -I{} bash -c "cp -rf \"{}\" $HOME/$_hgoutdir/"
	rm -rf $HOME/$_hgrepo/
fi
if [[ $GOOGLE_FONT_CHOICE = 2 ]] ; then
	mv $HOME/$_hgrepo/ $HOME/$_hgoutdir/
fi
if [[ $GOOGLE_FONT_CHOICE = 3 ]] ; then
	sudo mkdir -p /usr/share/fonts/truetype/google-fonts/
	find $HOME/$_hgrepo/ -name "*.ttf" -exec sudo install -m644 {} /usr/share/fonts/truetype/google-fonts/ \; || return 1
	fc-cache -f > /dev/null
	rm -rf $HOME/$_hgrepo/
fi



##################################################
# Wrap Up					 #
##################################################

echo "
"
echo "done."
echo "
"
read -sn 1 -p "You have finished downloading/installing all the Google Fonts currently available. Press any key to finish...
"
