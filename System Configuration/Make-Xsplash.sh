#!/bin/sh
# XSplash Maker Via TheeMahn
# Copyright (c) 2009  Ultimate Edition Team <http://ubuntusoftware.info>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#ChangeLog:

# 1.00 Initial release

	# THE FUTURE
	# ==========
	# get date routine working for changelog and copyright
# 1.04

	# Added Distro logo option
	# Added multiple User selectable animation sequences

# 1.05
	# Fixed conflicting xsplash's with "known" to exist xsplash's
	# Removed testing routine due to additional dependancies

SCRIPT_VERSION=1.05
FNAME="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" 
file=$@
# everything after last '/'
basename=${file%.*}
ext=".deb"
OUTFILE=${basename}${ext}

##Check for zenity - no longer necessary deb handles dependancies
#if [ ! -e "/usr/bin/zenity" ]; then
#	gkgksudo apt-get install -y --force-yes zenity
#fi


PROGRESS=0
#FNAME=$@
 
#Resolution Subroutines
Res1(){
convert $file -resize '800X600!' -quality 100 -strip ${basename}/usr/share/images/xsplash/bg_640x400.jpg | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 800 X 600..."
convert $file -resize '1024X768!' -quality 100 -strip ${basename}/usr/share/images/xsplash/bg_1024x768.jpg | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 1024 X 768..."
convert $file -resize '1280X1024!' -quality 100 -strip ${basename}/usr/share/images/xsplash/bg_1280x1024.jpg | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 1280 X 1024..."
convert $file -resize '1440X900!' -quality 100 -strip ${basename}/usr/share/images/xsplash/bg_1440x900.jpg | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 1440 X 900..."
convert $file -resize '1680X1050!' -quality 100 -strip ${basename}/usr/share/images/xsplash/bg_1680x1050.jpg | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 1680 X 1050..."
convert $file -resize '1920X1220!' -quality 100 -strip ${basename}/usr/share/images/xsplash/bg_1920x1220.jpg | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 1920 X 1220..."
convert $file -resize '2560X1600!' -quality 100 -strip ${basename}/usr/share/images/xsplash/bg_2560x1600.jpg | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 2560 X 1600..."

#Logo - to do add conditional routine incase the user did not select a logo
if [ "$LOGO" = "Ubuntu" ]; then
	cp /usr/share/ultimate_edition/Xsplash/Ubuntu/logo_xtra_large.png ${basename}/usr/share/images/xsplash/
	cp /usr/share/ultimate_edition/Xsplash/Ubuntu/logo_large.png ${basename}/usr/share/images/xsplash/
	cp /usr/share/ultimate_edition/Xsplash/Ubuntu/logo_medium.png ${basename}/usr/share/images/xsplash/
	cp /usr/share/ultimate_edition/Xsplash/Ubuntu/logo_small.png ${basename}/usr/share/images/xsplash/
else
	convert $LOGO -resize '75%' -quality 100 -strip ${basename}/usr/share/images/xsplash/logo_large.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing Logo scale Large..."
	convert $LOGO -resize '50%' -quality 100 -strip ${basename}/usr/share/images/xsplash/logo_medium.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing Logo scale Medium..."
	convert $LOGO -resize '25%' -quality 100 -strip ${basename}/usr/share/images/xsplash/logo_small.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing Logo scale Medium..."
	cp $LOGO ${basename}/usr/share/images/xsplash/logo_xtra_large.png
fi
}

Header(){
#Grab Throbbers, fonts & C code
cp /usr/share/ultimate_edition/Xsplash/$ANIMATION/* ${basename}/usr/share/images/xsplash/
}

Debianize(){
input=$(zenity --window-icon=/usr/share/ultimate_edition/logo.png --text "Author name?" --entry)
retval=$?
case $retval in
0)
AUTHOR=$input;;
1)
gksudo "rm -R ${basename}"
exit 0;;
esac
input=$(zenity --window-icon=/usr/share/ultimate_edition/logo.png --text "Description?" --entry)
retval=$?
case $retval in
0)
DESCRIPTION=$input;;
1)
gksudo "rm -R ${basename}"
exit 0;;
esac
input=$(zenity --window-icon=/usr/share/ultimate_edition/logo.png --text "Your E-mail address?" --entry)
retval=$?
case $retval in
0)
EMAIL=$input;;
1)
gksudo "rm -R ${basename}"
exit 0;;
esac
#output control file
#$DATE=`date --rfc-2822`<<-needs fixed
echo "Package: ${basename}
Priority: optional
Conflicts: xsplash (<< 0.8), xsplash-artwork, ubuntu-xsplash-artwork, ultimate-edition-xsplash-2.4, ultimate-edition-xmas-2009-xsplash, ultimate-edition-xsplash-2.5
Replaces: xsplash (<< 0.8), xsplash-artwork, ubuntu-xsplash-artwork, ultimate-edition-xsplash-2.4, ultimate-edition-xmas-2009-xsplash, ultimate-edition-xsplash-2.5
Section: gnome
Architecture: all
Depends: xsplash
Version: 1.0.0
Maintainer: $AUTHOR <$EMAIL>
Installed-Size: 7000
Description: XSplash created by $AUTHOR
 .
 $DESCRIPTION.
 .
 for more information please visit http://ultimateedition.info/.">${basename}/DEBIAN/control

#make lintian error free deb

echo "This package was debianized by TheeMahns XSplash Maker by $AUTHOR <$EMAIL>.


Upstream Author: 

    $AUTHOR <$EMAIL>

Copyright: 

    <Copyright (C) 2009 $AUTHOR>

License:

 The following license applies to all code files:

 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this archive are subject to the Mozilla Public License Version
 * 1.1 (the License); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an AS IS basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the GPL), or
 * the GNU Lesser General Public License Version 2.1 or later (the LGPL),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.

 The following license applies to all icons and images:

 This package is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; version 2 dated June, 1991.

 This package is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this package; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301,
 USA.

The Debian packaging is (C) 2009, $AUTHOR <$EMAIL> and
is licensed under the GPL, see /usr/share/common-licenses/GPL.">${basename}/usr/share/doc/${basename}/copyright
echo "${basename} (1.0.0) karmic; urgency=low

  * initial release

 -- $AUTHOR <$EMAIL>  Tue, 23 June 2009 18:20:03 -0500">${basename}/usr/share/doc/${basename}/changelog
gzip -9 ${basename}/usr/share/doc/${basename}/changelog
gksudo chmod 755 ${basename}/DEBIAN/control
gksudo chown -R root:root ${basename}/
gksudo chmod 644 ${basename}/usr/share/images/xsplash/*
gksudo chmod 644 ${basename}/usr/share/doc/${basename}/*
dpkg --build ${basename} | zenity --window-icon=/usr/share/ultimate_edition/logo.png --width=600 --height=100 --progress --pulsate --auto-close --title "Building Deb...";
}

# Begin interaction with end user
ANIMATION="";

`zenity --window-icon=/usr/share/ultimate_edition/logo.png --info --text="This will create a deb in current folder called $OUTFILE you can then install this deb in Karmic+ to replace existing XSplash.  Please note:  The filename must be all lowercase and no numbers.  You can rename the deb to anything you like after it finishes.  Enjoy, TheeMahn" --title="TheeMahns XSplash Maker"`;
ANIMATION="$(zenity --window-icon=/usr/share/ultimate_edition/logo.png  --width=500 --height=280 --title "TheeMahns XSplash Maker" --text "Choose only one animation effect." --list --checklist --column "Select" --column "Animation Effect" false 'Bar' false 'Fire' false 'Rainbow1' false 'Rainbow2' false 'Rainbow3' false 'Rainbow4' false 'Sparkle' false 'Ubuntu')";

echo $ANIMATION

if [ "$ANIMATION" = "" ]; then   
	zenity --error --text="Animation not defined by user.  Please choose a animation to use. Exiting."
	exit 0
fi

#Logo Selection
LOGO="";
DISTLOGO="$(zenity --window-icon=/usr/share/ultimate_edition/logo.png  --width=500 --height=280 --title "TheeMahns XSplash Maker" --text "Distro Logo - Select only one." --list --checklist --column "Select" --column "Distro Logo" false 'Ubuntu' false 'Ultimate_Edition' false 'Debian' false 'Mint' false 'Custom')";

#User is doing custom logo - provide file selection box
case "$DISTLOGO" in
Custom)
	LOGO="$(zenity --file-selection --title='Select Logo file' --filename="")";
;;
Ultimate_Edition)
	LOGO="/usr/share/ultimate_edition/Xsplash/logo.png";
;;
Ubuntu)
	LOGO="Ubuntu";
;;
Debian)
	LOGO="/usr/share/ultimate_edition/Xsplash/debian-logo.png";
;;
Debian)
	LOGO="/usr/share/ultimate_edition/Xsplash/mint-logo.png";
;;
esac

#Create folder structure of deb
mkdir -p ${basename}
mkdir -p ${basename}/DEBIAN/
mkdir -p ${basename}/usr/
mkdir -p ${basename}/usr/share/
mkdir -p ${basename}/usr/share/images/
mkdir -p ${basename}/usr/share/images/xsplash/
mkdir -p ${basename}/usr/share/doc/
mkdir -p ${basename}/usr/share/doc/${basename}/

#Get R done ;)
Header
Res1
Debianize

#Test for deb & Clean up
if [ -f ${basename}.deb ] 
then
	gksudo "rm -R ${basename}"
else
	zenity --error --text="Something has gone wrong, please check the filename and try again.  Leaving the folder ${basename}/ so you can look further into the situation."
fi

#Ask user if they wish to install it and warn about multiple xsplashes
zenity --window-icon=/usr/share/ultimate_edition/logo.png --question --title 'TheeMahns Xsplash Maker' --text "Install the XSplash?  Please note you can only install 1 xsplash and if you wish to replace it you must first uninstall the old one.  This Xsplash can be removed with the following command sudo apt-get remove ${basename}." || exit

gksudo "dpkg -i ${basename}.deb"

