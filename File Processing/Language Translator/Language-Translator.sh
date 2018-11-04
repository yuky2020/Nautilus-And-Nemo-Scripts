#!/bin/bash

#### Script to recognize your speech and translate to any language ####
# by Rodrigo Esteves baitsart@gmail.com www.youtube.com/user/baitsart #
hora=$(date | cut -c 12-20)
fecha=$(echo "`date +%d`_`date +%B`_`date +%Y`-"$hora"")
echo "en" > /tmp/temp_line2
FROM=$(cat /tmp/temp_line2)
rec -r 16000 -c 1 -t flac  /tmp/grabacion.flac 2>&1 | awk -vRS="\r" '$1 ~ /In/ {gsub(/In:/," ");gsub(/%\)/," ");gsub(/ \(/," ");print $3"\n# Speech recognition.\\n\\nClose this window\\nto end the recording.\\n\\nTime:\\t"$2"\\nSize :\\t"$4; fflush();}' | zenity --window-icon="/usr/share/icons/hicolor/48x48/apps/audio-recorder-on.png" --progress --pulsate --no-cancel --auto-kill --auto-close --width="255" --height="190" --title=" Recording..."| notify-send -i "/usr/share/icons/hicolor/48x48/apps/audio-recorder-on.png" " Recording..." 

wget -q -U "Mozilla/5.0" --post-file /tmp/grabacion.flac --header="Content-Type: audio/x-flac; rate=16000" -O - "http://www.google.com/speech-api/v1/recognize?lang=$FROM&client=chromium"|cut -d\" -f12 > /tmp/temp_line_line

text_in=$(zenity --title "Translate spoken text" --width="335" --height="310" --text-info --editable --filename=/tmp/temp_line | awk '{ printf "%s ", $0 }')
	if [ "$text_in" != "" ]; then
echo "$text_in" >  /tmp/temp_line

if to_lang=$( echo "af Afrikaans
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
zh-tw Chinese-Traditional" | zenity --list --width="250" --height="670" --text "Select the language from the list" --title "Translator" --column "Language you want translate")
then
echo "$to_lang" >  /tmp/temp_line3
TO=$(cat /tmp/temp_line3 | awk '{print $1}')
xargs -n7 < /tmp/temp_line > /tmp/temp_line1
cat -s < /tmp/temp_line1 > /tmp/temp_line
awk '{ print "-"$0"-" }' /tmp/temp_line > /tmp/temp_line1

cat /tmp/temp_line1 | while read line; do the_text_encoded=$(echo $line);  curl -A "Mozilla/5.0" "http://translate.google.com/translate_a/t?client=t&text=$(python -c "import urllib; print urllib.quote('''$the_text_encoded''')")&hl=$FROM&sl=ese&tl=$TO&ie=UTF-8&oe=UTF-8&multires=1&prev=btn&ssel=0&tsel=0&sc=1" | sed 's/\[\[\["\([^"]*\).*/\1/'| tail -n 1 | cat >> /tmp/traduction-temp1; done
cat /tmp/traduction-temp1 | sed 's|-| |g;s|  | |g;s|'"'"'||g' > /tmp/traduction-temp
xargs -n7 < /tmp/traduction-temp > /tmp/traduction-temp1
cp /tmp/traduction-temp1  /tmp/traduction-temp3 
cat -s < /tmp/traduction-temp1 > /tmp/traduction-temp
awk '{printf("%03d;" ,(NR)); print $0 }' < /tmp/traduction-temp > /tmp/traduction-temp1
mkdir /tmp/google-tts-traduction-temp
cd /tmp/google-tts-traduction-temp

while read line; do audio=$(echo $line | cut -d';' -f1);texto=$(echo $line | cut -d';' -f2); wget -A.mp3 -U "\"Mozillla\"" -O "$audio.mp3" "http://translate.google.com/translate_tts?tl=$TO&q=$(python -c "import urllib; print urllib.quote('''$texto''')")&ie=UTF-8"; done < /tmp/traduction-temp1
cat *.mp3 > ~/tts-"$fecha"_"$TO".mp3
cd
audacious ~/tts-"$fecha"_"$TO".mp3 & 
rm /tmp/temp_line
rm /tmp/temp_line1
rm /tmp/temp_line2
rm /tmp/temp_line3
rm /tmp/traduction-temp
rm /tmp/traduction-temp1
rm -rf /tmp/google-tts-traduction-temp
else
rm /tmp/temp_line
rm /tmp/temp_line2
     exit
     fi
if (zenity --title "Translated text" --width="335" --height="310" --text-info --checkbox "Check the box to save the translated text." --filename=/tmp/traduction-temp3)
then
DESTINO=$(zenity --file-selection --filename="$fecha"_Texto.traducido.txt --save --confirm-overwrite)
mv -i /tmp/traduction-temp3 "$DESTINO"
else
rm /tmp/traduction-temp3
     exit
     fi

exit 0
	if [ $? -eq 0 ]; then
rm /tmp/temp_line
exit
fi
fi
