#!/bin/bash
# Transtitulator: Translate the video audio, to a subtitles text file
# Write by Rodrigo Esteves baitsart@gmail.com www.youtube.com/user/baitsart


reco_tanslate()
{
ls $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".audio-multiples-split  |  sort -n > $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".temp_line_of_fles_cont
total=$(cat $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".temp_line_of_fles_cont | tail -n1 |  cut -d '~' -f1 )

cat $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".temp_line_of_fles_cont | while read line; do audio_file=$(echo "$line")

audio_file_start=$(echo "$audio_file" | cut -d '~' -f2 | cut -d ';' -f1 | sed 's/.flac//' )
audio_file_end=$(echo "$audio_file" | cut -d ';' -f2 | sed 's/.flac//' )
time_encoded=$(echo "$audio_file_start,000 --> $audio_file_end,000" )
number_line=$(echo "$audio_file" | cut -d '~' -f1)
curr_perc=$(echo $number_line / $total \* 100 | bc -l | head -c4 )

wget -q -U "Mozilla/5.0" --post-file $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".audio-multiples-split/"$audio_file" --header="Content-Type: audio/x-flac; rate=16000" -O - "http://www.google.com/speech-api/v1/recognize?lang=$FROM&client=chromium"|cut -d\" -f12 > $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".temp_line
sed -i '/^$/d' $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".temp_line
echo -ne "`cat $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".temp_line | while read line; do the_text_encoded=$(echo $line); translate=$(curl -s -A "Mozilla/5.0" "http://translate.google.com/translate_a/t?client=t&text=$(python -c "import urllib; print urllib.quote('''$the_text_encoded''')")&hl=$FROM&sl=ese&tl=$TO&ie=UTF-8&oe=UTF-8&multires=1&prev=btn&ssel=0&tsel=0&sc=1" | sed 's/\[\[\["\([^"]*\).*/\1/'| sed 's/  / /g' | sed 's/'"'"'/ /g'| tail -n 1 ); sed -i $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".temp_line -e s/"$the_text_encoded"/"$translate"/g $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".temp_line 2>/dev/null; done; echo "Progress: 0$curr_perc % Audio translation $number_line /$total"` \\r"

rm $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".audio-multiples-split/"$audio_file"

translation=$(cat $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".temp_line)
echo "
$number_line" >> $HOME/.gnome2/nemo-scripts/.transtitulator/"$name.srt"
echo "$time_encoded
$translation" >> $HOME/.gnome2/nemo-scripts/.transtitulator/"$name.srt"
done
echo "Progress: 0100. % Audio translated $total /$total "

sub=$(echo "$filename" | sed 's/.mp4//g;s/MP4//g;s/mpeg//g;s/MPEG//g;s/mpg//g;s/MPG//g;s/dv//g;s/DV//g;s/flv//g;s/FLV//g;s/avi//g;s/AVI//g;s/mp3//g;s/MP3//g;s/ogg//g;s/OGG//g;s/ogv//g;s/OGV//g;s/mp2//g;s/MP2//g;s/flac//g;s/FLAC//g')

if mplayer -utf8 -fs "$filename" -sub $HOME/.gnome2/nemo-scripts/.transtitulator/"$name.srt"; then
if [ -f  "$sub.srt" ]; then
if zenity --question --text="The file: $sub.srt . Already exist. Do you want overwrite?" --ok-label="yes" --cancel-label="no"; then
cp $HOME/.gnome2/nemo-scripts/.transtitulator/"$name.srt" "$sub.srt"
fi
else
cp $HOME/.gnome2/nemo-scripts/.transtitulator/"$name.srt" "$sub.srt"
fi
rm -rf $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".audio-multiples-split
rm $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".temp_line_of_fles_cont
rm $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".temp_line
rm $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".current_file_convertion
echo "Done!
You have a copy in:
$HOME/.gnome2/nemo-scripts/.transtitulator/`echo "$name_of_file" | sed 's/.mp4//g;s/MP4//g;s/mpeg//g;s/MPEG//g;s/mpg//g;s/MPG//g;s/dv//g;s/DV//g;s/flv//g;s/FLV//g;s/avi//g;s/AVI//g;s/mp3//g;s/MP3//g;s/ogg//g;s/OGG//g;s/ogv//g;s/OGV//g;s/mp2//g;s/MP2//g;s/flac//g;s/FLAC//g'`.srt"
fi
exit 1
}
audio_split()
{
# Written by Alexis Bezverkhyy <alexis@grapsus.net> in 2011
# This is free and unencumbered software released into the public domain.
# For more information, please refer to <http://unlicense.org/>
# Modify to adapted for this function by Rodrigo Esteves baitsart@gmail.com www.youtube.com/user/baitsart
function usage {
        echo "Usage : transtitulator input.file [lang from] [lang to], "
	echo -e "Example: transtitulator '/path/to/video-in' en es"
	echo -e "(Well tranlate from English to Spanish 'en' 'es')"
	echo -e "How ever, if you didn't indicate the lang, well should pick it from the list
		 "
        echo -e ""$filename": No such file or directory"
}

IN_FILE="$filename"
OUT_FILE_FORMAT=""
typeset -i CHUNK_LEN
CHUNK_LEN="8"

DURATION_HMS=$(ffmpeg -i "$IN_FILE" 2>&1 | grep Duration | cut -f 4 -d ' ')
DURATION_H=$(echo "$DURATION_HMS" | cut -d ':' -f 1)
    DURATION_M=$(echo "$DURATION_HMS" | cut -d ':' -f 2 | sed 's/^0\+\([0-9]\)/\1/')
    DURATION_S=$(echo "$DURATION_HMS" | cut -d ':' -f 3 | cut -d '.' -f 1 | sed 's/^0\+\([0-9]\)/\1/')
let "DURATION = ( DURATION_H * 60 + DURATION_M ) * 60 + DURATION_S"

if [ "$DURATION" = '0' ] ; then
        echo "Invalid input video"
        usage
        exit 1
fi

if [ "$CHUNK_LEN" = "0" ] ; then
        echo "Invalid chunk size"
        usage
        exit 2
fi

if [ -z "$OUT_FILE_FORMAT" ] ; then
        FILE_EXT=$(echo "$IN_FILE" | sed 's/^.*\.\([a-zA-Z0-9]\+\)$/\1/')
        FILE_NAME=$(echo "$IN_FILE" | sed 's/^\(.*\)\.[a-zA-Z0-9]\+$/\1/')
        OUT_FILE_FORMAT="${FILE_NAME}-%03d.${FILE_EXT}"
#        echo "Using default output file format : $OUT_FILE_FORMAT"
fi

N='1'
OFFSET='0'
let 'N_FILES = DURATION / CHUNK_LEN + 1'
while [ "$OFFSET" -lt "$DURATION" ] ; do
TIME_START=$(echo - | awk -v "S="$OFFSET"" '{printf "%02d:%02d:%02d",S/(60*60),S%(60*60)/60,S%60}')
TOSET=$(expr "$OFFSET" + "$CHUNK_LEN" )
TIME_END=$(echo - | awk -v "S="$TOSET"" '{printf "%02d:%02d:%02d",S/(60*60),S%(60*60)/60,S%60}')
PERCENT=$(echo $N / $N_FILES \* 100 | bc -l | head -c4)
        OUT_FILE=$(printf "$OUT_FILE_FORMAT" "$N")
        echo -ne "Progress: 0$PERCENT % Extracting audio $N /$N_FILES \\r"
        ffmpeg -i "$IN_FILE" -ss "$OFFSET" -t "$CHUNK_LEN" -ar 16000 "$HOME/.gnome2/nemo-scripts/.transtitulator/.$name_of_file.audio-multiples-split/$N~$TIME_START;$TIME_END.flac"  2>/dev/null
        let "N = N + 1"
        let "OFFSET = OFFSET + CHUNK_LEN"
done
echo "Progress: 0$PERCENT % Extracted audio $N_FILES /$N_FILES "
echo "$filename" > $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".current_file_convertion
reco_tanslate
}

ping -c 4 www.google.com > /dev/null
if [ "$?" -eq 0 ]
then
filename="$1"
FROM="$2"
TO="$3"
[[ -d $HOME/.gnome2/nemo-scripts/.transtitulator ]] || mkdir $HOME/.gnome2/nemo-scripts/.transtitulator
echo "auto Auto-detect
af Afrikaans
ar Arabic
az Azerbaijani
be Belarusian
bg Bulgarian
bn Bengali
ca Catalan
cs Czech
cy Welsh
da Danish
de German
el Greek
en English
eo Esperanto
es Spanish
et Estonian
eu Basque
fa Persian
fi Finnish
fr French
ga Irish
gl Galician
gu Gujarati
hi Hindi
hr Croatian
ht Haitian
hu Hungarian
hy Armenian
id Indonesian
is Icelandic
it Italian
iw Hebrew
ja Japanese
ka Georgian
km Khmer
kn Kannada
ko Korean
la Latin
lo Lao
lt Lithuanian
lv Latvian
mk Macedonian
ms Malay
mt Maltese
nl Dutch
no Norwegian
pl Polish
pt Portuguese
ro Romanian
ru Russian
sk Slovak
sl Slovenian
sq Albanian
sr Serbian
sv Swedish
sw Swahili
ta Tamil
te Telugu
th Thai
tl Filipino
tr Turkish
uk Ukrainian
ur Urdu
vi Vietnamese
yi Yiddish
zh-cn Chinese-Simplified
zh-tw Chinese-Traditional" > $HOME/.gnome2/nemo-scripts/.transtitulator/.lang

function usage {
        echo "Usage : transtitulator input.file [lang from] [lang to], "
	echo -e "Example: transtitulator '/path/to/video-in' en es"
	echo -e "(Well tranlate from English to Spanish 'en' 'es')"
	echo -e "How ever, if you didn't indicate the lang, well should pick it from the list
		 "
}
if
ffmpeg -i "$1" 2>&1 | grep -q Duration; then
filename="$1"
else
if filename=`zenity --file-selection --file-filter="Video, audio |*.mp4 *.MP4 *.mpeg *.MPEG *.mpg *.MPG *.dv *.DV *.flv *.FLV *.avi *.AVI *.mp3 *.MP3 *.ogg *.OGG *.ogv *.OGV *.mp2 *.MP2 *.flac *.FLAC" --title="Select an video, audio file"`; then
echo "The file: $filename"
else
exit 1
fi
fi
if cat $HOME/.gnome2/nemo-scripts/.transtitulator/.lang | awk '{print $1}' | grep -x -q "$2"; then
FROM="$2"
else
FROM=$( cat $HOME/.gnome2/nemo-scripts/.transtitulator/.lang | zenity --list --width="250" --height="670" --text "Select the language from the list" --title "Transtitulator" --column "Actual language of movie"| awk '{print $1}')
fi
if cat $HOME/.gnome2/nemo-scripts/.transtitulator/.lang | sed '1d' | awk '{print $1}' | grep -x -q "$3"; then
TO="$3"
else
TO=$( cat $HOME/.gnome2/nemo-scripts/.transtitulator/.lang | sed '1d' | zenity --list --width="250" --height="670" --text "Select the language from the list" --title "Transtitulator" --column "Your language for subtitles"| awk '{print $1}')
fi
if cat $HOME/.gnome2/nemo-scripts/.transtitulator/.lang | awk '{print $1}' | grep -x -q "$FROM"; then
echo "Translate from:
`cat $HOME/.gnome2/nemo-scripts/.transtitulator/.lang | grep  "$FROM " | cut -d' ' -f2`"

else
        echo "Invalid input lang from"
        usage
        exit 1
fi
fi
if cat $HOME/.gnome2/nemo-scripts/.transtitulator/.lang | sed '1d' | awk '{print $1}' | grep -x -q "$TO"; then
echo "to:
`cat $HOME/.gnome2/nemo-scripts/.transtitulator/.lang | sed '1d' | grep "$TO " | cut -d' ' -f2`"
else
        echo "Invalid input lang to"
        usage
        exit 2
fi

echo "

Press (Ctrl+Z), to pause the process, or press (Ctrl+C) to cancel.
"
name_of_file=$(echo "$filename" | tr '/' '\n' | tail -n1 )
name=$(echo "$name_of_file" | sed 's/.mp4//g;s/MP4//g;s/mpeg//g;s/MPEG//g;s/mpg//g;s/MPG//g;s/dv//g;s/DV//g;s/flv//g;s/FLV//g;s/avi//g;s/AVI//g;s/mp3//g;s/MP3//g;s/ogg//g;s/OGG//g;s/ogv//g;s/OGV//g;s/mp2//g;s/MP2//g;s/flac//g;s/FLAC//g')

if [ -f $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".current_file_convertion ]; then

curren_file_process=$(cat $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".current_file_convertion)
if diff "$filename" "$curren_file_process"; then
	if [ $? -eq 0 ]; then
zenity --question --text="Do you want continue the translation?, press: yes,\nor restart the process, press: no" --ok-label="yes" --cancel-label="no"
	if [ $? -eq 0 ]; then
reco_tanslate
fi
	if [ "$?" -eq 0 ]; then
if [ -d $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".audio-multiples-split ]; then
rm -rf $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".audio-multiples-split
fi
rm $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file"*
mkdir $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".audio-multiples-split
echo "" > $HOME/.gnome2/nemo-scripts/.transtitulator/"$name.srt"
audio_split

fi
fi
fi
else
[[ -d $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".audio-multiples-split ]] || mkdir $HOME/.gnome2/nemo-scripts/.transtitulator/."$name_of_file".audio-multiples-split
echo "" > $HOME/.gnome2/nemo-scripts/.transtitulator/"$name.srt"
audio_split
exit 0
fi
fi


exit 0
fi
	if [ $? -eq 0 ]; then
notify-send "Internet connection required"
exit 0
fi
