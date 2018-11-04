#!/bin/bash

hkey=$(zenity --entry --text "Enter string for encoding/decoding" --width 850 --entry-text "" --title "ASCII to HEX/DECIMAL/BIN/BASE 16 32 64 Encoder")
case $? in
0)
dataencode=$(
printf "%-20s\t" 'ASCII:';
printf "\r"
echo "$hkey"; echo
printf "\r"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"; echo
printf "\r"

printf "%-20s\t" 'DECIMAL:';
printf "\r"
echo -n "$hkey" | hexdump -ve '/1 "%03i "'; echo
printf "\r"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"; echo
printf "\r"
printf "%-20s\t" 'HEX:';
printf "\r"
echo -n "$hkey" | hexdump -ve '/1 "%02x "'; echo
printf "\r"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"; echo
printf "\r"
printf "%-20s\t" 'BIN:';
printf "\r"
echo -n "$hkey" | xxd -b -g0 -c0 | cut -b10-57 | tr -d '\n '| sed 's/......../& /g'; echo
printf "\r"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"; echo
printf "\r"

printf "%-20s\t" 'BASE64:';
printf "\r"
python -c "import base64; print base64.b64encode('''$hkey''')"
printf "\r"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"; echo
printf "\r"
printf "%-20s\t" 'BASE32:';
printf "\r"
python -c "import base64; print base64.b32encode('''$hkey''')"
printf "\r"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"; echo
printf "\r"
printf "%-20s\t" 'BASE16:';
printf "\r"
python -c "import base64; print base64.b16encode('''$hkey''')"
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
