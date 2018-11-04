#!/bin/bash
#########################################################
#							#
# This are NScripts v3.6				#
#							#
# Licensed under the GNU GENERAL PUBLIC LICENSE 3	#
#							#
# Copyright 2007 - 2009 Christopher Bratusek		#
#							#
#########################################################

echo $NAUTILUS_SCRIPT_SELECTED_URIS > ~/.gnome2/temp_chkmd5_list

failed () {

	cat /tmp/checkfile.txt | fgrep -o -e "FAILED" | wc -l
	if (( $? == 0 )); then
		StatusMessage="$2 >> is OK!"
	else	StatusMessage="$2 >> is corrupt!"
	fi

	echo -en "\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n" >> /tmp/checkmd5.txt
	echo "$StatusMessage" >> /tmp/checkmd5.txt

}

check () {

	LANG=C md5sum -c "$1" > /tmp/checkfile.txt 2>&1 | \
	zenity --progress --title "Check md5" --text "Checking: $2" --pulsate --auto-close

}

for file in $(cat ~/.gnome2/temp_chkmd5_list); do

	origfile=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g' -e 's/\.md5//g')

	if [[ -a "$origfile".md5 ]]; then

		shortfile=$(echo $origfile | sed -e 's#.*/##g')
		check "$origfile" "$shortfile"
		failed "$origfile" "$shortfile"

	else	echo -en "\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n" >> /tmp/checkmd5.txt
		echo "No MD5-Sum for $origfile" >> /tmp/checkmd5.txt
	fi

	rm -f /tmp/checkfile.txt

done

zenity --text-info --title "Result" --width=640 --height=480 --filename=/tmp/checkmd5.txt

rm -f ~/.gnome2/temp_chkmd5_list
rm -f /tmp/checkmd5.txt
