#!/bin/bash
######################################################################################
#							
# Move To Securely - copies files and removes the original file with 38 pass				
#							
# Licensed under the GNU GENERAL PUBLIC LICENSE 3	
#							
# Copyright 2011 Md. Toukir Imam		
# 
# Depends: SRM (or Secure Remove) [http://en.wikipedia.org/wiki/Srm_(Unix)]			
#		
######################################################################################
file_uris=$NAUTILUS_SCRIPT_SELECTED_URIS

destination=$(zenity --file-selection --directory --title "Where to move files?")
if (( $? == 0 )); then
let num=0

for file in $file_uris; do
	$(( num++ ))
done


let deleted=0
(

for file in $file_uris; do 

	file_name=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g')
	shortfile=$(echo $file | sed -e 's#.*/##g' -e 's/\%20/\ /g')

	if [[ -w $destination && -e $destination/$shortfile ]]; then 
		 zenity --question --title="Move To.. Securely" --text "Overwrite $destination with $shortfile?"
		 
		if (( $? == 0 )); then
		echo "#Copying $shortfile "
		echo $deleted*100/$num | bc
			cp -r "$file_name" "$destination"
			
			if (( $? != 0 )); then
				zenity --error --text "File can not be moved " --title "Failure"
				else
				echo "#Securely removing $shortfile"
				srm -r "$file_name"
				if (( $? != 0 )); then
				zenity --error --text="$Copy successful but \n$shortfile couldn't be securely removed" --title "Failure"
				fi
			fi
			
		fi
	elif [[ -w $destination ]]; then 
		echo "#Copying $shortfile "
		echo $deleted*100/$num | bc
		cp -r "$file_name" "$destination"
		
		if (( $? != 0 )); then
			zenity --error  --text "File moving failed " --title "Failure"
			else
				echo "#Securely removing $shortfile" 
				srm -r "$file_name"
				if (( $? != 0 )); then
				zenity --error --text="$Copy successful but \n$shortfile couldn't be securely removed" --title "Failure"
				fi
		fi
	
	else	zenity --error --title "Failure" --text "$destination either does not\nexist or is not writable"
	fi 
	$(( deleted++ ))
done


) |
	 zenity --progress \
          --title="Move To.. Securely" \
          --text="Initializing" \
          --percentage=0  \
		  --width=350 \
		  --auto-close

fi
