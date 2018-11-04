#!/bin/bash

viewit ()
{

	local FILENAME=$(basename "$1")

	if file "$1"|grep -i image || [ ${FILENAME##?*.} = "svg" ] ;then

		export MAIN_DIALOG="
			<window title=\"$FILENAME\">
				<frame $1>
					<pixmap>
						<input file>$1</input>
					</pixmap>
				</frame>
			</window>"

		gtkdialog --program=MAIN_DIALOG
		return
	fi

	if file "$1"|grep -i text;then
		zenity --width=600 --height=400 --text-info --title="File name:$FILENAME" --filename="$1"
		return
	fi
	
	if xdg-mime query filetype "$1"|grep -i text;then
		zenity --width=600 --height=400 --text-info --title="File name:$FILENAME" --filename="$1"
		return
	fi
	
	gnome-terminal -x mplayer "$1"
}

echo -e "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | while read
	do
		if [ -f "$REPLY" ];then
			viewit "$REPLY" &
		fi
	done

