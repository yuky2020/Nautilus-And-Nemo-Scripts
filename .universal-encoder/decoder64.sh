#!/bin/bash

hkey=$(zenity --entry --text "Enter string for encoding/decoding" --width 850 --entry-text "" --title "Base 64 to Ascii/HEX/DECIMAL/BIN/BASE 16 32 Encoder")
case $? in
0)
dataencode=$(
xkey=$(python -c "import base64; print base64.b64decode('''$hkey''')")

printf "%-20s\t" 'Normal:';
printf "\r"
echo "$xkey"; echo
printf "\r"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"; echo
printf "\r"

printf "%-20s\t" 'DECIMAL:';
printf "\r"
echo -n "$xkey" | hexdump -ve '/1 "%03i "'; echo
printf "\r"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"; echo
printf "\r"
printf "%-20s\t" 'HEX:';
printf "\r"
echo -n "$xkey" | hexdump -ve '/1 "%02x "'; echo
printf "\r"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"; echo
printf "\r"
printf "%-20s\t" 'BIN:';
printf "\r"
echo -n "$xkey" | xxd -b -g0 -c0 | cut -b10-57 | tr -d '\n '| sed 's/......../& /g'; echo
printf "\r"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"; echo
printf "\r"

printf "%-20s\t" 'Base64:';
printf "\r"
echo "$hkey"; echo
printf "\r"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"; echo
printf "\r"
printf "%-20s\t" 'Base32:';
printf "\r"
python -c "import base64; print base64.b32encode('''$xkey''')"
printf "\r"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"; echo
printf "\r"
printf "%-20s\t" 'Base16:';
printf "\r"
python -c "import base64; print base64.b16encode('''$xkey''')"
printf "\r"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"; echo
printf "\r"
)
echo $dataencode | zenity --text-info --title "Encoded String" --width 750 --height 600
;;
1)
exit 1;;
-1)
exit 1;;
esac
