#!/bin/bash
#
# marc brumlik, tailored software inc, Mon Apr 19 23:51:40 CDT 2010
# modified for better menus, Fri Dec 17 11:10:26 CST 2010

#    imagelabel
# Use ImageMagick Convert to add labels to images
# also requires zenity and kcolorchooser

#fonts=`convert -list font | grep Font: | \
#	awk -F: '{print $2}' | sed 's/^/FALSE /'`
#colors=`convert -list color 

iam=`who am i | awk '{print $1}'`
old=`find /tmp -name "imagelabel.[0-9]*" -type d -user $iam -print 2>/dev/null`
rm -rf $old

file="$1"
file -i "$file" | grep image >/dev/null || exit 0
base=`basename "$file"`
work="/tmp/imagelabel.$$"
mkdir "$work"
cp "$file" "$work"

echo "20" > "$work/size"
echo "Frame_around_image_and_label" > "$work/style"
echo "Gold" > "$work/color"
echo "NOT YET ENTERED" > "$work/text"
echo "400x400" > "$work/preview"


while true
do

preview=`cat "$work/preview"`
convert "$work/$base" -geometry $preview "$work/small$base"

display -update 1 -immutable -geometry +50+50 "$work/small$base" >/dev/null 2>&1 &
dpid=$!

sizes="FALSE 10 FALSE 12 FALSE 15 FALSE 20 FALSE 25 FALSE 30 FALSE 35 FALSE 40 FALSE 45 FALSE 50 FALSE 60 FALSE 70 FALSE 80 FALSE 90 FALSE 100 FALSE 120 FALSE 140 FALSE 160 FALSE 180 FALSE 200 FALSE 250 FALSE 300"
curr=`cat "$work/size"`
sizes=`echo "$sizes" | sed "s/FALSE $curr/TRUE $curr/"`
zenity --list --height 470 --title="imagelabel:  Font Size" --text="Choose Font Size" --radiolist --column Select --column Size $sizes > "$work/newsize" &
spid=$!

styles="FALSE Frame_around_image_and_label FALSE Colored_label_under_image"
curr=`cat "$work/style"`
styles=`echo "$styles" | sed "s/FALSE $curr/TRUE $curr/"`
zenity --list --height 300 --title="imagelabel:  Label Style" --text="Choose style\n\n'Frame' option adds a grey border to the image, and as the label background\n'Colored' adds a text box below image in the color of your choice" --radiolist --column Select --column Style $styles > "$work/newstyle" &
tpid=$!

case $style in
	Color*)	kcolorchooser --print > "$work/newcolor" &
		cpid=$! ;;
esac

trap "rm -rf $work; kill -9 $dpid $spid $tpid $cpid 2>/dev/null; exit 5" 0 1 2 3 15

sleep 1
text=`cat "$work/text"`

ntext=`zenity --entry --title="imagelabel:  Text Entry" --entry-text="$text" --text="READ CAREFULLY:  In this window, enter the label for your image.
You may put a \"\134n\" (backslash n) into your text to insert a new line.
Default Preview Size is 400.  Change this by entering new size below as in \"-600\".

Beneath this window are others for font, style, etc.  After making changes in
those windows you must return to THIS window and click \"OK\" to apply them.

To finalize your changes, enter \"SAVE\" or \"QUIT\" in this window and then click \"OK\""`

case $ntext in
	-[0-9][0-9]*)	preview=`echo $ntext | sed 's/^-//'`
			preview=$preview"x"$preview
			echo $preview > "$work/preview" ;;
	SAVE|save)	new=`zenity --file-selection --filename="$file" --save --confirm-overwrite`
			cp "$work/$base" "$new" 2>/dev/null; exit 0 ;;
	QUIT|quit)	exit 0 ;;
	*)		text="$ntext"; echo "$text" > "$work/text" ;;
esac

kill -9 $spid $tpid $cpid 2>/dev/null
[ -s "$work/newsize" ] && mv "$work/newsize" "$work/size"
size=`cat "$work/size"`
[ -s "$work/newstyle" ] && mv "$work/newstyle" "$work/style"
style=`cat "$work/style"`
[ -s "$work/newcolor" ] && mv "$work/newcolor" "$work/color"
color=`cat "$work/color"`

case $style in
	Frame*)	montopt="-frame 5" ;;
	Color*)	montopt="-background $color" ;;
esac
	
montage -label "$text" -pointsize $size $montopt -font Liberation-Serif-Bold-Italic "$file" -geometry +0+0 "$work/$base"

done
