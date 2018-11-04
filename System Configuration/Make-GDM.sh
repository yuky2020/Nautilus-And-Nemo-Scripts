#!/bin/sh
# GDM Login Maker Via TheeMahn
# Copyright (c) 2007-2009 Ubuntusoftware Team <http://ubuntusoftware.info>
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
#
# set script version so we can check the server for a newer version see update procedure below.
SCRIPT_VERSION=1.11

##Check for zenity
if [ ! -e "/usr/bin/zenity" ]; then
	gksudo apt-get install -y --force-yes zenity
fi
    zenity --window-icon=/usr/share/ultimate/logo.png --info --text='This script will make a GDM (login screen) for Ubuntu, currently only up to Jaunty.  Karmic based Ubuntu uses GDM 2.2+ and therefore is incompatible.' --title="TheeMahns GDM Maker";

update() {
 wget -O /tmp/MakeGDM http://ubuntusoftware.info/scripts/MakeGDM >/dev/null 2>&1

# Verify it did download it

RESULTS_SIZE=`stat -c %s /tmp/MakeGDM`
if [ "$RESULTS_SIZE" = 0 ]
then
    zenity --window-icon=/usr/share/ultimate/logo.png --info --text='It is suggested to re-run the script, the server may be under a heavy load.  If the message persists, please verify you have an internet connection, the server is online &amp; try again.  Please refer to UbuntuSoftware Forum for further info.' --title="TheeMahns GDM Maker";
    exit 0
fi

# Version check script

 REMOTE_VERSION=`grep SCRIPT_VERSION /tmp/MakeGDM |head -n1 |sed 's/.*=//'`
 if [ "$REMOTE_VERSION" != "$SCRIPT_VERSION" ]; then
    cp /tmp/MakeGDM ~/.gnome2/nemo-scripts
    echo "GDM Login Maker script has been updated to v $REMOTE_VERSION"
    echo "Please re-run the script"
    zenity --window-icon=/usr/share/ultimate/logo.png --info --text='Newer version of script detected '$REMOTE_VERSION'.  It has been upgraded please re-run script.' --title="GDM Login Maker script";
    exit
 fi
}

update
FNAME="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" 
file=$@
# strip the path everything after last '/'
basename=${file%.*}
ext=".so"
OUTFILE=${basename}${ext}
input=$(zenity --text "What you like to call the GDM Login screen (no spaces in filename or here please, underscores are ok)?" --entry)
retval=$?
case $retval in
0)
GDMNAME=$input;;
1)
exit 0;;
esac
input=$(zenity --text "Author name?" --entry)
retval=$?
case $retval in
0)
AUTHOR=$input;;
1)
exit 0;;
esac
input=$(zenity --text "Description?" --entry)
retval=$?
case $retval in
0)
DESCRIPTION=$input;;
1)
exit 0;;
esac
`zenity --window-icon=/usr/share/ultimate/logo_ico.png --info --text="This will complie a GDM Login in current folder called $GDMNAME.tar.gz you can then load this file into login manager.  Enjoy, TheeMahn" --title="GDM Login Maker"`;



PROGRESS=0
#FNAME=$@
 
#Resolution Subroutines
Res5(){
#cd $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
convert $file -resize "1280X1024!" -quality 100 -strip $GDMNAME/background.jpg | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 1280 X 1024..."
}

#Header Subroutines
Header(){
#Grab Extras
if [ -f /usr/share/ultimate_edition/GDM_Maker/GDM.XML ] 
then
cp /usr/share/ultimate_edition/GDM_Maker/* $GDMNAME/
cd $GDMNAME
echo "[GdmGreeterTheme]
Greeter=GDM.xml
Name=$GDMNAME
Description=$DESCRIPTION
Author=$AUTHOR
Copyright=(c) 2009 UbuntuSoftware
Screenshot=screenshot.png">GdmGreeterTheme.desktop
else
cd $GDMNAME
wget http://ubuntusoftware.info/scripts/GDM.tar.gz
tar xfv GDM.tar.gz
echo "[GdmGreeterTheme]
Greeter=GDM.xml
Name=$GDMNAME
Description=$DESCRIPTION
Author=$AUTHOR
Copyright=(c) 2009 UbuntuSoftware
Screenshot=screenshot.png">GdmGreeterTheme.desktop
rm GDM.tar.gz
fi
convert ../$file -resize "1280X1024!" -quality 100 screenshot.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Generating screenshot..."
#cp screenshot.png selection-active.png
cd ..
}

mkdir -p $GDMNAME
Header
Res5
#Create GDM Archive
tar czf $GDMNAME.tar.gz $GDMNAME/
#Clean up
#rm -R $GDMNAME
zenity --window-icon=/usr/share/ultimate_edition/logo.png --question --title 'TheeMahns GDM Maker' --text "Launch GDM Setup, so you can add your newly created theme?" || exit
#zenity --question --title "GDM Setup" --text="Launch GDM Setup, so you can add your newly created theme?"
gksu /usr/sbin/gdmsetup
