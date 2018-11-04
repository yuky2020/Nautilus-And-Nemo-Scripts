#!/bin/bash

function joinFiles() {
	zenity --question --title="Join files" --text="Move original files into trash after joining?"
	d=$?
	if [ $d -eq 1 ]; then
		exit
	fi
	tmp=$IFS
	IFS=$'\n'
	cnt=0
	for s in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
		if [ "${s: -4}" == ".001" ]; then
			f=${s%.*}
			f=${f##*/}
			i=1
			t=
			while [ -e "$s" ]; do
				t=$( echo "$t \"$s\"" )
				let i++
				s=$( echo $f.$( printf "%03i" $i ) )
			done
			echo "#Joining \"$f\"..."
			echo $t | xargs cat > "$f"
			let cnt++
			if [ $d -eq 0 ]; then
				echo $t | xargs gvfs-trash
			fi
		fi
	done
	IFS=$tmp
	if [ $cnt -eq 0 ]; then
		zenity --error --title="Join files" --text="Please select .001 file(s)"
	fi
}

if [ "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" == "" ]; then
	zenity --error --title="Join files" --text="Please select .001 file(s)"
	exit 1
fi
joinFiles | zenity --progress --title="Join files" --auto-close --no-cancel --pulsate
#zenity --info --title="Join files" --text="All done!"
