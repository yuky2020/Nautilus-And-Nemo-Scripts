#!/bin/bash

# GNU License. You are free to modify and redistribute   #
# http://gnome-look.org/content/show.php?content=163878  #

# Transtitulator, translate audio, videos, and automatically write an susbtitles file, .srt, do this with google speech recognition, and google-translate

# Install dependencies:
# sudo apt-get install ffmpeg curl wget mplayer gawk zenity

# Usage: Transtitulator , </path-to-video/> <language-from> <language-to>
# Or browse to your video, and select the lenguages

# Write by Rodrigo Esteves baitsart@gmail.com www.youtube.com/user/baitsart #

VIDEO="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
LANG_FROM="$2"
LANG_TO="$3"
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
zh-tw Chinese-Traditional" > /tmp/.lang
if
ffmpeg -i "$@" 2>&1 | grep Duration; then
VIDEO="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
else
if VIDEO=`zenity --file-selection --file-filter="Video, audio |*.mp4 *.MP4 *.mpeg *.MPEG *.mpg *.MPG *.dv *.DV .flv *.FLV *.avi *.AVI *.mp3 *.MP3 *.ogg *.OGG *.ogv *.OGV *.mp2 *.MP2 *.flac *.FLAC" --title="Select an video, audio file"`; then
echo "The file: $@"
else
exit 1
fi
fi
if cat /tmp/.lang | awk '{print $1}' | grep -x -q "$2"; then
FROM="$2"
else
FROM=$( cat /tmp/.lang | zenity --list --width="250" --height="670" --text "Select the language from the list" --title "Transtitulator" --column "Actual language of movie"| awk '{print $1}')
fi
LANG_FROM=$(cat /tmp/.lang | grep  "$FROM " | cut -d' ' -f2 )
echo "Translate from:
"$LANG_FROM""
if cat /tmp/.lang | sed '1d' | awk '{print $1}' | grep -x -q "$3"; then
TO="$3"
else
TO=$( cat /tmp/.lang | sed '1d' | zenity --list --width="250" --height="670" --text "Select the language from the list" --title "Transtitulator" --column "Your language for subtitles"| awk '{print $1}')
fi
LANG_TO=$(cat /tmp/.lang | sed '1d' | grep "$TO " | cut -d' ' -f2)
echo "to:
"$LANG_TO""

PKG_PATH=$(dirname "$(readlink -f "$0")")
exec "${PKG_PATH}"/Transtitulator.sh "$@" "$FROM" "$TO" 2>&1  | awk -vRS="\r" '$1 ~ /Progress:/ {gsub(/Progress:/," ");gsub(/%\)/," ");gsub(/ \(/," ");print $1"\n# Process to write the audio, video subtitles.\\n\\nFrom: '$LANG_FROM'\\nto: '$LANG_TO'\\n\\nAction:\\t\\t"$3" "$4"\\n\\nPercentage:\\t"$1"%\\nProcessing: \\t"$5" "$6; fflush();}' | zenity --progress --auto-kill --no-cancel --ok-label="Quit" --width="270" --height="130" --title=" Progress..."
echo "

DDDDDDD            OOOOO       NNNN      NNNN   EEEEEEEEEEE     !!!!
DDDDDDDDD        OOOOOOOOO     NNNNN     NNNN   EEEEEEEEEEE     !!!!
DDD   DDDDD     OOOO   OOOO    NNNNNN    NNNN   EEE             !!!!
DDD     DDDD   OOOO     OOOO   NNNNNNN   NNNN   EEE             !!!!
DDD     DDDD   OOOO     OOOO   NNNN NNN  NNNN   EEEEEEE         !!!!
DDD     DDDD   OOOO     OOOO   NNNN  NNN NNNN   EEEEEEE
DDD    DDDD     OOOO   OOOO    NNNN   NNNNNNN   EEE              !!
DDDDDDDDDD       OOOOOOOOO     NNNN    NNNNNN   EEEEEEEEEEE     !!!!
DDDDDDDD           OOOOO       NNNN     NNNNN   EEEEEEEEEEE      !!


"
rm /tmp/.lang
rm -vfr $HOME/.gnome2/nemo-scripts/.transtitulator
