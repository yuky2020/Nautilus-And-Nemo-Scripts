#!/bin/sh
# USplash Maker Via TheeMahn
# Copyright (c) 2007  Ubuntusoftware Team <http://ubuntusoftware.info>
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

# 1.03
    # attempted to fix the update subroutine (downloads and checks properly until a new version is detected does not replace with the new version) - fixed

# 1.02 Started Changelog
    # added pallete generated progress bars (throbbers) - thanks redteam_316
    # added resolution selection
    # makefile generation based on resolutions the user selects.

# 1.00 Initial release

    # THE FUTURE
    # ==========
    # Progress bar positioning (only good with single resoultion selection



SCRIPT_VERSION=1.04
FNAME="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" 
file=$@
# everything after last '/'
basename=${file%.*}
architecture=`uname -m`
ext=".so"
OUTFILE=${basename}-${architecture}${ext}

##Check for zenity
if [ ! -e "/usr/bin/zenity" ]; then
	gksudo apt-get install -y --force-yes zenity
fi


update() {
 wget -O /tmp/MakeUsplash http://ubuntusoftware.info/scripts/MakeUsplash >/dev/null 2>&1

# Verify it did download it

RESULTS_SIZE=`stat -c %s /tmp/MakeUsplash`
if [ "$RESULTS_SIZE" = 0 ]
then
    zenity --window-icon=/usr/share/ultimate_edition/logo.png --info --text='It is suggested to re-run the script, the server may be under a heavy load.  If the message persists, please verify you have an internet connection, the server is online &amp; try again.  Please refer to UbuntuSoftware Forum for further info.' --title="UbuntuSoftware USplash Maker";
    exit 0
fi

# Version check script

 REMOTE_VERSION=`grep SCRIPT_VERSION /tmp/MakeUsplash |head -n1 |sed 's/.*=//'`
 if [ "$REMOTE_VERSION" != "$SCRIPT_VERSION" ]; then
    cp /tmp/MakeUsplash ~/.gnome2/nemo-scripts
    echo "Usplash Maker script has been updated to v $REMOTE_VERSION"
    echo "Please re-run the script"
    zenity --window-icon=/usr/share/ultimate_edition/logo.png --info --text='Newer version of script detected '$REMOTE_VERSION'.  It has been upgraded please re-run script.' --title="Usplash Maker script";
    exit
 fi
}

update

##Check for zenity
if [ ! -e "/usr/bin/zenity" ]; then
	gksudo apt-get install -y --force-yes zenity
fi

PROGRESS=0
#FNAME=$@
 
#Resolution Subroutines
Res1(){
#cd $
convert -colors 256 $file -resize '640X400!' -quality 100 -strip WorkInProgress/usplash_640_400.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 640 X 400..."
# Palleting of progressbar - Thanks red_team316
convert WorkInProgress/usplash_640_400.png WorkInProgress/throbber_back_640_400.png WorkInProgress/throbber_fore_640_400.png -append WorkInProgress/append.png
convert WorkInProgress/append.png +dither -colors 256 WorkInProgress/paletted.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Palleting @ 640 X 400..."
convert WorkInProgress/paletted.png -crop 640x400+0+0! WorkInProgress/usplash_640_400.png
convert WorkInProgress/paletted.png -crop 216x8+0+400! WorkInProgress/throbber_back_640_400.png
convert WorkInProgress/paletted.png -crop 216x8+0+408! WorkInProgress/throbber_fore_640_400.png
}

Res2(){
#640X480
#cd $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
convert -colors 256 $file -resize '640X480!' -quality 100 -strip WorkInProgress/usplash_640_480.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 640 X 480..."
convert WorkInProgress/usplash_640_480.png WorkInProgress/throbber_back_640_480.png WorkInProgress/throbber_fore_640_480.png -append WorkInProgress/append.png
convert WorkInProgress/append.png +dither -colors 256 WorkInProgress/paletted.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Palleting @ 640 X 480..."
convert WorkInProgress/paletted.png -crop 640x480+0+0! WorkInProgress/usplash_640_480.png
convert WorkInProgress/paletted.png -crop 216x8+0+480! WorkInProgress/throbber_back_640_480.png
convert WorkInProgress/paletted.png -crop 216x8+0+488! WorkInProgress/throbber_fore_640_480.png
}

Res3(){
#800X600
#cd $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
convert -colors 256 $file -resize '800X600!' -quality 100 -strip WorkInProgress/usplash_800_600.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 800 X 600..."
convert WorkInProgress/usplash_800_600.png WorkInProgress/throbber_back_800_600.png WorkInProgress/throbber_fore_800_600.png -append WorkInProgress/append.png
convert WorkInProgress/append.png +dither -colors 256 WorkInProgress/paletted.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Palleting @ 800 X 600..."
convert WorkInProgress/paletted.png -crop 800x600+0+0! WorkInProgress/usplash_800_600.png
convert WorkInProgress/paletted.png -crop 216x8+0+600! WorkInProgress/throbber_back_800_600.png
convert WorkInProgress/paletted.png -crop 216x8+0+608! WorkInProgress/throbber_fore_800_600.png
}

Res4(){
#1024 X 768
convert -colors 256 $file -resize '1024X768!' -quality 100 -strip WorkInProgress/usplash_1024_768.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 1024 X 768..."
convert WorkInProgress/usplash_1024_768.png WorkInProgress/throbber_back_1024_768.png WorkInProgress/throbber_fore_1024_768.png -append WorkInProgress/append.png
convert WorkInProgress/append.png +dither -colors 256 WorkInProgress/paletted.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Palleting @ 1024 X 768..."
convert WorkInProgress/paletted.png -crop 1024x768+0+0! WorkInProgress/usplash_1024_768.png
convert WorkInProgress/paletted.png -crop 216x8+0+768! WorkInProgress/throbber_back_1024_768.png
convert WorkInProgress/paletted.png -crop 216x8+0+776! WorkInProgress/throbber_fore_1024_768.png
}

Res5(){
#1280X1024
convert -colors 256 $file -resize '1280X1024!' -quality 100 -strip WorkInProgress/usplash_1280_1024.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 1280 X 1024..."
convert WorkInProgress/usplash_1280_1024.png WorkInProgress/throbber_back_1280_1024.png WorkInProgress/throbber_fore_1280_1024.png -append WorkInProgress/append.png
convert WorkInProgress/append.png +dither -colors 256 WorkInProgress/paletted.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Palleting @ 1280 X 1024..."
convert WorkInProgress/paletted.png -crop 1280x1024+0+0! WorkInProgress/usplash_1280_1024.png
convert WorkInProgress/paletted.png -crop 216x8+0+1024! WorkInProgress/throbber_back_1280_1024.png
convert WorkInProgress/paletted.png -crop 216x8+0+1032! WorkInProgress/throbber_fore_1280_1024.png
}

Res6(){
#1365X768
convert -colors 256 $file -resize '1365X768!' -quality 100 -strip WorkInProgress/usplash_1365_768.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 1365 X 768..."
convert WorkInProgress/usplash_1365_768.png WorkInProgress/throbber_back_1365_768.png WorkInProgress/throbber_fore_1365_768.png -append WorkInProgress/append.png
convert WorkInProgress/append.png +dither -colors 256 WorkInProgress/paletted.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Palleting @ 1365 X 768..."
convert WorkInProgress/paletted.png -crop 1365x768+0+0! WorkInProgress/usplash_1365_768.png
convert WorkInProgress/paletted.png -crop 216x8+0+768! WorkInProgress/throbber_back_1365_768.png
convert WorkInProgress/paletted.png -crop 216x8+0+776! WorkInProgress/throbber_fore_1365_768.png
}


Res7(){
#1440X900
convert -colors 256 $file -resize '1440X900!' -quality 100 -strip WorkInProgress/usplash_1440_900.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 1440 X 900..."
convert WorkInProgress/usplash_1440_900.png WorkInProgress/throbber_back_1440_900.png WorkInProgress/throbber_fore_1440_900.png -append WorkInProgress/append.png
convert WorkInProgress/append.png +dither -colors 256 WorkInProgress/paletted.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Palleting @ 1440 X 900..."
convert WorkInProgress/paletted.png -crop 1440x900+0+0! WorkInProgress/usplash_1440_900.png
convert WorkInProgress/paletted.png -crop 216x8+0+900! WorkInProgress/throbber_back_1440_900.png
convert WorkInProgress/paletted.png -crop 216x8+0+908! WorkInProgress/throbber_fore_1440_900.png
}

Res8(){
#1680X1050
convert -colors 256 $file -resize '1680X1050!' -quality 100 -strip WorkInProgress/usplash_1680_1050.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Processing @ 1680 X 1050..."
convert WorkInProgress/usplash_1680_1050.png WorkInProgress/throbber_back_1680_1050.png WorkInProgress/throbber_fore_1680_1050.png -append WorkInProgress/append.png
convert WorkInProgress/append.png +dither -colors 256 WorkInProgress/paletted.png | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Palleting @ 1680 X 1050..."
convert WorkInProgress/paletted.png -crop 1680x1050+0+0! WorkInProgress/usplash_1680_1050.png
convert WorkInProgress/paletted.png -crop 216x8+0+1050! WorkInProgress/throbber_back_1680_1050.png
convert WorkInProgress/paletted.png -crop 216x8+0+1058! WorkInProgress/throbber_fore_1680_1050.png
}

#C Code Subroutines
Header(){
#Grab Throbbers, fonts & C code
echo $CWD
if [ -f /usr/share/ultimate_edition/USplash/Makefile ] 
then
cp /usr/share/ultimate_edition/USplash/* WorkInProgress/
else
cd WorkInProgress
wget http://ubuntusoftware.info/scripts/USplash.tar.gz
tar xfv USplash.tar.gz
cd ..
fi
}

# Dialog box to choose USplash's size(s)
# Begin interaction with end user
`zenity --window-icon=/usr/share/ultimate_edition/logo.png --info --text="This will complie a USplash in current folder called $OUTFILE you can then load this file into Startup Manager (SUM).  Enjoy, TheeMahn" --title="TUM - TheeMahns USplash Maker"`;
SIZE="";
SIZE="$(zenity --window-icon=/usr/share/ultimate_edition/logo.png  --width=500 --height=280 --title "TUM - TheeMahns USplash Maker" --text "Choose the Usplash resolutions to be compiled." --list --checklist --column "Select" --column "Resolution" true '600X400' true '640X480' true '800X600' true '1024X768' true '1280X1024' true '1365X768' true '1440X900' true '1680X1050')";
echo $SIZE
if [ "${SIZE}" == "" ]; then   
zenity --error --text="Resolution not defined by user.  Please choose a size to use. Exiting."
exit 0
fi
n=0
if echo "$SIZE" | grep "600X400" ; then
n=$(($n + 1))
echo -n "$n "
fi
if echo "$SIZE" | grep "640X480" ; then
n=$(($n + 1))
echo -n "$n "
fi
if echo "$SIZE" | grep "800X600" ; then
n=$(($n + 1))
echo -n "$n "
fi
if echo "$SIZE" | grep "1024X768" ; then
n=$(($n + 1))
echo -n "$n "
fi
if echo "$SIZE" | grep "1280X1024" ; then
n=$(($n + 1))
echo -n "$n "
fi
if echo "$SIZE" | grep "1365X768" ; then
n=$(($n + 1))
echo -n "$n "
fi
if echo "$SIZE" | grep "1440X900" ; then
n=$(($n + 1))
echo -n "$n "
fi
if echo "$SIZE" | grep "1680X1050" ; then
n=$(($n + 1))
echo -n "$n "
fi
PROGRESS=0
TOTAL=$((100 / $n))
echo $TOTAL
mkdir -p WorkInProgress
Header
if echo "$SIZE" | grep "600X400" ; then
Res1
fi
if echo "$SIZE" | grep "640X480" ; then
Res2
fi
if echo "$SIZE" | grep "800X600" ; then
Res3
fi
if echo "$SIZE" | grep "1024X768" ; then
Res4
fi
if echo "$SIZE" | grep "1280X1024" ; then
Res5
fi
if echo "$SIZE" | grep "1365X768" ; then
Res6
fi
if echo "$SIZE" | grep "1440X900" ; then
Res7
fi
if echo "$SIZE" | grep "1680X1050" ; then
Res8
fi
cd WorkInProgress
make | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Compiling USplash"
mv usplash-${architecture}.so ../$OUTFILE
cd ..
strip -d usplash-${architecture}.so
#Clean up
#rm -R WorkInProgress
zenity --window-icon=/usr/share/ultimate_edition/logo.png --question --title 'TUM - TheeMahns Usplash Maker' --text 'Would you like to install the newly created USplash (will not set it, just adds it to your list of USplashes)?' || exit
#zenity --question --text "Would you like to install the newly created USplash (will not set it, just adds it to your list of USplashes)?";
gksudo cp $OUTFILE /usr/lib/usplash/
sudo update-alternatives --install /usr/lib/usplash/usplash-artwork.so usplash-artwork.so /usr/lib/usplash/$OUTFILE 10
sudo update-initramfs -u | zenity --width=600 --height=100 --progress --pulsate --auto-close --title "Updating initramfs...";
zenity --window-icon=/usr/share/ultimate_edition/logo.png --question --title 'TUM - TheeMahns Usplash Maker' --text "Load StartupManager so you can set it as the current usplash?" || exit
gksudo startupmanager
