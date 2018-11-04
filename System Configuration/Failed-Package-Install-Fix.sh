#!/bin/sh

TITLE=$(zenity --entry --title "Failed Installation Repair" --text "What package went wrong?")

sudo rm /var/lib/dpkg/lock | zenity --info --text "Removed DPKG Lock" 

sudo dpkg --configure -a | zenity --progress --text="DPKG Configured" --pulsate --auto-close

sudo dpkg --remove --force-remove-reinstreq $TITLE | zenity --progress --text="Removing $TITLE" --pulsate --auto-close

sudo pkill apt | zenity --info --text "DPKG Processes ended"

zenity --info --title "Fixed" --text "$TITLE is a cad! Hope it works next time."
