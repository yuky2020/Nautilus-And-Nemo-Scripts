#!/bin/bash

########################################################################
##		Split Lossless Audio by Cue File
##		By CokiDVD
##		Contains some code from: 
##		http://forum.ubuntu.org.cn/viewtopic.php?f=74&t=67658
##
##		IMPORTANT:
##		Needs shntool >= 3.0.8 For WAVPACK files
########################################################################



# Functions
# Input check for flac
is_flac ()
{
	file -b "$1" | grep 'FLAC' || echo $1 | grep -i '\.flac$'
}
# Input check for ape
is_ape ()
{
	file -b "$1" | grep 'Monkey' || echo $1 | grep -i '\.ape$'
}
# Input check for wavpack
is_wavpack ()
{
	file -b "$1" | grep 'data' || echo $1 | grep -i '\.wv$'
}
########################################################################
# Check for gawk package
if !(which gawk 2>/dev/null)
then
	yad --text="This script requires the gawk package" --image="error" --button=Ok --title="ERROR"
	exit 1
fi

# Check for shntool package
if !(which shnsplit 2>/dev/null)
then
	yad --text="This script requires the shntool package" --image="error" --button=Ok --title="ERROR"
	exit 1
fi

# Check for cuetools package
if !(which cuetag 2>/dev/null)
then
	yad --text="This script requires the cuetools package" --image="error" --button=Ok --title="ERROR"
	exit 1
fi

# Check for flac package
if !(which flac 2>/dev/null)
then
	yad --text="This script requires the flac package" --image="error" --button=Ok --title="ERROR"
	exit 1
fi

# Check for mac package
if !(which mac 2>/dev/null)
then
	yad --text="This script requires the mac package" --image="error" --button=Ok --title="ERROR"
	exit 1
fi

# Check for wavpack package
if !(which wavpack 2>/dev/null)
then
	yad --text="This script requires the wavpack package" --image="error" --button=Ok --title="ERROR"
	exit 1
fi

# Check for lame package
if !(which lame 2>/dev/null)
then
	yad --text="This script requires the lame package" --image="error" --button=Ok --title="ERROR"
	exit 1
fi

# Check for mp3info package
if !(which mp3info 2>/dev/null)
then
	yad --text="This script requires the mp3info package" --image="error" --button=Ok --title="ERROR"
	exit 1
fi

# Check for trash package
if !(which trash 2>/dev/null)
then
	yad --text="This script requires the trash-cli package" --image="error" --button=Ok --title="ERROR"
	exit 1
fi

# Check for yad package
if !(which yad 2>/dev/null)
then
	yad --text="This script requires the yad package" --image="error" --button=Ok --title="ERROR"
	exit 1
fi

########################################################################

# Some checks before start splitting

if  !(is_ape "$1" || is_flac "$1" || is_wavpack "$1")
then
	yad --text="This script only takes FLAC, APE and WAVPACK files\!" --image="error" --button=Ok --title="ERROR"
    	exit 1
fi

dir=`dirname "$1"`

cd "$dir"

cue=`find *.cue`
if [ ! $? = 1 ] && [ `echo "$cue" | wc -l` = 1 ]
then
	file="$cue"
else
	file="${1%.*}.cue"
	if [ ! -f "$file" ]
	then
		
			file=$(yad --file --center --width=600 --height=400 --filename="*.cue" --title="Select .cue file")
		
		  case $? in
		             0)
		                    echo "\"$file\" selected.";;
		             1)
												yad --text="No .cue file selected" --image="error" --button=Ok --title="ERROR";
												exit 1;;
		            -1)
		                   	yad --text="No .cue file selected" --image="error" --button=Ok --title="ERROR";
												exit 1;;
		  esac 
	fi
fi

i=0
while [ -f "temp$i" ]; do
	i=$(($i+1))
done
> temp$i
iconv -f gb18030 -t utf8 "$file" > "temp$i" && mv "temp$i" "$file"
rm -f "temp$i"

tracks=`gawk -vRS="TRACK " 'END {print NR-1}' "$file"`

nperformer=`gawk -vRS="PERFORMER" 'END {print NR-1}' "$file"`

all_titles=`gawk -vRS='TRACK ' -vFS='\n' \
		'{j=0;for(i=1;i<=NF;i++){if($i~/TITLE/){print $i;j=1}}};j==0 {print "TITLE \"#####\""}' "$file" | \
		gawk -F "\"" 'NR>=2 {printf("%s|",$2)}'`

if [ "$nperformer" -ne 1 ]
then
	all_artists=`gawk -vRS='TRACK ' -vFS='\n' \
	'{j=0;for(i=1;i<=NF;i++){if($i~/PERFORMER/){print $i;j=1}}};\
	j==0 {print "PERFORMER \"#####\""}' "$file" | gawk -F "\"" 'NR>=2 {printf("%s|",$2)}'`
else
	oneartist=`gawk -vRS='TRACK ' -vFS='\n' \
	'{j=0;for(i=1;i<=NF;i++){if($i~/PERFORMER/){print $i;j=1}}};j==0 {print "PERFORMER \"#####\""}' "$file" | \
	gawk -F "\"" 'NR==1 {printf("%s",$2)}'`
fi

album=`gawk -vRS='TRACK ' -vFS='\n' \
'{j=0;for(i=1;i<=NF;i++){if($i~/TITLE/){print $i;j=1}}};j==0 {print "TITLE \"#####\""}' "$file" | \
gawk -F "\"" 'NR==1 {printf("%s",$2)}'`

date=$(egrep '^REM DATE ' "$file" | cut -c 10- | tr -d '\r')
genre=$(egrep '^REM GENRE ' "$file" | cut -c 11- | tr -d '\r')

tracklist=`echo "$all_titles" | gawk -vvar=$tracks -vRS='|' 'NR>=1 && NR<=var {printf("%02d. %s\n",NR,$0)}'`

cp "$file" "$file.tmp"

while [ 1 ]
do
settings=`yad --title="Split Lossless" --form --text="<big> $(echo "$album" | sed 's/&/&amp;/g') by $(if [ "$nperformer" -ne 1 ]
 then
  echo ${all_artists%%|*} | sed 's/&/&amp;/g'
   else
    echo $oneartist | sed 's/&/&amp;/g'
     fi) (${date})</big>\n <i>$(echo $genre | sed 's/&/&amp;/g') - ${tracks} tracks</i>  $(if [ "$trck_filter" != "" ] 
     then 
     	echo "<span foreground=\"red\"><i> <b> Tracks Selected: " "${trck_filter%%?}" "</b></i></span>" 
     fi)<small>\n\n$(echo "$tracklist" | sed 's/&/&amp;/g')</small>" --field="Output Format:CB" "$(case "$oformat" in
     "Flac") echo "Flac!Mp3-CBR-320kbps!Mp3-VBR~245kbps!Mp3-CBR-192kbps";;
     "Mp3-CBR-320kbps") echo "Mp3-CBR-320kbps!Mp3-VBR~245kbps!Mp3-CBR-192kbps!Flac";;
     "Mp3-CBR-192kbps") echo "Mp3-CBR-192kbps!Mp3-VBR~245kbps!Mp3-CBR-320kbps!Flac";;
     "Mp3-VBR~245kbps")	echo "Mp3-VBR~245kbps!Mp3-CBR-320kbps!Mp3-CBR-192kbps!Flac";;	
     "") echo "Flac!Mp3-CBR-320kbps!Mp3-VBR~245kbps!Mp3-CBR-192kbps";;
     esac)" --field="Trash input files:CHK" ${trash} --button="Edit Info:4" --button="Edit Tracks:3" --button="Select Tracks:2" --button="gtk-cancel:1" --button="gtk-ok:0"`

ready=$?

oformat=`echo "$settings" | cut -d"|" -f1`
trash=`echo "$settings" | cut -d"|" -f2`


case $ready in
	0)	break;;
	1)	rm -f "$file.tmp";
		exit 0;;
	2)	tracklist_sel_new=`eval "yad --title=\"Track Selection\" --list --center --width=250 --height=300 --text=\"Select Tracks\" --column=\"\" --column=\"Track\" --checklist$(echo "$tracklist" | gawk -vvar=$tracks -vvart=$trck_filter 'BEGIN {i=1;split(vart,trck,",");} NR>=1 && NR<=var {if(trck[i]==NR) {printf(" \"TRUE\" \"%s\"",$0); i++;} else printf(" \"\" \"%s\"",$0);}') --print-all"`;
			if [ $? = 0 ];
			then
				tracklist_sel="$tracklist_sel_new"
				trck_filter=`echo "$tracklist_sel" | gawk -vvar=$tracks -vFS="|" 'NR>=1 && NR<=var {if($1=="TRUE") printf("%d,",NR)}'`;
			fi;;
	3) all_titlesTmp=`eval "yad --title=\"TrackName Editor\" --form --columns=2 --center --width=250 --height=300 "$(echo "$all_titles" | gawk -vvar=$tracks -vvart=$trck_filter -vRS='|' 'BEGIN {i=1;split(vart,trck,",");} NR>=1 && NR<=var {if(trck[i]==NR || vart=="") {printf(" --field=\"%02d\" \"%s\"",NR,$0); i++;} else printf(" --field=\"%02d:RO\" \"%s\"",NR,$0);}')""`;
			if [ $? = 0 ];
			then
				all_titles="$all_titlesTmp"
				tracklist=`echo "$all_titles" | gawk -vvar=$tracks -vRS='|' 'NR>=1 && NR<=var {printf("%02d. %s\n",NR,$0)}'`
				cat "$file.tmp" | gawk -vvart="$all_titles" 'BEGIN {i=0;split(vart,trck,"|");} /TITLE/ {if(i>0) {print("TITLE \"" trck[i] "\"");} else {print} i++;}; !/TITLE/ { print }' > "$file.tmp2"
				mv "$file.tmp2" "$file.tmp"
			fi;;
	4) albinfo=`eval "yad --title=\"Album Editor\" --form --center --width=250 --height=300 --field=\"Artist\" \""${all_artists%%|*}"\" --field=\"Album\" \""$album"\" --field=\"Date\" \""$date"\" --field=\"Genre\" \""$genre"\""`;
			if [ $? = 0 ];
			then
				all_artists=`echo "$albinfo" | cut -d"|" -f1`
				album=`echo "$albinfo" | cut -d"|" -f2`
				date=`echo "$albinfo" | cut -d"|" -f3`
				genre=`echo "$albinfo" | cut -d"|" -f4`
				cat "$file.tmp" | gawk -vvar="$all_artists" '/PERFORMER/ {print("PERFORMER \"" var "\"")} !/PERFORMER/ { print }' > "$file.tmp2"
				mv "$file.tmp2" "$file.tmp"
				cat "$file.tmp" | gawk -vvar="$album" 'BEGIN {i=0;} /TITLE/ {if(i==0) {print("TITLE \"" var "\"");} else {print} i++;}; !/TITLE/ { print }' > "$file.tmp2"
				mv "$file.tmp2" "$file.tmp"
				cat "$file.tmp" | gawk -vvar="$date" '/REM DATE/ {print("REM DATE \"" var "\"")} !/REM DATE/ { print }' > "$file.tmp2"
				mv "$file.tmp2" "$file.tmp"
				cat "$file.tmp" | gawk -vvar="$genre" '/REM GENRE/ {print("REM GENRE \"" var "\"")} !/REM GENRE/ { print }' > "$file.tmp2"
				mv "$file.tmp2" "$file.tmp"
			fi;

esac

done

tracks_t=$tracks

if [ "$trck_filter" != "" ]
then
	tracks=`echo "$trck_filter" | gawk -vFS=',' '{print NF-1}'`
	pregap=`cuebreakpoints --prepend-gaps "$file" | wc -l`

	if [ "$pregap" -ge "$tracks_t" ]
		then
			trck_filter=`echo "$trck_filter" | gawk -vRS=',' -vvar=$tracks 'NR>=1 && NR<=var {printf("%d,",$0+1)}'`
		fi
	trck_filter=" -x ${trck_filter}"
fi

if [ "$oformat" = "Flac" ]
	then
		shnsplit -f "$file.tmp" -o "flac flac -V --best -o %f -" "$1" -t "%n - %t"${trck_filter} 2>&1 | \
		gawk -vvar=$tracks -vi=0 '(NR==1 || $1 != "Skipping") && $0 !~ /pregap/ {i++;if(i<=var){print "#Track ",i," of ", var;print (i-1)*100/var}};{fflush();}' | \
		(if `yad --title="Splitting Tracks..." --center --width=250 --button="gtk-cancel:1" --progress --auto-close --percentage=0`;
		then
    	echo 'done'
    else
      killall shnsplit
      exit 1
    fi)
		
		if [ $? = 1 ]
		then
			exit 0
		fi
		
		rm -f 00*pregap*

		j=1
		while [ $j -le $tracks_t ]
		do
			title=${all_titles%%|*}
			if [ "$nperformer" -ne 1 ]
			then
				artist=${all_artists%%|*}
			else
				artist=$oneartist
			fi
			num=`printf "%02d" $j`
			if [ "$title" != "#####" ]; then metaflac --set-tag=TITLE="$title" "${num} - $title.flac"; fi
			if [ "$artist" != "#####" ]; then metaflac --set-tag=ARTIST="$artist" "${num} - $title.flac"; fi
			if [ "$album" != "#####" ]; then metaflac --set-tag=ALBUM="$album" "${num} - $title.flac"; fi
			metaflac --set-tag=TRACKNUMBER="$j" --set-tag=DATE="$date" --set-tag=GENRE="$genre" "${num} - $title.flac"
			j=$(( $j + 1 ))
			all_titles=${all_titles#*|}
			all_artists=${all_artists#*|}
		done

	else
		if [ "$oformat" = "Mp3-CBR-320kbps" ]
			then
				shnsplit -f "$file.tmp" -o "cust ext=mp3 lame -b 320 - %f -" "$1" -t "%n - %t"${trck_filter} 2>&1 | \
				gawk -vvar=$tracks -vi=0 '(NR==1 || $1 != "Skipping") && $0 !~ /pregap/ {i++;if(i<=var){print "#Track ",i," of ", var;print (i-1)*100/var}};{fflush();}' | \
				(if `yad --title="Splitting Tracks..." --center --width=250 --button="gtk-cancel:1" --progress --auto-close --percentage=0`;
				then
					echo 'done'
				else
				  killall shnsplit
				  exit 1
				fi)
				
				if [ $? = 1 ]
				then
					exit 0
				fi
				
			else
				if [ "$oformat" = "Mp3-CBR-192kbps" ]
				then
					shnsplit -f "$file.tmp" -o "cust ext=mp3 lame -b 192 - %f -" "$1" -t "%n - %t"${trck_filter} 2>&1 | \
					gawk -vvar=$tracks -vi=0 '(NR==1 || $1 != "Skipping") && $0 !~ /pregap/ {i++;if(i<=var){print "#Track ",i," of ", var;print (i-1)*100/var}};{fflush();}' | \
					(if `yad --title="Splitting Tracks..." --center --width=250 --button="gtk-cancel:1" --progress --auto-close --percentage=0`;
					then
						echo 'done'
					else
						killall shnsplit
						exit 1
					fi)
				
					if [ $? = 1 ]
					then
						exit 0
					fi
				else
					shnsplit -f "$file.tmp" -o "cust ext=mp3 lame -V 0 - %f -" "$1" -t "%n - %t"${trck_filter} 2>&1 | \
					gawk -vvar=$tracks -vi=0 '(NR==1 || $1 != "Skipping") && $0 !~ /pregap/ {i++;if(i<=var){print "#Track ",i," of ", var;print (i-1)*100/var}};{fflush();}' | \
					(if `yad --title="Splitting Tracks..." --center --width=250 --button="gtk-cancel:1" --progress --auto-close --percentage=0`;
					then
						echo 'done'
					else
						killall shnsplit
						exit 1
					fi)
				
					if [ $? = 1 ]
					then
						exit 0
					fi
				fi    
		fi
		rm -f 00*pregap*
		
		j=1
		while [ $j -le $tracks_t ]
		do
			title=${all_titles%%|*}
			if [ "$nperformer" -ne 1 ]
			then
				artist=${all_artists%%|*}
			else
				artist=$oneartist
			fi
			num=`printf "%02d" $j`
			if [ "$title" != "#####" ]; then mp3info -t "$title" "${num} - $title.mp3"; fi
			if [ "$artist" != "#####" ]; then mp3info -a "$artist" "${num} - $title.mp3"; fi
			if [ "$album" != "#####" ]; then mp3info -l "$album" "${num} - $title.mp3"; fi
			mp3info -y "$date" -n "$j" -g "$genre" "${num} - $title.mp3"
			j=$(( $j + 1 ))
			all_titles=${all_titles#*|}
			all_artists=${all_artists#*|}
		done
fi

if [ $? = 0 ]
then
	if [ "$trash" = "TRUE" ]
	then
		trash "$1" "$file"
	fi
	notify-send -u normal -t 5000 -i /usr/share/icons/Humanity/devices/32/media-optical.svg "Split Lossless" "$album - Done!"
fi
rm -f "$file.tmp"
rm -f "$file.tmp2"
exit

