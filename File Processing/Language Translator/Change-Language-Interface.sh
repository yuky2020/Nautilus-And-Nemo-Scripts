#!/bin/bash

# Script to change the language of recognize-and-translation.sh #
# Script para cambiar el lenguaje a reconocimiento-y-traducción.sh #
# por  Rodrigo Esteves baitsart@gmail.com www.youtube.com/user/baitsart
PKG_PATH=$(dirname "$(readlink -f "$0")")
cd "$PKG_PATH"
echo "af Afrikaans
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
zh-tw Chinese-Traditional" > /tmp/lang
if to_lang=$( cat /tmp/lang | zenity --list --width="250" --height="670" --text "Select the language from the list" --title "Translator" --column "Language you want translate")
then
(
echo "10" ; sleep 0
echo "# Translating the interface" ; sleep 0

echo "$to_lang" >  /tmp/temp_line3
TO=$(cat /tmp/temp_line3 | cut -d' ' -f1)
cp ./recognize-and-translation.sh ./.recognize-and-translation.sh1
echo "Speech recognition.
Close this window
to end the recording
Recording
Size
Time
Translate spoken text
Translated text
Check the box to save the translated text
Select the language from the list
Translator
Language you want translate" > /tmp/temp_line
cat -s < /tmp/temp_line > /tmp/temp_line1
cat /tmp/temp_line1 | while read line; do the_text_encoded=$(echo $line); translate=$(curl -A "Mozilla/5.0" "http://translate.google.com/translate_a/t?client=t&text=$(python -c "import urllib; print urllib.quote('''$the_text_encoded''')")&hl=en&sl=ese&tl=$TO&ie=UTF-8&oe=UTF-8&multires=1&prev=btn&ssel=0&tsel=0&sc=1" | sed 's/\[\[\["\([^"]*\).*/\1/'| sed 's/  / /g'| tail -n 1 ); sed -i ./.recognize-and-translation.sh1 -e s/"$the_text_encoded"/"$translate"/g ./.recognize-and-translation.sh1; done

echo "20" ; sleep 0
echo "# Changing the language of the script" ; sleep 0

lengua=$(curl -A "Mozilla/5.0" "http://translate.google.com/translate_a/t?client=t&text=recognize-and-translation&hl=en&sl=ese&tl=$TO&ie=UTF-8&oe=UTF-8&multires=1&prev=btn&ssel=0&tsel=0&sc=1" | sed 's/\[\[\["\([^"]*\).*/\1/'| sed 's/   /-/g'| sed 's/  /-/g'| sed 's/ /-/g'| sed 's/--/-/g'| sed 's/--/-/g'| tail -n 1 )
python -c 'import sys; print sys.stdin.read().replace("echo "'"'"'"'"'"'"en"'"'"'"'"'"'" > /tmp/temp_line2","echo "'"'"'"'"'"'"'$TO'"'"'"'"'"'"'" >  /tmp/temp_line2")' < ./.recognize-and-translation.sh1 > /tmp/temp_line1
echo "50" ; sleep 0
echo "Changing the language of the script" ; sleep 0
cat -s /tmp/lang | head -n 65 | cut -d' ' -f2 >  /tmp/lang3
xargs -n7 < /tmp/lang3 > /tmp/lang2
awk '{ print "- "$0" -" }'  /tmp/lang2 > /tmp/lang1
python -c 'import sys; print sys.stdin.read().replace(" "," - ")' < /tmp/lang1 > /tmp/lang2
cat /tmp/lang2 | while read line; do the_text=$(echo $line); the_text_encoded=$(echo $line) curl -A "Mozilla/5.0" "http://translate.google.com/translate_a/t?client=t&text=$(python -c "import urllib; print urllib.quote('''$the_text''')")&hl=en&sl=ese&tl=$TO&ie=UTF-8&oe=UTF-8&multires=1&prev=btn&ssel=0&tsel=0&sc=1" | sed 's/\[\[\["\([^"]*\).*/\1/'| tail -n 1 | sed 's/-/ /g'| sed 's/,/ /g'| sed 's/，/\n/g' | sed 's/  / /g'| sed 's/ /\n/g' | cat >> /tmp/traduction-temp1; done
sed -i '/^$/d' /tmp/traduction-temp1
cat /tmp/lang | head -n 65 | cut -d' ' -f1 >  /tmp/lang3
paste /tmp/lang3 /tmp/traduction-temp1 > /tmp/traduction-temp
sed -i 's/\t/ /g' /tmp/traduction-temp
python -c 'import sys; print sys.stdin.read().replace("\n","\\n")' < /tmp/traduction-temp > /tmp/traduction-temp1

echo "75" ; sleep 0
echo "# Finalising" ; sleep 0
file1=$(cat /tmp/traduction-temp1)
echo "#!/bin/bash" > /tmp/script
echo "python -c 'import sys; print sys.stdin.read().replace("'"'"af Afrikaans\nar Arabic\naz Azerbaijani\nbe Belarusian\nbg Bulgarian\nbn Bengali\nca Catalan\ncs Czech\ncy Welsh\nda Danish\nde German\nel Greek\nen English\neo Esperanto\nes Spanish\net Estonian\neu Basque\nfa Persian\nfi Finnish\nfr French\nga Irish\ngl Galician\ngu Gujarati\nhi Hindi\nhr Croatian\nht Haitian\nhu Hungarian\nhy Armenian\nid Indonesian\nis Icelandic\nit Italian\niw Hebrew\nja Japanese\nka Georgian\nkm Khmer\nkn Kannada\nko Korean\nla Latin\nlo Lao\nlt Lithuanian\nlv Latvian\nmk Macedonian\nms Malay\nmt Maltese\nnl Dutch\nno Norwegian\npl Polish\npt Portuguese\nro Romanian\nru Russian\nsk Slovak\nsl Slovenian\nsq Albanian\nsr Serbian\nsv Swedish\nsw Swahili\nta Tamil\nte Telugu\nth Thai\ntl Filipino\ntr Turkish\nuk Ukrainian\nur Urdu\nvi Vietnamese\nyi Yiddish\n"'"'", "'"'"$file1"'"'")' < /tmp/temp_line1 > /tmp/temp_line " >> /tmp/script
chmod +x /tmp/script
sh /tmp/script
mv /tmp/temp_line "$PKG_PATH"/"$lengua"
chmod +x "$PKG_PATH"/"$lengua"


rm ./.recognize-and-translation.sh1
rm /tmp/lang
rm /tmp/lang1
rm /tmp/lang2
rm /tmp/lang3
rm /tmp/traduction-temp
rm /tmp/traduction-temp1
rm /tmp/script

echo "Do you want to execute it in your" > /tmp/temp_line2
cat /tmp/temp_line2 | while read line; do the_text=$(echo $line | sed 's/-/ /g'); the_text_encoded=$(echo $line) curl -A "Mozilla/5.0" "http://translate.google.com/translate_a/t?client=t&text=$(python -c "import urllib; print urllib.quote('''$the_text''')")&hl=en&sl=ese&tl=$TO&ie=UTF-8&oe=UTF-8&multires=1&prev=btn&ssel=0&tsel=0&sc=1" | sed 's/\[\[\["\([^"]*\).*/\1/'| tail -n 1 | cat > /tmp/temp_line; done
lengua_transaltor=$(cat /tmp/temp_line)
zenity --question --text="'$lengua_transaltor' "$PKG_PATH"/"$lengua""
case $? in
         0)
		sh "$PKG_PATH"/"$lengua"
rm /tmp/temp_line
rm /tmp/temp_line1
rm /tmp/temp_line2
rm /tmp/temp_line3
exit;;
         1)
                rm /tmp/temp_line
rm /tmp/temp_line1
rm /tmp/temp_line2
rm /tmp/temp_line3
exit 1;;
        -1)
                echo "Ha ocurrido un error inesperado.";;
esac
echo "100" ; sleep 0
) |
zenity --progress \
  --auto-close \
  --no-cancel \
  --title="Converting" \
  --text="Changing the language of the script" \
  --percentage=0

fi

	if [ $? -eq 0 ]; then
rm /tmp/lang
	exit 0
fi
fi
