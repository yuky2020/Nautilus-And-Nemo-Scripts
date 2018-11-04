#!/bin/bash
#Sivia81 
#GPL

"$scelta" = "Extract cd/dvd iso on /tmp/backup.iso" = "gksudo mount &&
gksudo dd if=/dev/cdrom of=/tmp/backup.iso && gksudo cd; eject"
"$scelta" = "gksudo rm /tmp/backup.iso" = "Clean iso /tmp/backup.iso"
scelta=$(zenity --list --height="250" --width="430" --text="BACKUPS ISO CD/DVD ON HDD" --radiolist --column "Choice" --column "Options" TRUE "Extract cd/dvd iso on /tmp/backup.iso" FALSE "Clean iso /tmp/backup.iso"); echo $scelta

if [ "$scelta" = "Extract cd/dvd iso on /tmp/backup.iso" ]; then
gksudo mount &&
gksudo dd if=/dev/cdrom of=/tmp/backup.iso && gksudo cd; eject
fi

if [ "$scelta" = "Clean iso /tmp/backup.iso" ]; then
gksudo rm /tmp/backup.iso
fi

