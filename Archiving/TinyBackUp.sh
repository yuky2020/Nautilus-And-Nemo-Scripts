#!/bin/bash
##Released under the BSD license
##Author dekster e-mail dekster.linux@gmail.com

clear
echo "TinyBackUp 0.2"


echo "[1] Collapse"
echo "[2] Extract"
echo "Choice: "
read CHOICE
if [ "$CHOICE" == 1 ]
	then echo "Enter the absolute path of the directory to store:"
	read -e BDIR
		if [ -e $BDIR ]; then
        	echo "$BDIR directory exists!"
        	echo "Backup of $BDIR in progress ..."
        	find $BDIR | cpio -o > /home/$USER/Desktop/archive_$(date +%Y%m%d).cpio && echo "Backup was successful =D"
		else echo "The $BDIR Directory does not exist!"
		fi
else [ "$CHOICE" == 2 ]
	echo "Enter the absolute path of the directory to extract:"
	read -e EDIR
		if [ -e $EDIR ]; then
		echo "$EDIR directory exists!"
		echo "Extraction of $EDIR in progress ..."
		cpio -i < $EDIR && echo "Extraction was successful =D"
		else echo "The $EDIR Directory does not exist!"
		fi
fi
