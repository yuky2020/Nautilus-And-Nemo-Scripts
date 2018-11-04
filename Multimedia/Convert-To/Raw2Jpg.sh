#!/bin/bash
#########################################################################
#                     	Nautilus "RAW Convert" Script v 0.1  		#
#########################################################################
# Originally created by Groobox 		                        #
# Email: groobox @ gmail.com						#
# ----------------------------------------------------------------------#
# Actual Version is Created by Andrea9					#
# 									#
# new feature:								#
#									#
#	- specify jpeg quality;						#
#	- specify jpeg size;						#
#	- fixed bug in move RAW files;                       		#
#				                          		#
# Email: informatico99 @ tiscali.it                                     #
#########################################################################



title="Compress Image"
title1="Size in px of the long side"
title2="Move the file RAW/NEF?"
quality="Image quality [0-100]"
resize="'0' for not modify"
movetoRAWfolder="Move files in folder ./RAW"
nomovetoRAWfolder="Do not move"
error="Error"
sizeNOTchoosed="It should indicate size in px!"
qualityNOTchoosed="It's necessary to indicate quality of compression!"
nofilesselected="No file selected!"

if [  "$1"  !=  ""  ]
then

		quality=`zenity --entry --title="$title" --text="$quality" --entry-text "90" `
		size=`zenity --entry --title="$title1" --text="$resize" --entry-text "0" --width=350`

		move=`zenity --list --title="$title2" --radiolist --width=500 --height=200 \
			--column=""	--column="Action"	--column="Description" \
			'TRUE'		move			"$movetoRAWfolder" \
			'FALSE'		no_move			"$nomovetoRAWfolder" `
		echo  $move


		if [ "$move" = "move" ]
		then 
			mkdir RAW
		fi

		if [ "$quality" != "" ]
		then 
			numero_file_da_convertire=$#
			numero_file_convertiti=0



			(while [ "$numero_file_da_convertire" -gt "$numero_file_convertiti" ]; do 

				picture=$1


				((numero_file_convertiti += 1))
				if [ "$size" = "0" ]
				then
					/usr/bin/ufraw-batch $picture --wb=camera   --out-type=jpeg  --compression=$quality
				else if [ "$size" != "" ]
				then
					/usr/bin/ufraw-batch $picture --wb=camera   --out-type=jpeg  --compression=$quality --size=$size
				else 
					zenity --error --title "$error" --text "$sizeNOTchoosed"
					exit 1;			
				fi
				fi

				if [ "$move" = "move" ]
				then 
	 				mv $picture RAW/
				fi
				shift
			done) | zenity --progress --pulsate --text "Converting RAW files to Jpeg"
			exit 0;		
		else 
			zenity --error --title "$error" --text "$qualityNOTchoosed"
			exit 1;			
		fi
else	
  zenity --error --title "$error" --text "$nofilesselected"
  exit 1	
fi
