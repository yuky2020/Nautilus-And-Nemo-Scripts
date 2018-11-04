#!/bin/bash
#
# Make-Thumbnails: A simple tool to make thumbnails 
# This tool is a graphical fronted which uses Zenity and basic command
# line tools to make a folder with thumbnails in a photo folder.
# And if you want an image gallery.
# You must have imagemagik in your system.
# Author: TROiKAS troikas@pathfinder.gr

# To begin with, set the app title and version
TITLE="Make-Thumbnails-Folder"
VERSION="1.5.3"

# Set window title and window width
WINDOW_TITLE=$TITLE" (v"$VERSION")"
WINDOW_WIDTH=325
WINDOW_HEIGHT=250

# Paths to needed executables. Please adjust as necessary
Zenity=/usr/bin/zenity
Mkdir=/bin/mkdir
Cp=/bin/cp
Mogrify=/usr/bin/mogrify
Find=/usr/bin/find
Rm=/bin/rm
Killall=/usr/bin/killall
Ls=/bin/ls
Mv=/bin/mv
Expr=/usr/bin/expr
Printf=/usr/bin/printf

# Check if Zenity can be found. If not, produce error message
# (with "xmessage", since zenity is not available) and bail out
if [ ! -e "$Zenity" ]; then
xmessage "ERROR: $Zenity not found. You must install the Zenity\
package, or provide an alternative location"
    exit
fi

# Check if mogrify can be found. If not, produce error message and bail out
if [ ! -e "$Mogrify" ]; then
    $ZENITY --warning --text="ERROR: $Mogrify not found. You must install the \
mogrify package, or provide an alternative location" --title="$WINDOW_TITLE"
    exit
fi 

# create a text entry dialog.
Name=$($Zenity --width $WINDOW_WIDTH --entry --title="$WINDOW_TITLE"  --text "Name of the folder?" --entry-text "thumbs"); echo $Name

    # If user aborts, zenity returns nothing, and $szAnswer will be zero length,
    # and then exit
    if [ -z "$Name" ] ; then
exit
fi

# Make a folder with given name.
name="$Name"

$Mkdir -p $name

# Copy all photo file in the new folder.
$Find ./ -maxdepth 1 -iname '*.jpg' -exec $Cp -n {} $name \;
$Find ./ -maxdepth 1 -iname '*.JPG' -exec $Cp -n {} $name \;

$Find ./ -maxdepth 1 -iname '*.gif' -exec $Cp -n {} $name \;
$Find ./ -maxdepth 1 -iname '*.GIF' -exec $Cp -n {} $name \;

$Find ./ -maxdepth 1 -iname '*.png' -exec $Cp -n {} $name \;
$Find ./ -maxdepth 1 -iname '*.PNG' -exec $Cp -n {} $name \;

# Go to the new folder
cd $name

# create a text entry dialog.
Width=$($Zenity --width $WINDOW_WIDTH --entry --title="$WINDOW_TITLE" --text "Width of thumbs?" --entry-text "150"); echo $Width

    # If user aborts, zenity returns nothing, and $szAnswer will be zero length,
# Remove all files created by the script and then exit.
    if [ -z "$Width" ] ; then
 cd ../
 $Rm -rf $name
 exit
fi

# Resize all photo files.
width="$Width"

function resize() {
for i in "$name"; do
echo "$PROGRESS";
$Find ./ -iname '*.jpg' -exec $Mogrify -resize $width *.jpg \;
$Find ./ -iname '*.JPG' -exec $Mogrify -resize $width *.JPG \;
$Find ./ -iname '*.gif' -exec $Mogrify -resize $width *.gif \;
$Find ./ -iname '*.GIF' -exec $Mogrify -resize $width *.GIF \;
$Find ./ -iname '*.png' -exec $Mogrify -resize $width *.png \;
$Find ./ -iname '*.PNG' -exec $Mogrify -resize $width *.PNG \;
done
}
# Show a progress bar.
resize | (if `$Zenity --progress --pulsate --auto-close --width 500 --title "$WINDOW_TITLE | Wait Resize images" --text "Resize images..."`;
                 then
# Info box when resize complete.
$Zenity --info --width $WINDOW_WIDTH --title="$WINDOW_TITLE" --text="The resize is now complete."
                 else
# If user abort stop everything remove all files
# created by the script and then exit.
                     $Killall $Find
                     $Killall $Mogrify
                    cd ../
                    $Rm -rf $name
                 exit;
                 fi)

$Zenity --question --width $WINDOW_WIDTH --title="$WINDOW_TITLE" --text="Do you want make an image gallery?"
if [[ $? == 0 ]] ; then

Title=$($Zenity --width $WINDOW_WIDTH --entry --title="$WINDOW_TITLE" --text "Title of the image gallery?" --entry-text "My Photo Album"); echo $Title
    # If user aborts, zenity returns nothing, and $szAnswer will be zero length,
# and then exit.
    if [ -z "$Title" ] ; then
 exit
fi

Title2=$($Zenity --width $WINDOW_WIDTH --entry --title="$WINDOW_TITLE" --text "Title 2 of the image gallery?" --entry-text "_______________"); echo $Title2
    # If user aborts, zenity returns nothing, and $szAnswer will be zero length,
# and then exit.
    if [ -z "$Title2" ] ; then
 exit
fi

Bgcolor=$($Zenity --width $WINDOW_WIDTH --entry --title="$WINDOW_TITLE" --text "Background color?" --entry-text "999999"); echo $Bgcolor
    # If user aborts, zenity returns nothing, and $szAnswer will be zero length,
# and then exit.
    if [ -z "$Bgcolor" ] ; then
 exit
fi

Textcolor=$($Zenity --width $WINDOW_WIDTH --entry --title="$WINDOW_TITLE" --text "Text color?" --entry-text "000000"); echo $Textcolor
    # If user aborts, zenity returns nothing, and $szAnswer will be zero length,
# and then exit.
    if [ -z "$Textcolor" ] ; then
 exit
fi

colorh=$($Zenity --width $WINDOW_WIDTH --entry --title="$WINDOW_TITLE" --text "Line color?" --entry-text "#F30C1F"); echo $colorh
    # If user aborts, zenity returns nothing, and $szAnswer will be zero length,
# and then exit.
    if [ -z "$colorh" ] ; then
 exit
fi

widthr=$($Zenity --width $WINDOW_WIDTH --entry --title="$WINDOW_TITLE" --text "Width of the line from 1 to 100?" --entry-text "60"); echo $widthr
    # If user aborts, zenity returns nothing, and $szAnswer will be zero length,
# and then exit.
    if [ -z "$widthr" ] ; then
 exit
fi

c=$($Zenity --width $WINDOW_WIDTH --entry --title="$WINDOW_TITLE" --text "How many colums?" --entry-text "4"); echo $c
    # If user aborts, zenity returns nothing, and $szAnswer will be zero length,
# and then exit.
    if [ -z "$c" ] ; then
 exit
fi

# start html

echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">" >> index.html
echo "<html><head><title>$Title</title>" >> index.html
echo "<meta http-equiv="Content-Type" content="text/html';' charset=UTF-8">" >> index.html
echo "</head>" >> index.html
echo "<body bgcolor=\"$Bgcolor\" text=\"$Textcolor\">" >> index.html
echo "<center>" >> index.html
echo "<h1>$Title</h1>" >> index.html
echo "<h2>$Title2</h2>" >> index.html
echo "<hr color="$colorh" size="2" width="$widthr%">" >>index.html
echo "Click on the thumbnails to see fool size photo in a new tab." >> index.html

TABLE_START="<table border=0 cellspacing=5 cellpadding=7 align=center>"

COUNT=0
IFS="`$Printf '\n\t'`"
		echo "$TABLE_START" >> index.html
for i in `$Ls *.jpg *.png *.gif *.JPG *.GIF *.PNG`;
	do

	echo "$i"
	COUNTLOOP=`$Expr $COUNT \% $c`
	
	if [ $COUNTLOOP -eq 0 ]
	then
		echo "</tr>" >> index.html
		echo "<tr>" >> index.html
		echo "ok"
	fi

	COUNT=`$Expr $COUNT + 1`


	        echo "<td>" >> index.html
                echo "<a href=" >> index.html
		echo "'"$i"' target="_blank">" >> index.html
                echo "<img src='$name/"$i"' border="0">" >> index.html
                echo "</a>" >> index.html
                echo "<br>" >> index.html
                echo "'$i'" >> index.html
                echo "</td>" >> index.html
			
done

echo "</tr>" >> index.html
echo "</table>" >> index.html
echo "<br>" >>index.html
echo "<hr color="$colorh" size="3" width="$widthr%">" >>index.html
echo "Created by: Make-Thumbnails-Folder 1.5.3" >>index.html
echo "</center>" >> index.html
echo "</body>" >> index.html
echo "</html>" >> index.html

$Mv index.html ../

# Info box image gallery complete.
$Zenity --info --width $WINDOW_WIDTH --title="$WINDOW_TITLE" --text="The image gallery is now complete."
else
exit
fi

exit
