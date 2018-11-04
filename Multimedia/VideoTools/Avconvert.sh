#!/bin/bash

# marc brumlik, tailored software inc, Mon Sep  8 22:50:20 CDT 2008
version="0.98 Mon Mar  5 14:52:51 CST 2012\n   AUTOMATIC DVD RIPPING\n\n\nAdded specific code to recognize that one\n(or more) VOB file(s) are selected.\nYou will be offered to combine them into\na single AVI file on your Desktop\nwith all proper options pre-set."

# tsi-inc@comcast.net
# posted to:  http://www.gnome-look.org/content/show.php/Audio%2BVideo%2BImage%2BText%2BISO+Convert?content=92533
# YOUR VOTE WOULD BE APPRECIATED (as would a $1 donation :-)

# convert various image, audio, and video files into other likely formats

# set -x

#####
# Watcher
#####
avwatcher() {
### this function produces the "progress window" during the conversion.
### there are two phases...

case $veryquiet in
	y)	exit 0 ;;
esac

# set -x
watchit="$1"
mult="100"

# doing frames??
frames=n
echo "$watchit" | grep "frame-%04d" >/dev/null && frames=y
[ "$frames" = "y" ] && mult="1000"

# doing pdf/gif --> multiple images?
[ -z "$multipage" ] || watchit=`echo "$watchit" | sed "s^.$each^-0.$each^"`

# phase 1 begins.  sleep for one second while the conversion gets started.
# sleep 1
# using the process NAME and the PPID given, find the PID of the conversion
pid=`ps -ef | grep " $4 " | grep "$2" | awk '{print $2}'`
z="0"
# every second, test for the appearance of the output file

wtext1=`mytranslate "Waiting for"`
wtext1="$wtext1 $2\n"
wtext1="$wtext1 "`mytranslate "to begin writing"`
wtext1="$wtext1 $watchit"
wtext2=`mytranslate "Program Cancelled!"`

while true
do
# if this is a "frame job", skip watcher phase 1
	[ "$frames" = "y" ] && break
# if the file appears before progress window even comes up, go to phase 2
	if test -s "$watchit"
		then	break
	fi
        for a in 10 20 30 40 50 60 70 80 90 80 70 60 50 40 30 20 10 00
        do
# when file appears, go to phase 2
                test -s "$watchit" && break 2
# otherwise, increment counter in zenity window for next display
                echo $a; sleep 1
		z=`expr $z + 1`
# but if no file is seen for 20 seconds, something's not right.  exit.
		if [ "$z" = "20" ]
			then	exit 0
		fi
        done
done | zenity --progress --auto-close --text="$wtext1" || ( kill -9 $pid >/dev/null 2>&1; zenity --info --text="$wtext2" )

# phase 2

loopsleep=2
# set up for multi-image output if $multipage is non-blank
[ -z "$multipage" ] && multipage="x"
for loop in $multipage
do

if [ "$loop" = "x" ]
	then	: single loop
	else	: loop for each output image
		watchit=`echo "$1" | sed "s^.$each^-$loop.$each^"`
		loopsleep=.5
fi

wtext1=`mytranslate "Writing to"`
wtext1="$wtext1 $watchit\n"
wtext1="$wtext1 "`mytranslate "Estimate to completion...\n\nIf the progress jumps between 95 and 99, this means\nthe new file is larger than the original.  Be patient."`

jump=1

while true
do
# is it still there?  some conversions manipulate the name
	if [ "$frames" = "y" ]
		then	cksize=`echo "$watchit" | sed 's/frame-.*/frame-/'`
			ckext=`echo "$watchit" | sed 's/^.*\././'`
		else	if test -s "$watchit"
				then	cksize="$watchit"
				else	break
			fi
	fi

# find the size of the target output file
	if [ "$frames" = "y" ]
		then
        newsize=`du -a -b -c "$cksize"????$ckext | tail -1 | awk '{print $1}'`
		else
	newsize=`du -a -b "$watchit" | awk '{print $1}'`
	fi
# calculate this as a percentage of target file size
        progress="0"`echo "scale=10; $newsize / $3 * $mult" | bc`
	if [ "$progress" = "$oldprogress" ]
# if we are at 100% zenity will exit on its own
# but if the output file stops growing BEFORE 100%, exit out
		then	break
	fi
	oldprogress="$progress"
	showprogress=`echo "$progress" | sed 's/\..*//'`
	sleep $loopsleep
# if the file is still growing but we're over 95%, get fancy
	if [ "$showprogress" -ge "95" ]
		then	if [ "$jump" = "1" ]
				then	showprogress=95; jump=2
				else	showprogress=99; jump=1
			fi
	fi
	echo $showprogress
done | zenity --progress --percentage=01 --auto-close --text="$wtext1" || ( kill -9 $pid >/dev/null 2>&1; zenity --info --text="$wtext2" )

# end of multi-image loops
done
}
# end of watcher


#####
# Translate text to other languages
#####
mytranslate() {
#
# use online translation service on text

case $online in
	n)	echo "$*"; exit 0 ;;
esac

# A NEWER WAY  :-)
# use gnome's provided "translate"
# (hope this is available to non-gnome users!!)
echo "$*" | sed 's/$/++/' | $trbin -f en -t $lang | sed 's/++/
/g'

# A NEW AND BETTER WAY
###	No longer works -- Google Translate API is now a paid service
### wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=en|$lang" | sed 's/.*"translatedText":"\([^"]*\)".*}/\1\n/' | sed "s/\\u0026#39;/'/g"

# Keeping old code for posterity...
# and, because, it appears the above will not be available (for free) forever

#case $service in
#google)	serviceline="-d langpair=en|$lang http://translate.google.com/translate_t" ;;
#babel)	serviceline="-d lp=en_$lang http://babelfish.yahoo.com/translate_txt" ;;
#esac
#
#transline=`curl --connect-timeout 1 -m 1 --retry 1 -s -A "Mozilla/5.0" \
#	-d "hl=en" -d "ie=UTF8" -d text="$*" $serviceline`
#
#case $service in
#	google) echo "$transline" | grep "gtrans" | \
#		gawk -F"gtrans value" '{print $2}' | \
#		cut -d'"' -f2 | $links -dump | $links -dump | sed 's/^ *//'
#		;;
#	babel)  echo "$transline" | grep "result" | grep "div" | \
#		tr '<>' '~~' | awk -F~ '{print $5}'
#		;;
#esac
}

#####
# Convert
#####
myavconvert() {
#
# processing images or performing text-to-image conversion

# set -x

# this is for looping after the first item, using the env for settings
looping=n
if test -s /tmp/avconvert.env
	then	. /tmp/avconvert.env
		looping=y
fi

# the output types allowed for

case $it in
	image)  out=" gif jpg ico pdf png tif OTHER"
		height=460 ;;
	text)   out=" gif jpg ico pdf png tif OTHER"
		height=370 ;;
esac

# set default checkbox: all false except the original ext (except txt)
case $imageext in
	none)	out=`echo "$out" | sed -e 's/ / FALSE /g'` ;;
	same)	out=`echo "$out" | sed -e 's/ / FALSE /g' -e "s/FALSE \$ext/TRUE $ext/"` ;;
	*)	out=`echo "$out" | sed -e 's/ / FALSE /g' -e "s/FALSE \$imageext/TRUE $imageext/"` ;;
esac

# show output choices to user and loop until selection is made
while true
do
if [ "$looping" = "n" ]
	then
case $prog$it in
        convertimage)   ident=`identify "$target"`
			ident="$ident\n$imident"
			title=`mytranslate "Converting file"`
			c1=`mytranslate "Convert to format"`
			text=`mytranslate "Source file format"`
			text="$text $show,
$ident

"
			text="$text"`mytranslate "You can select multiple formats - avconvert will loop to create them all.

OUTPUT NAMING: names of the files created will include the proper extension,
and if the resolution differs from the original then a \"-XXX\" before the extension.

Choose OTHER for an output type not listed"`
			choice=`zenity --list --height=$height --title="$title $target" --text="$text" --checklist --column "$s1" --column "$c1" $out` || exit 0
			;;
        converttext)    title=`mytranslate "Convert"`
			text=`mytranslate "Source file format"`
			text="$text $show

"
			text="$text"`mytranslate "Default action is to convert TEXT to IMAGE

Choose OTHER for an output type not listed"`
			c1=`mytranslate "Convert to format"`
			choice=`zenity --list --height=$height --title="$title $target" --text="$text" --checklist --column "$s1" --column "$c1" $out` || exit 0
			;;
esac
fi

if [ -n "$choice" ]
	then	break
fi
done

# was it OTHER?
case $choice in
        OTHER_non-image)  exec myavtext ;;
        OTHER)  title=`mytranslate "Output type"`
		text=`mytranslate "Supply an appropriate file extension"`
		choice=`zenity --entry --title="$title" --text="$text"` || exit 0 ;;
esac

# clean up any _audio reference and any leading . in ext
choice=`echo $choice | sed -e 's/_.*//' -e 's/^\..*//'`

#       loop over (possibly multiple) choice(s)
# (THE OUTER LOOP)
for each in `echo $choice | sed 's/|/ /g'`
do

#       what will the destination filename be?
new=`echo $target | sed -e "s/.$ext$//" -e "s/$/.$each/"`

if [ "$looping" = "n" ]
	then
# set resolution here
# results into $dim, will look like "jpg|gif|pdf"
origrez=`echo "$ident" | sed "s/$target//"`
case $it in
	text)	title=`mytranslate "Dimensions"`
		text=`mytranslate "Output dimensions for"`
		text="$text \"$new\"\n\n"
		text="$text"`mytranslate "This will be the dimension along the longer edge
(depending on portrait or landscape mode)

Choose one or more.
(\"Original\" cannot be combined with other sizes)"`
		c1=`mytranslate "Choose dimensions"`
		dim=`zenity --list --height=520 --title="$title" --text="$text" --checklist --column "$s1" --column "$c1" FALSE 1280 FALSE 1024 FALSE 800 FALSE 640 FALSE 480 FALSE 320 FALSE 250 FALSE 200 FALSE 150 FALSE 100 FALSE "Something else"` || exit 0
		;;
	image)	title=`mytranslate "Dimensions"`
		text=`mytranslate "Output dimensions for"`
		text="$text \"$new\"\n\n"
		text="$text"`mytranslate "This will be the dimension along the longer edge
(depending on portrait or landscape mode)

Choose one or more.
(\"Original\" cannot be combined with other sizes)"`
		c1=`mytranslate "Choose dimensions"`
		dim=`zenity --list --height=580 --title="$title" --text="$text" --checklist --column "$s1" --column "$c1" FALSE "Original dimensions" FALSE 1280 FALSE 1024 FALSE 800 FALSE 640 FALSE 480 FALSE 320 FALSE 250 FALSE 200 FALSE 150 FALSE 100 FALSE "Something else"` || exit 0
		;;
esac
fi

case "$dim" in
	Original*)	dim="" ;;
	Something*)	while true
			do
				text=`mytranslate "New size (along longer edge)"`
				dim=`zenity --entry --text="$text"` || exit 0
				case $dim in
					[0-9]*[0-9])	break ;;
					*)		;;
				esac
			done ;;
esac

# if $safedims is set and $dim is empty
# then set it to what we used last time
if [ -z "$dim" -a -n "$safedims" ]
	then	dims="$safedims"
fi
# parse $dim into $dims
case $dim in
	'')	dims=" " ;;
	*)	dims=`echo $dim | sed 's/|/ /g'` ;;
esac

# and save these $dims for next time
safedims="$dims"
textdims=`mytranslate "Previously selected resolutions:"`
textdims="$textdims: $safedims"

if [ "$looping" = "n" ]
	then
# if this is a jpeg, ask for quality
case "$new" in
	*jpg)	title=`mytranslate "Quality"`
		title="JPG $title"
		text=`mytranslate "Choose quality for"`
		text="$text \"$new\""
		qual=`zenity --list --height=290 --title="$title" --text="$text" --radiolist --column "$s1" --column "$title" FALSE 100 FALSE 90 FALSE 80 TRUE 70 FALSE 60 FALSE 50` || exit 0 ;;
esac

# normalize and equalize
case $it in
	image*)	ntxt=`mytranslate "Adjust for full range of colors"`
		etxt=`mytranslate "Adjust for full range of brightness"`
		normeq=`zenity --list --height=190 --title="Normalize / Equalize / Rotate" --text="Normalize: $ntxt\nEqualize: $etxt" --checklist --column "$s1" --column "$s2" FALSE normalize FALSE equalize FALSE rotate-90 FALSE rotate-180 FALSE rotate-270 FALSE transpose FALSE transverse` || exit 0
		case $normeq in
			'')	;;
			*)	normeq=`echo "$normeq" | \
					tr '|' '\012' | sed 's/^/-/'`
				case $normeq in
					-normalize*)	normeq=`echo "$normeq" | sed 's/-normalize/-separate -normalize -combine/'`
							;;
				esac
				normeq=`echo "$normeq" | sed -e 's/-90/ 90/' -e 's/-180/ 180/' -e 's/-270/ 270/'`
				normeq=`echo $normeq`
				;;
		esac
		;;
esac
fi

# create arg to convert for quality
case "$new" in
	*jpg)	case $qual in
			'')	quality="-quality 70" ;;
			*)	quality="-quality $qual" ;;
		esac ;;
esac

# echo "$dir"
# echo "$outdir"

case "$dims" in
	*x*x*)	;;
	*)	case "$dir$overwrite" in
			"$outdir")	title=`mytranslate "Overwrite?"`
					text=`mytranslate "Read carefully:

MANY places in this program are designed to prevent accidentally overwriting
your original file(s).  However, since you have chosen the source directory as
your destination AND chosen only one conversion, you have another option.
You can choose (with caution) to REPLACE ORIGINALS with the converted files.
In this case, the converted files will have the original name as well (instead
of inserting the resolution) but with the correct extension.

Choose wisely..."`
					c1=`mytranslate "Overwrite the original files in place?"`
					overwrite=`zenity --list --title="$title" --height=340 --text="$text" --radiolist --column "$s1" --column "$c1" TRUE NO FALSE YES` || exit 0
					;;
		esac
		;;
esac

# loop through all the $dims.
for rez in " "$dims
do
# THE INNER LOOP

case "$rez" in
	" ")	geom="" ;;
	*)	rez=`echo $rez`; geom="-geometry $rez"x"$rez"
		new=`echo $target | sed -e "s/.$ext$//" -e "s/$/.$rez.$each/"` ;;
esac
if test -s "$outdir/$new"
	then	title=`mytranslate "Choose a new Destination Name"`
		text=`mytranslate "exists - Overwrite?"`
		zenity --question --title="$text" --text="$new $text" || newout=`zenity --file-selection --filename="$outdir/$new" --save --confirm-overwrite --title="$title"` || exit 0
		if [ ! -z "$newout" ]
			then	outdir=`dirname "$newout"`
				new=`basename "$newout"`
		fi
fi

case $it in
text)	# EXTRA stuff for TEXT to IMAGE
	colorlist=`convert -list color | sed -n '/,/s/  .*//p' | sort -u`
	colorlist=`echo " "$colorlist | sed 's/ / FALSE /g'`
	if which kcolorchooser >/dev/null 2>&1
		then	colorlist="FALSE GUI-\"kcolorchooser\" $colorlist"
		else	colortext=`mytranslate "

Install the package \"kdegraphics\" to choose colors with a GUI"`
	fi
	colorlist="FALSE Key-in_RGB-value $colorlist"
	# for OLD version of convert
	# fontlist=`convert -list font | sed -n '/0$/s/ .*//p' | sort -u`
	# for NEW version of convert
	fontlist=`convert -list font | grep Font | sed 's/^.*://' | \
		sed -e 's/^ //g' -e 's/ $//' | sort -u`
	fontlist=`echo " "$fontlist | sed 's/ / FALSE /g'`
	sizelist=" 8 10 12 15 20 25 30 35 40 50 60 80 100 120 150 200 250 300"
	sizelist=`echo "$sizelist" | sed 's/ / FALSE /g'`

	bg=`mytranslate "Background"`
	title="$bg"
	text=`mytranslate "Choose Background Color

NOTE: If you use GUI chooser, the RGB values
will be shown in subsequent windows
for your reference."`
	text="$text $colortext\n\n"
	text=`mytranslate "ALSO NOTE: for some unknown reason
there is a long delay when GUI closes."`
	c1=`mytranslate "Choose color"`
	back=`zenity --list --height=500 --title="$title" --text="$text" --radiolist --column "$s1" --column "$c1" $colorlist` || exit 0
	case $back in
		GUI-*)	back=`kcolorchooser --print` ;;
		_GUI*)	text=`mytranslate "To choose colors using a GUI
interface, install the"`
			text="$text \"kdegraphics\""
			text="$text "`mytranslate "package"`
			zenity --info --title="kcolorchooser" --text="$text"
			exit 0
			;;
		Key-*)	title=`mytranslate "Key in color"`
			text=`mytranslate "Enter the RGB color as"`
			back=`zenity --entry --title="$title" --text="$text  #RGB  #RRGGBB  #RRRGGGBBB  #RRRRGGGGBBBB  rgb(rrr,ggg,bbb)"` || exit 0
			;;
	esac
	fg=`mytranslate "Foreground"`
	title="$fg"
	text=`mytranslate "Choose Foreground Color"`
	fill=`zenity --list --height=500 --title="$title" --text="[$bg = $back]\n\n$text" --radiolist --column "$s1" --column "$c1" $colorlist` || exit 0
	case $fill in
		GUI-*)	fill=`kcolorchooser --print` ;;
		_GUI*)	kdeg=`mytranslate "To choose colors with a GUI
interface, install the \"kdegraphics\" package"`
			zenity --info --title="kcolorchooser" --text="$kdeg"; exit 0 ;;
		Key-*)	title=`mytranslate "Key in color"`
                        text=`mytranslate "Enter the RGB color as"`
			fill=`zenity --entry --title="$title" --text="$text:  #RGB  #RRGGBB  #RRRGGGBBB  #RRRRGGGGBBBB  rgb(rrr,ggg,bbb)"` || exit 0 ;;
	esac
	title=`mytranslate "Border Width"`
	text=`mytranslate "Choose Border Width"`
	borw=`zenity --list --height=340 --title="$title" --text="[$bg = $back]\n[$fg = $fill]\n\n$text" --radiolist --column "$s1" --column "$text" FALSE 0 FALSE 5 FALSE 10 FALSE 20 FALSE 30 FALSE 50` || exit 0
	case $borw in
		0)	borc=`mytranslate "transparent"` ;;
		*)	title=`mytranslate "Border Color"`
			text=`mytranslate "Border Width"`
			borc=`zenity --list --height=500 --title="$title" --text="[$bg = $back]\n[$fg = $fill]\n[$text = $borw]\n\n$title" --radiolist --column "$s1" --column "$title" $colorlist` || exit 0 ;;
	esac
	case $borc in
		GUI-*)	borc=`kcolorchooser --print` ;;
		_GUI*)	zenity --info --title="kcolorchooser" --text="$kdeg"; exit 0 ;;
		Key-*)	title=`mytranslate "Key in color"`
                        text=`mytranslate "Enter the RGB color as"`
			borc=`zenity --entry --title="$title" --text="$text:  #RGB  #RRGGBB  #RRRGGGBBB  #RRRRGGGGBBBB  rgb(rrr,ggg,bbb)"` || exit 0 ;;
	esac
	title=`mytranslate "Font"`
	text=`mytranslate "Choose text font and style"`
	font=`zenity --list --height=500 --title="$title" --text="[$bg = $back]\n[$fg = $fill]\n[Border width is $borw]\n[Border color is $borc]\n\n$text" --radiolist --column "$s1" --column "$title" $fontlist` || exit 0
	title=`mytranslate "Font Size"`
	text=`mytranslate "Choose text font size"`
	size=`zenity --list --height=500 --title="$title" --text="[$bg = $back]\n[$fg = $fill]\n[Border width is $borw]\n[Border color is $borc]\n[Font style is $font]\n\n$text" --radiolist --column "$s1" --column "$title" $sizelist` || exit 0
	textoptions="-background $back -fill $fill -border $borw -bordercolor $borc -font $font -pointsize $size label:@"
	longestline=`cat "$target" | awk 'BEGIN {max[i]=0}
                        (length >= max[i]) {max[i] = length}
                        END {printf "%s\n", max[i]}'`
	# horizrez=`echo -e "scale=0\n$rez * 8 / 11\nquit\n" | bc`
	horizrez=$rez
	maxpossible=`echo -e "scale=0\n$horizrez / $size\nquit\n" | bc`
	# splitpieces=`echo -e "scale=0\n$longestline / $maxpossible\nquit\n" | bc`
	newlength=`echo -e "scale=2\n$maxpossible * .9\nquit\n" | bc`
	newlength=`echo "$newlength" | sed 's/\..*//'`
	if [ "$longestline" -ge "$maxpossible" ]
		then	newtarget=`echo "$target" | sed "s/$ext$/wrap$newlength/"`
			title=`mytranslate "Adjusting input file"`
			text=`mytranslate "The source file \"1\" contains long lines.

The longest line is 2 but the max possible with an
image width of 3 and a font size of 4 is 5.

Creating an intermediate text file with a word wrap at
the first space after character position 6.

This will get you APPROXIMATELY the
character size you asked for.
The intermediate file will contain the full text of 7.

Intermediate file name is: 8"`
			text=`echo "$text" | \
			sed -e "s/1/$target/" -e "s/2/$longestline/" \
			-e "s/3/$horizrez/" -e "s/4/$size/" \
			-e "s/5/$maxpossible/" -e "s/6/$newlength/" \
			-e "s/7/$target/" -e "s/8/$newtarget/"`

			zenity --info --title="$title" --text="$text"
		sed "s/.\{$newlength\} /&\n/g" < "$target" > "$newtarget"
			target="$newtarget"
	fi

	linecount=`wc $target | awk '{print $1}'`
	maxpossible=`echo -e "scale=2\n$rez / $size\nquit\n" | bc`
	maxpossible=`echo -e "scale=2\n$maxpossible * 2 / 3\nquit\n" | bc`
	maxpossible=`echo "$maxpossible" | sed 's/\..*//'`

	if [ "$linecount" -gt "$maxpossible" ]
		then	shorttarget=`echo $target | sed 's/$ext$//'`
			title=`mytranslate "Adjusting input file"`
			text=`mytranslate "The source file \"1\" contains too many lines.
Adjusting for a more normal aspect ratio.

There are 2 lines, but the max possible
with a length of 3 and a size of 4 is 5.

Splitting 6 into a set of files with 7
lines in each.  The resulting files will be processed.

This will get you APPROXIMATELY the
character size you asked for.

Intermediate files will be named 8"aa.txt", 8"ab.txt", 8"ac.txt", and so on."`
			text=`echo "$text" | \
			sed -e "s/1/$target.txt/" -e "s/2/$lincount/" \
			-e "s/3/$rez/" -e "s/4/$size/" \
			-e "s/5/$maxpossible/" -e "s/6/$target.txt/" \
			-e "s/7/$maxpossible/" -e "s/8/$shorttarget/g"`
			zenity --info --title="$title" --text="$text"
			cat "$target" | split -$maxpossible - "$shorttarget"
			targets=`ls $shorttarget??`
			multiple=y
			for each in `ls $shorttarget??`
			do
				mv "$each" "$each.txt"
			done
	fi
	;;
esac
#End of extra stuff for text to image

# Now, do the actual conversion

# usually just one target
targets="$target"

# in a text->image that needed splitting will be multiple $targets
case $multiple in
	y)	count=1
		targets=`ls $shorttarget??*`
		basenew="$new" ;;
esac

echo "$targets" | \
while read target
do
case $multiple in
	y)	case $count in
			?)	count="00"$count ;;
			??)	count="0"$count ;;
		esac
		new=`echo "$basenew" | sed "s/\....$/.$count&/"`
		;;
esac

# some special handling of pdf files
tpdf=n; npdf=n
echo "$target" | grep "pdf$" >/dev/null && tpdf=y
echo "$new" | grep "pdf$" >/dev/null && npdf=y

# if source=pdf and dest=image - set density for reasonable quality
[ "$tpdf$npdf" = "yn" ] && density="-density 600"
# case $tpdf$npdf in
	# yn)	density="-density 600" ;;
# esac


# if source is multi-page, find how many
# but ONLY if target is NOT gif or pdf
echo "$target" | egrep -y "pdf|gif|" && tmult=y
echo "$new" | egrep -y "pdf|gif|" && nmult=y
case $tmult$nmult in
	yy) ;;
	*)
	capext=`echo $ext | tr '[a-z]' '[A-Z]'`
	multipage=`echo "$ident" | grep ".$ext\[[0-9].* $capext" | \
		sed -e "s/ $capext.*//"`
	case "$multipage" in
		*[0-9]\])	multipage=`echo "$multipage" | \
					sed -e "s/^.*$ext.//" -e 's/.$//g'`
				export multipage each

				;;
	esac
	;;
esac

text=`mytranslate "Working on"`
oldsize=`du -a -b "$target" | awk '{print $1}'`
avwatcher "$outdir/$new" "$prog" "$oldsize" $$ &
convert -verbose $density $geom $quality $normeq $textoptions"$target" "$outdir/$new" >/tmp/convert.$$.$count 2>&1
case $overwrite in
	YES)	rename=`echo "$target" | sed "s/$ext$/$each/"`
		mv "$outdir/$new" "$rename"
		rm "$target" ;;
esac
# ImagMagick/convert may call ufraw for camera raw images
# there is a new version of ufraw with slightly different options
# convert is using old options, causing a "deprecated" complaint
# but the results are good as old options are still accepted.
cleanup=`egrep -v "deprecated|ppm16" /tmp/convert.$$.$count` >/tmp/$$
mv /tmp/$$ /tmp/convert.$$.$count
if test -s /tmp/convert.$$.$count
	then	message=`cat /tmp/convert.$$.$count`
		text=`mytranslate "An error occured during the conversion

The message was: "`
		zenity --info --text="$text $message" &
	else	rm -f /tmp/convert.$$.$count
fi

case $multiple in
	y)	count=`expr $count + 1` ;;
esac
# end of multiple $targets loop
done

# end of inside loop for $rez
done
# end of outside loop for $dims
done

# convert -verbose $geom $quality $textoptions"$target" "$outdir/$new" 2>/tmp/convert.$$.$count | zenity --progress --text="Working on $new" --auto-close --auto-kill --pulsate

case $autoloop in
	y)	echo "
			choice=\"$choice\"
			dim=\"$dim\"
			dims=\"$dims\"
			geom=\"$geom\"
			qual=\"$qual\"
			textoptions=\"$textoptions\"
			normeq=\"$normeq\"
				" > /tmp/avconvert.env ;;
esac
}
# end of avconvert



#####
# ffmpeg
#####
myavffmpeg() {
#
# processing audio and video

# set -x
# this is for looping after the first item, using the env for settings
looping=n
if test -s /tmp/avffmpeg.env
	then	. /tmp/avffmpeg.env
		looping=y
fi

# set up output extensions
case $av in
	video)  out=" ogg ogv 3gp asf avi flv mkv mp4 mov mpg rm wmv flac_audio_only m4a_audio_only mp3_audio_only wav_audio_only wma_audio_only jpeg_frames OTHER"
		height=550 ;;
	audio)  out=" ogg flac m4a mp3 wav wma OTHER"
		height=360 ;;
esac

out=`echo "$out" | sed -e 's/ $ext //' -e "s/ / FALSE /g"`

# loop for output conversion type
if [ "$looping" = "n" ]
	then
while true
do
title=`mytranslate "Convert"`
text1=`mytranslate "Source file information"`
text2=`mytranslate "Choose OTHER for an output type not listed"`
choice=`zenity --list --height=$height --title="$title $target" --text="$text1 $show\n$ffident\n\n$text2" --radiolist --column "$s1" --column "$title" $out` || exit 0

if [ -n "$choice" ]
        then      break
fi
done
fi

# was it OTHER?
case $choice in
        OTHER)  title=`mytranslate "Output type"`
		text=`mytranslate "Supply a valid file extension, example "`
		choice=`zenity --entry --title="$title" --text="$text ogg / vob"` || exit 0 ;;
esac


case $choice in
	*_audio*)	av=audio; choice=`echo $choice | sed 's/_.*//'` ;;
	*_frames)	av=frame; choice=`echo $choice | sed 's/_.*//'`
			outf=`echo $choice | awk -F_ '{print $1}'`
			title=`mytranslate "Frame capture"`
			text=`mytranslate "Number of frames to capture per second.
The source file FPS is shown above."`
			step=`zenity --scale --title="$title" --text="$show\n$ffident\n\n$text" --value=1 --min-value=0 --max-value=60 --step=1` || exit 0
			# step="1/$step"
			;;
esac

# we now have the output type

# ffmpeg options from options files
## SEED THE FILES IF NOT PRESENT
# recreate the audio and video files, create custom if not present

cat <<!audio > ~/.config/avconvert/avconvert.ffopts.audio
# ~/.config/avconvert/avconvert.ffopts.audio
#
# Do *NOT* put your own options here - they will be overwritten!
#
# Use ~/.config/avconvert/avconvert.ffopts.custom instead
#
TRUE AUDIO-CODEC-UNCHANGED
FALSE acodec-ac3
FALSE acodec-mp2
FALSE acodec-libmp3lame
TRUE AUDIO-SAMPLE-RATE-UNCHANGED
FALSE ar-44100
FALSE ar-22050
TRUE AUDIO-BITRATE-UNCHANGED_default=64k
FALSE ab-128k
TRUE VOLUME-UNCHANGED_default=256
FALSE vol-512
!audio

cat <<!video > ~/.config/avconvert/avconvert.ffopts.video
# ~/.config/avconvert/avconvert.ffopts.video
#
# Do *NOT* put your own options here - they will be overwritten!
#
# Use ~/.config/avconvert/avconvert.ffopts.custom instead
#
TRUE VIDEO-SIZE-UNCHANGED#you_choose_width/height_will_be_calculated/aspect_retained
FALSE w-128
FALSE w-320
FALSE w-640
TRUE NO-ROTATION#rotation_requires_VLC_(using_KEY-IN,'vert'/'vlip'/'hflip'_too)
FALSE rotate-right
FALSE rotate-left
TRUE DO-NOT-LETTERBOX#choose_aspect_of_your_player_to_avoid_stretching
FALSE d-1.3333#4:3
FALSE d-1.5#Apple_iPhone
FALSE d-1.7778#16:9
TRUE VIDEO-CODEC-UNCHANGED
FALSE vcodec-libx264
FALSE vcodec-mjpeg
FALSE vcodec-mpeg2video
!video

[ ! -f ~/.config/avconvert/avconvert.ffopts.custom ] && \
cat <<!custom > ~/.config/avconvert/avconvert.ffopts.custom
# ~/.config/avconvert/avconvert.ffopts.custom
#
# The purpose of THIS file is that you can create option-sets that
# you use often, and apply them with a single click in avconvert
#
# This file will NOT be overwritten by updates, but if you remove it then
# a new one will be created with all new options from the latest release
#
# There MUST be only two "words" per line, separated by a space
# TRUE or FALSE followed by an option.  The option has the "-" moved
#   so that "-option parameter" becomes "option-paramater".
# These can be combined by separating them with "~", as in
#   option1-parameter~option2-paramater
# A comment may be added by following options with "#comment" as in
#   option1-parameter~option2-parameter#My-Comment-here
#   s-640x480~vcodec-mpeg2video#my_custom_options
# But there must be ONLY ONE space in each line
#
# An option for SIZING (-w) is NOT actually an ffmpeg option.  The real
# size option is "-s WWWxHHH" where WWW and HHH are width and height and
# would be written in an ffopts file as "s-WWWxHHH".  However, both here
# and in ffopts.custom and ffopts.submissions, this script will use the
# "-w WWW" (w-WWW) to trigger automatic resizing of the height to preserve
# the original aspect ratio.  The supplied and calculated values will also
# be rounded down to the nearst multiple of 2 pixels
#
# The DISPLAY option (-d) is ALSO not a true ffmpeg option.  It will be
# used to determine if the video needs to be letterboxed so that aspect
# ration is preserved when played on your device.  So regardless of SIZE,
# if the original aspect does not match your specified DISPLAY, the math
# will be done for you and black bands added to make the video fit.
# Again, this form may also be used in .custom and .submissions files.

TRUE NO-CUSTOM-OPTIONS_these.are.created.using.KEY-IN
FALSE s-640x480~vcodec-mpeg2video~acodec-mp2#Sample_custom_command
!custom

grep tsi-inc ~/.config/avconvert/avconvert.ffopts.custom >/dev/null || cat <<!message >> ~/.config/avconvert/avconvert.ffopts.custom
#
# One more thing:  if you come up with some handy (or necessary) option
# sets for specific conversions and submit them to me, I will start
# maintaining a ~/.config/avconvert/avconvert.ffopts.submissions file and
# regularly post it for download.
# Just email me your option line in the format below.
# Include a comment section, and describe the circumstances that require
# it.  For example "when the input file is *.xxx and the output file is
# *.yyy and ffmpeg identifies the audio stream as zzz.
# Send submissions to:  tsi-inc@comcast.net
# and include "avconvert submission" in the subject line.
!message
cat <<!ffmpeghelp > ~/.config/avconvert/avconvert.ffmpeg-help
NOTE: an option like "-ss 60 -t 30" (seek in 60 seconds and record 30 seconds)
would be written in ~/.config/avconvert/avconvert.ffopts* as:
	ss-60~t-30#seek-60_record-30
but here, use standard command-line syntax, like this:
	-ss 60 -t 30

-t time		"time" is in seconds OR HH:MM:SS.xxx			stop recording after "time"
-fs NNN		"filesize" in bytes							stop recording at this "size"
-f FFF		format as in "rawvideo" "oss"
-ss time		"time is in seconds OR HH:MM:SS				start recording at "time"
-target		eg. "vcd" "dvd" "ntsc" sets all appropriate options for this type
-b rate		video bitrate in bit/s						default "200 kb/s" (200000)
-r fps		video frames per second in HZ					default "25" fps
-s size		frame size HHHxVVV (default is retain original)	HORIZONTALxVERTICAL size
-aspect		4:3  16:9  1.3333  1.7777
-croptop		NN crop NN pixels from the top				produces a band
-cropbottom	-cropleft   -cropright						(see croptop)
-padtop		NN  pad NNN pixels on the top				produces a band
-padbottom	-padleft   -padright							(see padtop)
-padcolor		H 6-digit HEX value (eg 000000) for padded bands
-vcodec		CC  CC is codec name as in "libxvid" "mpeg4"
-pass N		N = 1 or 2                             					1-pass or 2-pass vid encoding
-ilme		(MPEG-2/4) if input interlaced, retain it for higher quality
-ar			NNN     audio sample frequency 44100/22050/11025 default 44100
-ab			NNN     audio birate in bit/s                		 	 default 64k
-ac			N       number of audio channels             		 	 default 1
-an			disable audio recording
-acodec CCC	audio codec name as in "ac3" "mp2"
-tvstdc SSS	set TV standard to NTSC PAL SECAM
-shortest		finish recording when shortest input stream ends

Not OFFICIALLY ffmpeg options, but handled by avconvert:

-w			WWW	specify a new video width, height is calculated for you
-d			A.AAAA	specify the HxW ratio of a display device for letterboxing to preserve aspect ratio
!ffmpeghelp

## END OF SEEDING THE FILES
# THE WORK STARTS HERE...

# If we are NOT in a loop, ask for options...
if [ "$looping" = "n" ]
	then
case $av in
	audio)	storedopts=`cat ~/.config/avconvert/avconvert.ffopts.audio ~/.config/avconvert/avconvert.ffopts.custom ~/.config/avconvert/avconvert.ffopts.submissions 2>/dev/null` ;;
	video)	storedopts=`cat ~/.config/avconvert/avconvert.ffopts.audio ~/.config/avconvert/avconvert.ffopts.video ~/.config/avconvert/avconvert.ffopts.custom ~/.config/avconvert/avconvert.ffopts.submissions 2>/dev/null` ;;
esac
storedopts=`echo "$storedopts" | sed 's/^#.*//'`

title=`mytranslate "More options"`
text1=`mytranslate "Source file:"`
text2=`mytranslate "Select a combination of options, or leave any UNCHANGED.
You may choose options here AND click KEY-IN-OPTIONS.  The selected and keyed options will both be used.
There is a help page for key-in options.

Note that leaving an option UNCHANGED might actually result in some default actions, so check your results!
If ALL options are UNCHANGED, ffmpeg is executed with the parameter -sameq

These options are stored in ~/.config/avconvert/avconvert.ffopts*
You can modify the avconvert.ffopts.custom file, which will not be overwritten.
Use your favorite text editor and follow instructions contained in that file."`
c1=`mytranslate "Choose ONLY ONE from each category"`

ffopts=`zenity --list --height=600 --title="$title" --text="$text1 $target\n$ffident\n\n$text2" --checklist --column "$s1" --column "$c1" $storedopts FALSE KEY-IN-OPTIONS` || exit 0

if echo "$ffopts" | grep KEY-IN-OPTIONS >/dev/null
	then	title=`mytranslate "Quick list of ffmpeg options"`
		zenity --info --no-wrap --title="FFMPEG:  $title" --text="`cat ~/.config/avconvert/avconvert.ffmpeg-help`" 2>/dev/null &
		sleep .5
		zpid=`ps -ef | grep -v grep | grep -e "--title=FFMPEG:" | \
			awk '{print $2}'`
		title=`mytranslate "Key in your options"`
		text=`mytranslate "Examples (leave blank for none)
"`
		text2=`mytranslate "

If you add a comment, then your options will be saved for future use
in ~/.config/avconvert.ffopts.custom.  Example:   "`
		text3=`mytranslate "My favorite"`
dopts=`echo "$ffopts" | tr '|' '\012' | sed 's/^[A-Z].*//' | grep -v '^$'`
dopts=`echo "$dopts" | sed -e 's/^/ /' -e 's/#.*//'`
dopts=`echo "$dopts" | sed -e 's/~/ /g' -e 's/-/~/g' -e 's/ / -/g' -e 's/~/ /g'`
case "$dopts" in
	" -")	dopts="" ;;
esac
		keyin=`zenity --entry --title="$title" --text="$text     -acodec mpeg3 -vcodec libx264 -ab 320k$text2 -acodec mpeg2 -vcodec libx264 # $text3

Current ffmpeg options:  $dopts"`
		kill -15 $zpid >/dev/null 2>&1
		if echo "$keyin" | grep "#" >/dev/null
			then
			opt=`echo "$keyin" | sed -e 's/  */ /g' -e 's/^ //'`
			com=`echo "$opt" | sed -e 's/^.*#//' \
				-e 's/^ //' -e 's/ $//' -e 's/ /_/g'`
			opt=`echo "$opt" | sed 's/#.*//'`
			for word in $opt
			do
				case $word in
				-*)	line=$line`echo $word | sed 's/-//'` ;;
				*)	line=$line-$word~ ;;
				esac
			done
			line=`echo "$line#$com" | sed 's/~#/#/'`
			echo "FALSE $line" >> ~/.config/avconvert/avconvert.ffopts.custom
			keyin=`echo "$keyin" | sed 's/#.*//'`
		fi
fi

# manage the SPECIAL options for resizing and letterboxing
size=`echo "$ffident" | grep Video | awk '{print $6}'`	#current size per ffmpeg
size=`echo $size | sed 's/,//'`
curw=`echo $size | sed 's/x.*$//'`			#current width
oldw=$curw
curh=`echo $size | sed 's/^.*x//'`			#current height
cura=`echo -e "scale=2\n$curw / $curh\nquit" | bc`	#current aspect
wopt=`echo "$ffopts" | grep "w-" | sed 's/^.*w-//' | \
	sed -e 's/|.*//' -e 's/#.*//'` 			#new width
neww=$wopt
disp=`echo "$ffopts" | grep "d-" | sed 's/^.*d-//' | \
	sed -e 's/|.*//' -e 's/#.*//'`			 #disp asp
if [ ! -z "$neww" ]
	then	neww=`expr $neww / 2 \* 2`		#round down
		scale=`echo -e "scale=5\n$curw / $neww\nquit" | bc` #height chg
		newh=`echo -e "scale=5\n$curh / $scale\nquit" | bc` # new HHH
		newh=`echo $newh | sed 's/\..*//'`	#integer
		newh=`expr $newh / 2 \* 2`		#round down
		curh=$newh				#new HHH
		oldw=$curw
		curw=$neww
		nopt="$neww"x"$newh"			#WWWxHHH string
		ffopts=`echo "$ffopts" | sed "s/w-$wopt/s-$nopt/"` #substitute
fi

if [ ! -z "$disp" ]
then	# *10000 and remove decimal, so "test" can treat as integer
	# which aspect is wider? to calculate padding
	curam=`echo -e "scale=5\n$cura * 10000\nquit" | bc`
	dispm=`echo -e "scale=5\n$disp * 10000\nquit" | bc`
	curam=`echo $curam | sed 's/\..*//'`
	dispm=`echo $dispm | sed 's/\..*//'`
	if [ "$cura" != "$disp" ]
	then	if [ "$curam" -ge "$dispm" ]
			then	# current aspect is wider than target aspect
				# pad top and bottom
		xtra=`echo -e "scale=5\n$cura / $disp * $curh\nquit" | bc` #dots
			pad=tb
			else	# target aspect is wider than current aspect
				# pad left and right
		xtra=`echo -e "scale=5\n$disp / $cura * $curw\nquit" | bc` #dots
			pad=lr
		fi
		# $xtra is the total dots HHH or WWW in display aspect
		xtra=`echo $xtra | sed 's/\..*//'`	#integer
		# ACTUAL pad is $xtra - soze-of-image
		case $pad in
			tb)	xtra=`expr $xtra - $curh + 1` ;;  #subtract HHH
			lr)	xtra=`expr $xtra - $curw + 1` ;;  #subtract WWW
		esac
		# the padding should be half/half either L/R or T/B
		xtra=`expr $xtra / 2`			#top/bottom
		xtra=`expr $xtra / 2 \* 2`		#round down
		# create command option
		case $pad in
			tb)	padding="padtop-$xtra|padbottom-$xtra" ;;
			lr)	padding="padleft-$xtra|padright-$xtra" ;;
		esac
		ffopts=`echo "$ffopts" | \
			sed "s/d-$disp/$padding|aspect-$disp/"`
	fi
fi
## end of aspect and padding section

ffopts=`echo "$ffopts" | tr '|' '\012' | sed 's/^[A-Z].*//' | grep -v '^$'`
if echo "$ffopts" | grep rotate >/dev/null
	then	rotate=`echo "$ffopts" | grep rotate`
		ffopts=`echo "$ffopts" | grep -v rotate`
		case $rotate in
			*right)	rotate=90 ;;
			*vert)	rotate=180 ;;
			*left)	rotate=270 ;;
			*vflip)	rotate=vflip ;;
			*hflip)	rotate=hflip ;;
		esac
fi
ffopts=`echo "$ffopts" | sed -e 's/^/ /' -e 's/#.*//'`
ffopts=`echo "$ffopts" | sed -e 's/~/ /g' -e 's/-/~/g' -e 's/ / -/g' -e 's/~/ /g'`
case "$ffopts" in
	" -")	ffopts=" -sameq" ;;
esac

ffopts="$ffopts $keyin"
# echo -e "\n\nThe final ffmpeg options look like this:\n"
# echo $ffopts

# END OF OPTION-SETTING
fi

new=`echo $target | sed "s/$ext$/$dot$choice/"`

case $av in
	frame)	new="$target.frame-%04d.$outf"
		specialopts="-f image2 -r $step" ;;
esac

case $new in
	*3gp)	x264=`ls /usr/lib/*x264* | sed 's/\..*//' | head -1`
		x264=`basename $x264`
		specialopts="-vcodec $x264 -acodec libfaac" ;;
	*flv)	case "$ffopts" in
			*-ar*)	;;
			*)	ar=`echo "$ffident" | grep Audio | \
				awk -F, '{print $2}' |
				sed -e 's/Hz//' -e 's/ //g'`
				if [ "$ar" -gt "11025" ]
					then	nr=11025
				fi
				if [ "$ar" -gt "22050" ]
					then	nr=22050
				fi
				if [ "$ar" -gt "44100" ]
					then	nr=44100
				fi
				ffopts="$ffopts -ar $nr"
				;;
		esac
esac

case "$outdir/$new" in
	"$dir/$target")	title=`mytranslate "Destination file has the same name as source!!  Choose a new name"`
			newout=`zenity --file-selection --filename="$outdir/$new" --save --confirm-overwrite --title="$title"` || exit 0
			outdir=`dirname "$newout"`
			new=`basename "$newout"`
			;;
esac

if test -s "$outdir/$new"
	then    text=`mytranslate "exists - Overwrite?

(OK to overwrite, Cancel to supply a new name)"`
		zenity --question --text="$outdir/$new $text" || newout=`zenity --file-selection --filename="$outdir/$new" --save --confirm-overwrite --title="Choose a new file/folder"` || exit 0
		if [ ! -z "$newout" ]
			then	outdir=`dirname "$newout"`
				new=`basename "$newout"`
		fi
fi

oldsize=`du -a -b "$target" | awk '{print $1}'`
case $rotate in
	?*)	tempfile=`echo "$target" | sed 's/^/rotate-/'`
		avwatcher "$outdir/$tempfile" "mencoder" "$oldsize" $$ &
		# first attempt:
		# mencoder -vf rotate=$rotate -o "$outdir/$tempfile" -oac copy -ovc lavc "$target"
		# better quality:
mident=`midentify "$target"`
arate=`echo "$mident" | grep "AUDIO_BITRATE" | tail -1 | awk -F= '{print $2}'`
vrate=`echo "$mident" | grep "VIDEO_BITRATE" | tail -1 | awk -F= '{print $2}'`
rpass1=`mencoder "$target" -ovc lavc -lavcopts vbitrate=$vrate:vpass=1:turbo:threads=2 -oac copy -passlogfile $outdir/2pass.log -o "/tmp/mencoder-pass1-$tempfile" 2>&1`
rpass2=`mencoder "$target" -vf rotate=$rotate -ovc lavc -lavcopts vbitrate=$vrate:vpass=2:vhq=4:threads=2:abitrate=$arate -oac copy -passlogfile $outdir/2pass.log -o "$outdir/$tempfile" 2>&1`
echo -e "\tPASS 1\n\n$rpass1" > /tmp/mencoder-rotate.$$
echo "\n\n\tPASS 2\n\n$rpass2" >> /tmp/mencoder-rotate.$$
rm -f $outdir/2pass.log
midentr=`midentify "$outdir/$tempfile"`
arater=`echo "$midentr" | grep "AUDIO_BITRATE" | tail -1 | awk -F= '{print $2}'`
vrater=`echo "$midentr" | grep "VIDEO_BITRATE" | tail -1 | awk -F= '{print $2}'`
sizeof=`wc "$outdir/$tempfile" | awk '{print $3}'`
if [ "$arater"="0" -o "$vrater"="0" -o "$sizeof"="0" ]
	then	zenity --warning --title="Rotate Failed" --text="Rotation Failed!  :-(\n\nMencoder does not work well with all codecs.\nTry converting your file first (perhaps to AVI) and rotate the result"; exit 0
fi
		#   NEW WAY with VLC, which apparently doesn't work "yet"
		#   BECAUSE vlc will NOT write 'transforms' to a file!
		#   so the IMPROVED MENCODER code above is being used
		# avwatcher "$outdir/$tempfile" "vlc" "$oldsize" $$ &
		# vlc -I dummy "$target" -vvv --vout-filter=transform --transform-type=$rotate --sout '#transcode{deinterlace,audio-sync}:standard{dst="$tempfile",access=file}' vlc://quit > /tmp/vlc.$$ 2>&1
		target="$outdir/$tempfile"
		oldsize=`du -a -b "$target" | awk '{print $1}'`
		;;
esac

avwatcher "$outdir/$new" "$prog" "$oldsize" $$ &

echo -e "ffident:\n$ffident\n" >/tmp/ffmpeg.$$
echo "ffmpeg command as executed:" >>/tmp/ffmpeg.$$
echo ffmpeg -y -i "$target" $vol $specialopts $ffopts "$outdir/$new" >>/tmp/ffmpeg.$$
echo >>/tmp/ffmpeg.$$
# set -x
ffmpeg -y -i "$target" $vol $specialopts $ffopts "$outdir/$new" 2>&1 | tr '=' '\012' >> /tmp/ffmpeg.$$

case $rotate in
	?)	echo "mencoder rotated original file to $outdir/$tempfile" >>/tmp/ffmpeg.$$
		if test -s "/tmp/$tempfile"
			then	: it worked
			else	echo "but that operation failed" >>/tmp/ffmpeg.$$
		fi ;;
esac

result=`tail -5 /tmp/$prog.$$`
result="$result

The full text output from this conversion is in /tmp/$prog.$$
"

grep "lame: output buffer too small" /tmp/ffmpeg.$$ && note=`mytranslate "
The message about libmp3lame buffer is meaningless.
If that is the only complaint message, the conversion did work."`

grep "bitrate tolerance too small" /tmp/ffmpeg.$$ && note=`mytranslate "
The message about bitrate tolerance too small is due
to the way ffmpeg works.  Seconds between frames can not be
larger than about 2/3 of the frames per second in the video.

POSSIBLE SOLUTION:  Specify a smaller seconds between frames"`

grep "does not support" /tmp/ffmpeg.$$ && note=`mytranslate "
ffmpeg requires more/different options for this conversion
	OR
your source file is unusual and requires special options

POSSIBLE SOLUTIONS:
	specify a video or audio codec
	specify a sample rate
	specify a different output size"`

newsize=`du -a -b "$new" | sed 's/   .*//'`
# show results summary
case $quiet in
	y)	notify="--notification --window-icon=/usr/share/zenity/zenity-progress.png"
		cp /usr/share/zenity/zenity.glade.progress-under /usr/share/zenity/zenity.glade 2>/dev/null ;;
	n)	notify="--info"
		cp /usr/share/zenity/zenity.glade.progress-over /usr/share/zenity/zenity.glade 2>/dev/null ;;
esac

title=`mytranslate "Conversion results"`
text=`mytranslate "Last message in"`
text2=`mytranslate "File size:"`
zenity $notify --title="$title" --text="$target --> $new
$text2 $newsize
$note

$prog $text /tmp/$prog.$$:
$result" &
sleep .25
zpid=`ps -ef | grep -v grep | grep -e "--notification" | awk '{print $2}'`
case "$zpid" in
	'')	;;
	*)	(sleep 60; kill -9 $zpid >/dev/null 2>&1) & ;;
esac

case $autoloop in
	y)	echo -e "choice=\"$choice\"\nbits=\"$bits\"" > /tmp/avffmpeg.env ;;
esac
}
# end of ffmpeg


#####
# ISO conversions
#####
myaviso() {

case $it in
	bchunk)
		which bchunk >/dev/null 2>&1 || exec zenity --warning --text="Must install \"bchunk\" package first!"
		tracks=`grep TRACK $base.cue | awk '{print $2}'`
		zenity --question --text="BIN/CUE to ISO conversion\nCUE shows tracks $tracks\nProgress will be idicated for first track only\nwhich will be named "$base"01.iso" || exit 0
		new="$outdir/$base"
		if test -s "$new"01.iso
			then    zenity --question --text="$new"01.iso" exists - Overwrite?" || new=`zenity --file-selection --filename="$outdir/$new" --save --confirm-overwrite --title="Choose a new file/folder"` || exit 0
		fi
		prog=bchunk
		oldsize=`du -a -b "$base.bin" | awk '{print $1}'`
		avwatcher "$new"01.iso "$prog" "$oldsize" $$ &
		bchunk "$base.bin" "$base.cue" "$new" >/tmp/bchunk.$$ 2>&1
		;;
        daa*|nrg*|b?i*|cdi*|mdf*|pdi*|ccd*|uif*)
		which $it >/dev/null 2>&1 || exec zenity --warning --text="No program \"$it\" found for processing \"$target\"!\n\nFor ISO conversions, install one or more of these packages...\n\nAcetoneISO for:  b5i cdi mdf nrg pdi\nnrg2iso for:     nrg\ndaa2iso for:     daa\nbchunk for:      bin/cue\nccd2iso for:     cdd\nuif2iso for:      uif\n\ncdd2iso is available at: sourceforge.net/projects/ccd2iso\nuif2iso is available at: aluigi.altervista.org/mytoolz.htm\n\nthe rest are in the repositories."
		base=`echo $target | sed 's/....$//'`
                zenity --question --text="Source file is $target\n$ext to ISO conversion\nwhich will be named $base.iso" || exit 0
                new="$outdir/$base".iso
                if test -s "$new".iso
                        then     zenity --question --text="$new".iso" exists - Overwrite?" || new=`zenity --file-selection --filename="$outdir/$new" --save --confirm-overwrite --title="Choose a new file/folder"` || exit 0
				new="$new".iso
                fi
		prog=$ext"2iso"
		oldsize=`du -a -b "$target" | awk '{print $1}'`
		avwatcher "$new" "$prog" "$oldsize" $$ &
		case $ext in
			b?i|pdi)	new="" ;;
		esac
		$prog "$target" "$new" >/tmp/$prog.$$ 2>&1
		;;
esac

}
# end of iso conversions
#####
# Text conversions
#####
myavtext() {
#
# processing text between formats and into other things

# set -x

case $it in
	text)	# image->avconvert sound->espeak html->txt2tags
		out=" image sound html"; height=300 ;;
	doc)	# text->antiword
		out=" text"; height=300 ;;
	rtf)	# text->unrtf html->unrtf
		out=" text html"; height=300 ;;
	odt)	# text->odt2txt xml->odt2txt
		out=" text xml"; height=300 ;;
esac

out=`echo "$out" | sed -e 's/ $ext //' -e "s/ / FALSE /g"`

# loop for output conversion type
while true
do
title=`mytranslate "Convert"`
text=`mytranslate "Source file format"`
text2=`mytranslate "Convert to format"`
choice=`zenity --list --height=$height --title="$title $target" --text="$text $show\n$ffident\n" --radiolist --column "$s1" --column "$text2" $out` || exit 0

if [ -n "$choice" ]
        then      break
fi
done

# pre-check for installed application
case $it$choice in
	textsound)	if ! which espeak >/dev/null 2>&1
			then	zenity --warning --title=HELP --text="\"espeak\" package needs to be installed"
				exit 0
			fi ;;
	texthtml)	if ! which txt2tags >/dev/null 2>&1
			then	zenity --warning --title=HELP --text="\"txt2tags\" package needs to be installed"
				exit 0
			fi ;;
	doctext)	if ! which antiword >/dev/null 2>&1
			then	zenity --warning --title=HELP --text="\"antiword\" package needs to be installed"
				exit 0
			fi ;;
esac

case $it$choice in
	textimage)	prog=convert; myavconvert 2>/tmp/avconvert.debug ;;
	textsound)	title=`mytranslate "Language"`
			text=`mytranslate "Choose a language for pronunciation"`
			pronun=`zenity --list --height=500 --title="$title" --text="$text" --radiolist --column "$s1" --column "$title" FALSE af_afrikaans FALSE bs_bosnian FALSE cs_czech FALSE cy_welsh FALSE de_german FALSE el_greek TRUE en_english FALSE es_spanish FALSE fi_finnish FALSE fr_french FALSE hi_hindi FALSE hr_croatian FALSE hu_hungarian FALSE is_icelandic FALSE it_italian FALSE la_latin FALSE mk_macedonian FALSE nl_dutch FALSE no_norwegian FALSE pl_polish FALSE pt_brazil FALSE ro_romanian FALSE ru_russian FALSE sk_slovak FALSE sr_serbian FALSE sv_swedish FALSE sw_swahihi FALSE vi_vietnam FALSE zh_Mandarin` || exit 0
			pronun=`echo $pronun | sed 's/_.*//'`
			title=`mytranslate "Voice"`
			text=`mytranslate "Choose voice to use"`
			voice=`zenity --list --height=400 --title="$title" --text="$text" --radiolist --column "$s1" --column "$title" FALSE m1_male-1 FALSE m2_male-2 FALSE m3_male-3 FALSE m4_male-4 FALSE f1_female-1 TRUE f2_female-2 FALSE f3_female-3 FALSE f4_female-4 FALSE croak FALSE whisper` || exit 0
			voice=`echo $voice | sed 's/_.*//'`
			text=`mytranslate "Pitch"`
			pitch=`zenity --scale --text="$text" --min-value=0 --max-value=99 --value=50` || exit 0
			text=`mytranslate "Speed"`
			speed=`zenity --scale --text="$text" --min-value=0 --max-value=99 --value=43` || exit 0
			speed=`expr $speed \* 4`
			new=`echo "$target" | \
				sed -e 's/.txt$//' -e 's/$/.wav/'`
			oldsize=`du -a -b "$target" | awk '{print $1}'`
			avwatcher "$outdir/$new" "$prog" "$oldsize" $$ &
			cat "$target" | espeak --stdin -v$pronun+$voice -p $pitch -s $speed -w "$outdir/$new" >/tmp/espeak.$$ 2>&1
			;;
	texthtml)	new=`echo "$target" | \
				sed -e 's/.txt$//' -e 's/$/.html/'`
			oldsize=`du -a -b "$target" | awk '{print $1}'`
			avwatcher "$outdir/$new" "$prog" "$oldsize" $$ &
			txt2tags --infile="$target" --outfile="$outdir/$new" -t xhtml >> /tmp/txt2tags.$$ 2>&1
			if test -s /tmp/txt2tags.$$
			then	title=`mytranslate "program output"`
				zenity --info --title="txt2tags $title" --text=`cat /tmp/txt2tags.$$`
			fi
			rm -f /tmp/txt2tags.$$
			;;
	doctext)	new=`echo "$target" | \
				sed -e 's/.doc$//' -e 's/$/.txt/'`
			title=`mytranslate "Options"`
			text=`mytranslate "Include either of these?

r = \"revisioning text\"
s = \"hidden text\""`
			text2=`mytranslate "Embedded text"`
			incl=`zenity --list --height=300 --title="$title" --text="$text" --checklist --column "$s1" --column "$text2" FALSE r FALSE s ` || exit 0
			case $incl in
				'')	;;
				*)	opts=`echo "$incl" | sed 's/|/ /g' | \
					sed 's/^/ /' | sed 's/ / -/g'` ;;
			esac
			oldsize=`du -a -b "$target" | awk '{print $1}'`
			avwatcher "$outdir/$new" "$prog" "$oldsize" $$ &
			antiword $opts "$target" > "$outdir/$new" 2>>/tmp/antiword.$$
			if test -s /tmp/antiword.$$
			then	zenity --info --title="antiword output" --text=`cat /tmp/antiword.$$`
			fi
			rm -f /tmp/antiword.$$
			;;
	*)	text=`mytranslate "Not ready yet"`
		zenity --info --title="OOPS!" --text="$text"; exit 0 ;;

esac
}
# end of text

#####
# Initial script
#####
PATH=$PATH:.:~/.gnome2/nemo-scripts; export PATH

# check some stuff first...
# have we been renamed?
case `basename $0` in
	avconvert)	;;
	*)		exec xterm -hold -geometry 70x2 -bg red -T "Please rename the script back to 'avconvert'" -e true ;;
esac
# if zenity is not installed, use xterm to display a warning
which zenity >/dev/null 2>&1 || exec xterm -hold -geometry 50x2 -bg red -T "OOPS! Must install zenity first!" -e true
# if imagemagick is not installed, display warning
which convert >/dev/null 2>&1 || im="\n\t\"ImageMagick\""
# if ffmpeg is not installed, display warning
which ffmpeg >/dev/null 2>&1 || ffmpeg="\n\t\"ffmpeg\""
# etc, etc
which wget >/dev/null 2>&1 || wget="\n\t\"wget\""
which curl >/dev/null 2>&1 || curl="\n\t\"curl\""
which gawk >/dev/null 2>&1 || gawk="\n\t\"gawk\""
which links >/dev/null 2>&1 || which elinks >/dev/null 2>&1 || links="\n\t\"links\" or \"elinks\""
which bc >/dev/null 2>&1 || bc="\n\t\"bc\""

# special handling for translate
translate="\n\t\"libtranslate\" or \"libtranslate-bin\"\n\t  (whichever your distro offers)"
which translate-bin 2>&1 >/dev/null && info translate-bin | grep -q "translate a text" && trbin=/usr/bin/translate-bin
which translate >/dev/null 2>&1 && info translate | grep -q "translate a text" && trbin=/usr/bin/translate
case $trbin in
        /*)     translate="" ;;
esac

case $im$ffmpeg$wget$curl$gawk$links$bc$translate in
	?*)	exec zenity --warning --text "Please install the package$im$ffmpeg$wget$curl$gawk$links$bc$translate\nand start the conversion again!" ;;
esac

# the config files are now moved....
mkdir -p ~/.config/avconvert
if test -f ~/.avconvert
	then	for each in ~/.avconvert*
		do
			new=`echo "$each" | sed 's/^.*\/.//'`
			mv $each ~/.config/avconvert/$new
		done
fi

# translation

langlist=`$trbin -f en -l | \
	sed -e 's/.*-> //' -e 's/ /=/' -e 's/:.*//' | \
	tr -d '()\040'`

dlang=`echo "$LANG" | sed 's/_.*//'`
langlist=`echo -e "en=English\n$langlist" | sort | uniq | \
	sed -e 's/^/FALSE /' -e "/ $dlang=/s/FALSE/TRUE/"`

online=n
#echo "$langlist" | grep English >/dev/null && online=y
if ping -c 1 google.com >/dev/null 2>&1
	then	online=y
fi

# if language preference file is out of date, remove it
if grep "lang=" ~/.config/avconvert/avconvert.lang >/dev/null 2>&1
	then	:
	else	rm -f ~/.config/avconvert/avconvert.lang
fi

# requirements for translations
if which curl >/dev/null 2>&1
	then	curlok=y
	else	curlok=n; text="$text\n\tcurl"
fi
if which elinks >/dev/null 2>&1
	then	linksok=y; links=elinks
	else	if which links >/dev/null 2>&1
			then	linksok=y; links=links
			else	linksok=n; text="$text\n\telinks  -OR-  links"
		fi
fi

# if we are not online, do not ask about language
if [ "$online" = "n" ]
	then	lang=en
	else
# check language
if test -s ~/.config/avconvert/avconvert.lang
	then	. ~/.config/avconvert/avconvert.lang
		case $curlok$linksok in
			*n*)	if [ "$lang" = "en" ]
					then	: ok
					else	zenity --info --title="Required for translation" --text="Please install$text\nfor translation"
						lang="en"
				fi
				;;
		esac
		export lang service
	else	lang=`zenity --list --height=520 --title="Language" --text="Choose language for all text" --radiolist --column="Select" --column="Language" $langlist` || exit 0
		lang=`echo $lang | sed 's/=.*//'`
		echo "lang=$lang" > ~/.config/avconvert/avconvert.lang
		export lang
		if [ "$lang" = "en" ]
			then	online=n
			else	text="Please install the package(s):\n"
				case $curlok$linksok in
					*n*)	zenity --info --title="Packages needed" --text "$text\n\nfor the translation feature.\nProceeding in English until installed."
						online=n ;;
				esac

				#service=`zenity --list --title="Service" --text="Which service should be used" --radiolist --column="Select" --column="Language" TRUE google FALSE babel` || exit 0
				#echo "service=$service" >> ~/.config/avconvert/avconvert.lang
				#export lang service
				export lang
		fi
		title=`mytranslate "Language Preference"`
		text=`mytranslate "When the internet is available, this script will
send text through the translation service.

If there is no internet connection, everything will be in English.
If the internet is slow, translations may not work well.  Please
tell me if there are problems so that I can improve this.

Your language is stored in ~/.config/avconvert/avconvert.lang
Remove or edit that file to change language."`
		[ "$lang" = "en" ] && text="You have chosen to display text in English.

You can change the language by editing or removing
~/.config/avconvert/avconvert.lang"
		zenity --info --title="$title" --text="$text"
fi
fi

# if language is EN, we do not need to translate
case $lang in
	en)	online=n ;;
esac

if grep "trash=" ~/.config/avconvert/avconvert >/dev/null 2>&1
	then	: UP TO DATE
	else	rm -f ~/.config/avconvert/[Aa]vconvert
fi

if test -s ~/.config/avconvert/avconvert
	then	: defaults already set
	else	echo -e "destdir=n\nautoloop=n\nzenityfix=n\nquiet=n\ntrash=n" > ~/.config/avconvert/avconvert
		title=`mytranslate "Set Defaults"`
		text=`mytranslate "This is your first run of avconvert.

The file ~/.config/avconvert/avconvert can save some default behaviors.  You can create one now by selecting from the options below,
and you can change it at any time by editing it directly or by removing it, which will trigger this dialogue to reappear.

Read each option below and choose your prefrence followed by OK, or click Cancel to defer this until later."`
		p1=`mytranslate "Always pop up to ask for a destination into which to save converted files"`
		p2=`mytranslate "When multiple files are selected, process each one in the same way"`
		p3=`mytranslate "Check zenity defaults and offer to fix them so popups are OVER rather than UNDER"`
		p4=`mytranslate "Quiet mode - use 'notification' instead of 'info' to show some conversion results"`
		p5=`mytranslate "VERY Quiet mode - NEVER show progress indicators, work silently"`
		p6=`mytranslate "After conversions, offer to move originals to ~/Desktop/avconvert-Trash"`
		behavior=`zenity --list --height=400 --title="$title" --text="$text" --checklist --column="" --column="Description" TRUE "$p1 (destdir=y)" TRUE "$p2 (autoloop=y)" TRUE "$p3 (zenityfix=y)" TRUE "$p4 (quiet=y)" FALSE "$p5 (veryquiet=y)" FALSE "$p6 (trash=n)"` || exit 0
echo "$behavior" | tr '|' '\012' | sed -e 's/^.*(//' -e 's/.$//' | grep "=" >> ~/.config/avconvert/avconvert

		title=`mytranslate "Set image default"`
		text=`mytranslate "When converting images, the system can set a default for the type of file to be converted to.

choose one of the following"`
		col=`mytranslate "Default image extension"`
		i1=`mytranslate "No default should be pre-selected"`
		i2=`mytranslate "Create an image of the same type as the source"`
		i3=`mytranslate "Default image type should be"`
		imageext=none
		imageext=`zenity --list --height=370 --title="$title" --text="$text" --radiolist --column="" --column="$col" TRUE "$i1 (imageext=none)" FALSE "$i2 (imageext=same)" FALSE "$i3 gif (imageext=gif)" FALSE "$i3 jpg (imageext=jpg)" FALSE "$i3 ico (imageext=ico)" FALSE "$i3 pdf (imageext=pdf)" FALSE "$i3 png (imageext=png)" FALSE "$i3 tif (imageext=tif)"` || exit 0

echo "$imageext" | tr '|' '\012' | sed -e 's/^.*(//' -e 's/.$//' >> ~/.config/avconvert/avconvert
. ~/.config/avconvert/avconvert

echo "# Defaults file for avconvert, created `date`
destdir=$destdir
autoloop=$autoloop
zenityfix=$zenityfix
quiet=$quiet
veryquiet=$veryquiet
trash=$trash
imageext=$imageext
" > ~/.config/avconvert/avconvert
fi

# set everything to 'defaults' regardless of preferences file
# in case there's no file, or some are missing
destdir=y; autoloop=x; zenityfix=y; imageext=none; quiet=n trash=n

# now "dot" the file if it is there
# due to google translator, be sure it is linked to Avconvert as well
if test -s ~/.config/avconvert/avconvert
	then	. ~/.config/avconvert/avconvert
	if cmp ~/.config/avconvert/avconvert ~/.config/avconvert/Avconvert >/dev/null 2>&1
		then	: alldone
		else	rm -f ~/.config/avconvert/Avconvert
			ln ~/.config/avconvert/avconvert ~/.config/avconvert/Avconvert
	fi
fi

# here we go.....

# let's get some common translated phrases in advance first:
# export them all!!
s1=`mytranslate "Select"`; export s1


while true
do
	case $1 in
		--no-destdir)	destdir=n; shift ;;
		--no-loop)	autoloop=n; shift ;;
		--no-zenityfix)	zenityfix=n; shift ;;
		*)		break ;;
	esac
done

case $1 in
	'')	which avconvert >/dev/null 2>&1 || exec zenity --warning --text="Attention needed:\n\nNo source files were selected.  That is OK,\nbut for this to work properly, the avconvert program must be copied or linked\nto a location that is in your PATH.\nOr you may change your PATH to include the location of this script."
		title=`mytranslate "Select source files. They should all of same type (all images, or all videos, etc)"`
		files=`zenity --title="$title" --file-selection --multiple --separator="|"` || exit 0
		files=`echo "$files" | sed -e 's/^/"/' -e 's/$/"/' -e 's/|/" "/g'`
		echo "avconvert $* $files" > /tmp/avconvert.rerun
		sh /tmp/avconvert.rerun &
		rm -f /tmp/avconvert.rerun
		exit 0
		;;
esac

# if this is not a "fixable" zenity, do not try to fix it
# (at least) ubuntu 9.10 lacks the configuration file
if test -s /usr/share/zenity/zenity.glade
	then	: good
	else	zenityfix=n
fi
case $zenityfix in
	n)	;;
	*)
if test -s /usr/share/zenity/zenity.glade.orig
	then	: already done
	else	cat << ZenityFix > /tmp/zenity.fix
# zenity.fix
# written by
# marc brumlik, tailored softare inc
# distributed with
# avconvert, posted on gnome-look, to correct the behavior of zenity
# The driectory containing zenity.glade is:
DIR=/usr/share/zenity

if test -s \$DIR/zenity.glade
	then	cd \$DIR
	else	echo -e "The file /usr/share/zenity/zenity.glade\ncan not be found!\n\nPlease modify the script /tmp/zenity.fix with the correct\nlocation of the file 'zenity.glade'.\nThen execute it directly from the command line.\n\nExiting now...\n\nPress Return \c"; read fred; exit 0
fi
echo -e "\nModifying the file \$DIR/zenity.glade\n\nA safe copy of your file is being saved as zenity.glade.orig"
if test -s zenity.glade.orig
	then	echo "It appears that this has been run before."
		echo "Doing it again..."
	else	cp zenity.glade zenity.glade.orig
fi
cat zenity.glade.orig | sed '/focus_on_map/s/False/True/' > zenity.glade
cp zenity.glade zenity.glade.progress-over
progline=\`grep -n "zenity_progress_dialog" zenity.glade | sed 's/:.*//'\`
focusline=\`sed -n "\$progline,\$"p < zenity.glade | grep -n focus_on_map | \
	head -1 | sed 's/:.*//'\`
targetline=\`echo -e "\$progline + \$focusline - 1 \n quit" | bc\`
sed "\$targetline s/True/False/" < zenity.glade.progress-over > zenity.glade.progress-under
chmod 666 /usr/share/zenity/zenity.glade
echo -e "/tmp/zenity.fix now exiting\n\nPress Return \c"; read fred
ZenityFix
		chmod 755 /tmp/zenity.fix
		if which xterm >/dev/null 2>&1
			then	message=`mytranslate "Click OK if you would like this to be run for you right now, or if you prefer, click Cancel to prevent avconvert from doing this.  If you Cancel, avconvert will create a script /tmp/zenity.fix which you can run as \'root\' manually.  This will modify your Zenity defauts so its windows appear on top of any others."`
			else	message=`mytranslate "This fix can not be auto-run for you because you do not have \'xterm\' installed.  Click Cancel and execute /tmp/zenity.fix as \'root\'. This will modify Zenity defaults so its windows appear on top of any others."`
		fi
		title=`mytranslate "Zenity defaults"`
		text1=`mytranslate "The Linux utility that avconvert uses to pop up dialogs is called Zenity.  In some releases, these dialogs pop up underneath existing windows.  This makes reading the output and responding to prompts from avconvert very inconvenient.

Your installed Zenity version is one which behaves this way.  For your convenience, a small program named 'zenity.fix' has just been written in your /tmp directory."`
		text2=`mytranslate "NOTE: this window and some others can be permanently silenced either with command line options or by creating a ~/.config/avconvert/avconvert config file.  Read the end of the avconvert script for details.
Also, this window will not reappear once the zenity defaults are changed OR as long as the /tmp/zenity.fix file exists."`
		zenity --question --title="$title" --text="$text1\n\n$message\n\n$text2" && xterm -e ' echo -e "To fix zenity requires Root \c"; su -c /tmp/zenity.fix '
fi
	;;
esac

case $quiet in
	y)	cp /usr/share/zenity/zenity.glade.progress-under /usr/share/zenity/zenity.glade 2>/dev/null ;;
	n)	cp /usr/share/zenity/zenity.glade.progress-over /usr/share/zenity/zenity.glade 2>/dev/null ;;
esac

rm -f /tmp/avconvert.env /tmp/avffmpeg.env

for each in "$@"
do
	allargs=`echo -e "$allargs\n$each"`
done
allargs=`echo -e "$allargs" | grep -v "^$"`
chkavi=`echo -e "$allargs" | sed 's/^.*\.//' | egrep "avi$|AVI$" | sort | \
	uniq | wc | awk '{print $1}'`
case $chkavi in
	1)	qtyavi=`echo -e "$allargs" | wc | awk '{print $1}'`
		case $qtyavi in
			[01])	;;
			*)	multiavi=y ;;
		esac ;;
esac
case $multiavi in
	y)	title=`mytranslate "Merge AVI Files"`
		text1=`mytranslate "You have selected multiple AVI files."`
		text2=`mytranslate "Press CANCEL to proceed with normal conversions."`
		text3=`mytranslate "If these files all have the same audio and video settings"`
		text4=`mytranslate "you may click OK to combine them to a single AVI file."`
		text5=`mytranslate "The final file will be named MergedAVI.avi"`
		if zenity --question --title="$title" --text="$text1\n\n$text2\n\n$text3\n$text4\n\n$text5"
			then	if ! which avimerge >/dev/null 2>&1
					then    zenity --warning --title=HELP --text="The program \"avimerge\" is needed but was was not found.\nThis should be provided by the \"transcode\" package.\nPlease install that and try again."
					exit 0
				fi

				dest=`echo -e "$allargs"| head -1`
				dest=`dirname "$dest"`
			oldsize=`du -b -c "$allargs" | grep total | awk '{print $1}'`
			avwatcher "$dest/MergedAVI.avi" "avimerge" "$oldsize" $$ &
				avimerge -o "$dest/MergedAVI.avi" -i "$@" >/tmp/avimerge.$$ 2>&1
				exit 0
		fi ;;
esac

chkvob=`echo -e "$allargs" | sed 's/^.*\.//' | egrep "vob$|VOB$" | sort | \
	uniq | wc | awk '{print $1}'`
case $chkvob in
	1)	qtyvob=`echo -e "$allargs" | wc | awk '{print $1}'`
		case $qtyvob in
			[0])	;;
			*)	multivob=y ;;
		esac ;;
esac
case $multivob in
	y)	title=`mytranslate "Merge VOB Files"`
		text1=`mytranslate "You have selected one or more VOB files."`
		text2=`mytranslate "Press CANCEL to proceed with normal conversions."`
		text3=`mytranslate "You may click OK to combine them to a single AVI file"`
		text4=`mytranslate "with all options set to rip from a DVD."`
		text5=`mytranslate "The final file will be named $HOME/Desktop/MergedVOB.avi"`
		if zenity --question --title="$title" --text="$text1\n\n$text2\n\n$text3\n$text4\n\n$text5"
			then	dest=`echo -e "$allargs"| head -1`
				dest=`dirname "$dest"`
			oldsize=`du -b -c "$allargs" | grep total | awk '{print $1}'`
			avwatcher "$HOME/Desktop/MergedVOB.avi" "ffmpeg" "$oldsize" $$ &
			cat "$allargs" | ffmpeg -i - -f avi -vcodec mpeg4 -b 800k -g 300 -bf 2 -acodec libmp3lame -ab 128k $HOME/Desktop/MergedVOB.avi
			exit 0
		fi ;;
esac

until [ -z "$1" ]
do

fileargs="$fileargs
$1"

echo "$1" > /tmp/files

targetpath=$1; shift
target=`basename "$targetpath"`
# had used this due to an earlier bug, but dirname is better
# dir=`echo "$targetpath" | sed "s/\/\$target//"`
dir=`dirname "$targetpath"`

case "$dir" in
	*/*)	;;
	*)	dir=`pwd` ;;
esac

test -d "$dir" && cd "$dir"

dir=`pwd`

if test -f "$target"
	then	if test -s "$target"
			then	: OK
			else	text=`mytranslate "Source file is EMPTY!"`
				exec zenity --warning --text="$target\n\n$text"
		fi
	else	text=`mytranslate "Source file NOT FOUND!"`
		exec zenity --warning --text="$target\n\n$text"
fi

echo destdir: $destdir
echo target: $target
echo outdir: $outdir

case $outdir in
	'')
		case $destdir in
			n)	outdir=`pwd` ;;
		esac

		case "$outdir" in
			'')	outdir=`dirname "$target"` ;;
		esac

		case $destdir in
			y)	outdir="" ;;
		esac

		if test -z "$outdir"
			then	cwd=`pwd`
		title=`mytranslate "Destination folder (CANCEL will write to SOURCE DIRECTORY)"`
				outdir=`zenity --file-selection --directory="$dir" --title="$title"`
				if test -z "$outdir"
					then	outdir=$cwd
				fi
		fi
	;;
esac

case "$target" in
	*.*)	;;
	*)	zenity --question --title="What to do?" --text="It would be nice if \"$target\" had an extension...\nRenaming this file is recommended!\n\nTo have avconvert proceed anyway, press OK.\nTo exit now so you can rename the file, press Cancel" || exit 0 ;;
esac

type=`file "$target" | tr '[A-Z]' '[a-z]' | sed 's/^.*://'`
mtype=`file -i "$target" | tr '[A-Z]' '[a-z]' | sed 's/^.*://'`
show=`file "$target" | awk -F: '{print $2}'`
case "$target" in
	*.rm|*.rmvb|*.???|*.????)	ext=`echo "$target" | sed 's/^.*\.//'` ;;
	*)		ext="" ;;
esac
lcext=`echo "$ext" | tr '[A-Z]' '[a-z]'`
# imagemagick identify does not properly execute mencoder on *avi files
# and instead generated a png image for every frame.
# until fixed, this like should be commented out.
## ident=`identify "$target" 2>/dev/null | sed "s/^.*$ext //"`
# ffmpeg provides lots of info anyway
ffident=`ffmpeg -i "$target" 2>&1 | tail -4 | head -3`
if echo "$ffident" | grep Unable >/dev/null
	then	ffident=""
fi
echo "$ffident" | grep audio >/dev/null && fftype=audio
echo "$ffident" | grep video >/dev/null && fftype=video
[ "$fftype" = "video" ] && echo "$ffident" | grep "bitrate: N/A" && fftype=image
[ "$fftype" = "image" ] && imident=`echo "$ffident" | grep Video | \
	awk -F, '{print $1, $2, $3, $4}' | sed 's/^.*://'`

#	based on source file, what might the destinations be?
# 	what application will we use to create them?
#	the case wildcards are things we know how to convert FROM
#	"prog" is the actual conversion program
#	"out" is a list of formats we can choose to convert TO
it=""; av=""	# for "image/text" and "audio/video"
# strings from file, and extensions, which imply input file type
case "$fftype$type$mtype$lcext" in
	*bin)
		base=`echo "$target" | sed 's/.bin$//'`
		if test -s "$base".cue
			then	prog=iso; it=bchunk
		fi ;;
	*cue)
		base=`echo "$target" | sed 's/.cue$//'`
		if test -s "$base".bin
			then	prog=iso; it=bchunk
		fi ;;
	*daa)
		prog=iso; it=daa2iso ;;
	*nrg)
		prog=iso; it=nrg2iso ;;
	*b?i)
		prog=iso; it=b5i2iso ;;
	*cdi)
		prog=iso; it=csi2osi ;;
	*mdf)
		prog=iso; it=mdf2iso ;;
	*pdi)
		prog=iso; it=pdi2iso ;;
	*ccd)
		prog=iso; it=ccd2iso ;;
	*uif)
		prog=iso; it=uif2iso ;;
	*text/plain*|*ascii*)
		# recognized plain text formats, out to other text or image
		prog="text"; it="text" ;;
	*image*|*pdf|*ico|*orf)
		# recognized image formats, output will also be an image
		prog="convert"; it="image" ;;
	*video*|*3g2|*3gp|*ogv|*mkv|*mpg|*wmv|*asf|*mp4|*ogg|*rm|*rmvb)
		# recognized multimedia formats, output to multimedia or audio
		prog="ffmpeg"; av="video" ;;
	*audio*|*mp3|*wav|*m4a|*wma)
		# recognized audio-only formats, output to audio
		prog="ffmpeg"; av="audio" ;;
	*msword*)
		# micro$oft office word document, v2 / v6 or newer
		prog=text; it="doc" ;;
	text/html)
		prog=text; it="html" ;;
	*text/rtf*)
		prog=text; it="rtf" ;;
	*Unicode*)
		prog=text; it="uni" ;;
	*opendocument*|*openoffice*)
		prog=text; it="odt" ;;
	*openoffice*)
		prog=text; it="oo" ;;
	*)	prog=`zenity --list --height=520 --title="Unknown!" --text="Not sure what to do with this file!\n\nTarget file: \"$target\"\n\nInformation found:\n$type\n$mtype\n$ffident$ident\n\n\nBut, it is likely that though this file type was not\nexplicitly recognized by avconvert, it can be handled\nby convert (Images) or ffmpeg (Audio/Video).\n\nIf you would like to TRY, choose the utility you feel\nwould be appropriate and avconvert will do its best.\n\n" --radiolist --column "Select" --column "Utility to use" FALSE convert FALSE ffmpeg` || exit 0
		case $prog in
			ffmpeg)		av=`zenity --list --title="Select" --text="Tell ffmpeg whether this file is:" --radiolist --column "Select" --column "Content type" FALSE audio FALSE video` || exit 0 ;;
			convert)	it=image ;;
		esac
		;;

esac

# export everything we know so far and launch the appropriate function quality

case $prog in
	ffmpeg|convert)	audiovideo=y ;;
	*)		audiovideo=n ;;
esac
case "$1$audiovideo$autoloop" in
	?*yx)	autoloop=n
		zenity --question --title="Auto-Loop though Source Files??" --text="You have selected multiple source files.  Avconvert will loop through them and convert them all.\n\n*IF* you know that all source files are of the same type\n   (images, audio, etc)\nand *IF* you want them all of them converted the same way\n   (images->1024/jpg, audio->128bit/mp3, etc)\n*THEN* click OK\n\n     But...\n\n*IF* they the source files are of different types\n   (not ALL images or not ALL videos)\nor *IF* you want per-file control of how each source is handled\n*THEN* click Cancel\n\nOK will auto-loop, Cancel will treat each file separately." && autoloop=y
		;;
esac

today=`date +%Y%m%d`
if grep "$today" ~/.config/avconvert/versioncheck >/dev/null 2>&1
	then	: already checked
	else	echo "$today" > ~/.config/avconvert/versioncheck
		versioncheck=`wget -q --timeout=3 --tries=1 \
		http://www.gtk-apps.org/CONTENT/content-files/92533-avconvert.tar.gz -O - | \
		gunzip 2>/dev/null | grep -a version= | head -1 | \
		sed -e 's/"$//' -e 's/^.*"//'`
		case "$versioncheck" in
			[0-9].[0-9][0-9]*)
				case "$versioncheck" in
					"$version")	;;
					*)	zenity --info --height=500 --title="A newer version 'avconvert' is available for download" --text="You are running version\n\t$version\n\nAvailable for download\n\t$versioncheck"
						;;
				esac
		esac
fi

export dir target ext type mtype show ident ffident it av prog autoloop base
myav$prog

# this 'done' is for looping through multiple selected input files
done

case $overwrite in
	YES)	;;
	*)	case $trash in
			y)	totrash=`zenity --list --title="Send to Trash?" --height=210 --text="You can move the source file(s) to\n$HOME/Desktop/avconvert-Trash" --radiolist --column "Select" --column "Trashcan the source files?" TRUE NO FALSE YES` || exit 0
			case $totrash in
				NO)	;;
				YES)	mkdir -p ~/Desktop/avconvert-Trash/$$ 2>&1
					echo "$fileargs" | while read each
					do mv "$each" ~/Desktop/avconvert-Trash/$$; done
					;;
			esac
			;;
		esac
		;;
esac

exit 0

#####
# READ ME
#####
avconvert

marc brumlik, tailored software inc, Thu Nov 13 18:50:35 CST 2008
tsi-inc@comcast.net

#######
# IF YOU READ NO FURTHER THAN THIS, please note that when using
# "kcolorchooser" in text-to-image, there is a delay after choosing your
# color before the next window from avconvert comes up.  I have no idea why
# kcolorchooser is behaving this way.
#######

This project started out because I needed to create jpg files of numerous
resolutions from a number of source files and wanted an automatic way to
generate them more quickly.  Then my daughter asked for a way to convert
"unplugged" YouTube files into formats her friends could view.
Combining these two short scripts is where avconvert began.

Upon completion of each use of avconvert, a file for debugging purposes
is written to, with lots of output showing exactly what the script
has done.  This can help a lot if you are getting unexpected results.
The file name is derived from the conversion, followed by "dot" PID.  In the
case of text->image and if intermediary files were generated, there will be
another "dot" and a sequence number.  These files will be named:
	/tmp/convert.$$
	/tmp/convert.$$.$count
	/tmp/ffmpeg.$$
	/tmp/avconvert.debug
	/tmp/txt2tags.$$
	/tmp/antiword.$$
and more may be added in the future.

You can create a startup file ~/.config/avconvert/avconvert to contain preferences.
Currently there are three items that can be specified there.
A ~/.config/avconvert/avconvert which specifies the defaults for these would contain this:
	destdir=y
	autoloop=y
	zenityfix=y
The line "destdir" specifies whether or not there should be a popup prompting
for a destination directory for converted files.  The line "autoloop" determines
whether, if multiple files are selected, you will be prompted and asked if you
want to treat them all the same way.  Y means prompt, N means always treat the
files individually.  THe line "zenityfix" has to do with the prompt which offers
to fix zenity popups so they appear above (instead of below) other items on the
desktop.  Y means detect "popunder" and offer to fix it, N means ignore current
zentiy configuration.

Things you might want to customize (starting from the top of the script):

Too much verbage that gives information about source files?
	comment out the "ident=" and "ffident=" lines

Too much window activity and want to eliminate "progress" window?
	uncomment the "exit 0" at the top of "myavconvert-watch"

To add more extensions to recognized file types for image/video/audio:
	the script uses two different forms of output from the
	"file" command plus the source file extension, to decide
	what type of file it has to work with.  "file" isn not
	always useful, which is why extensions are needed at all.
	find the comment "# strings from file".  Below that are
	four cases.  Each contains first something that may have
	been output by "file", followed by a set of extensions.
	Just follow the example to add more extensions.

To add more extensions to the default list of output file types:
	Find the comment line beginning "Show appropriate output".
	Below that are four entries - two for "convert" and two
	for "ffmpeg".  These are each divided into two more.
	Just add any extension you like into that space-separated
	list (do NOT remove the leading space in the list).

To prevent a "default" output type for images:
	Currently the default output for images is the same as
	the source file type.  To prevent this, find the comment
	"This line sets default" and, on the line for "convert",
	and comment out the "out=" line below that.

To change the list of image resolutions presented:
	Find the comment "# set resolution here".  Add or
	remove any resolutions from the list.  Also, setting
	one or more from FALSE to TRUE will cause them to be
	checkboxed when the window appears.

To change the list of jpg quality settings:
	Find the comment "# if this is a jpeg".  Add or remove.
	You may also set the default by changing a FALSE to TRUE

To change the list of font sizes:
	Modify the line beginning "sizelist=".

To change bitrate choices for ffmpeg audio conversion:
	Find the comment line "# audio bitrate".
	To set a default bitrate, change one of the FALSE to TRUE.

To prevent the final window showing summary after completion:
	(Not recommeded, since this is ALSO where you might see
	diagnostic output after a failure)
	Find the comment " Show results summary" and comment out the
	"zenity" line that follows it.


COMMENTS WELCOME!
