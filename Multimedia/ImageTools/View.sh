#!/bin/bash

WINDOWWIDTH=800
WINDOWHEIGHT=600

viewit ()
{

	local FILENAME=$(basename "$1")
	local width height

	if  identify -format "%m" "$1"  &>/dev/null ;then

		width=$(identify -format "%W" "$1")
		height=$(identify -format "%H" "$1")

		if [ $width -lt $WINDOWWIDTH ];then
			WINDOWWIDTH=$width
		fi
		
		if [ $width -lt $WINDOWHEIGHT ];then
			WINDOWHEIGHT=$height
		fi
		
		export MAIN_DIALOG="
			<window title=\"$FILENAME\" default_width=\"$WINDOWWIDTH\" default_height=\"$WINDOWHEIGHT\" window_position=\"1\" >
				<hbox scrollable=\"true\">
					<pixmap>
						<input file>$1</input>
					</pixmap>
				</hbox>
			</window>"

		gtkdialog --program=MAIN_DIALOG
		return
	fi

	if file --dereference --mime "$1"|grep -i text;then
		zenity --width=600 --height=400 --text-info --title="File name:$FILENAME" --filename="$1"
		return
	fi
	
	if xdg-mime query filetype "$1"|grep -i text;then
		zenity --width=600 --height=400 --text-info --title="File name:$FILENAME" --filename="$1"
		return
	fi
	
	gnome-open "$1"
}

echo -e "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | while read
	do
		if [ -f "$REPLY" ];then
			viewit "$REPLY" &
		fi
	done

