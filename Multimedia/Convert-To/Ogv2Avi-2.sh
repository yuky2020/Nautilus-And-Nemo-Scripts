#!/bin/bash

convers=$(zenity --entry --text="Type the name of the converted film with appropriate extension (eg. film.avi)")

kod=`mencoder $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS.ogv -ovc lavc -oac mp3lame -o $convers` | zenity --progress --text="Progress..." --percentage=0 --pulsate



