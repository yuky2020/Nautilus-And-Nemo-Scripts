#!/bin/bash
##################################################################
#							                            
#  Securely Removes	Removes files with 38 pass              
#							                            
#  Licensed under the GNU GENERAL PUBLIC LICENSE 3			
#							                            
#  Copyright 2011 Md. Toukir Imam                         
#  
#  Depends: SRM (or Secure Remove)    [http://en.wikipedia.org/wiki/Srm_(Unix)]						                         
#   
###################################################################



 let num=0;
 file_uris=$NAUTILUS_SCRIPT_SELECTED_URIS
for file in $file_uris; do
	
	filenames="$filenames, $(echo $file | sed -e 's/\%20/\ /g' -e 's/.*\///g')"
	$(( num++ ))
done

filenames=$(echo $filenames | sed 's/.\(.*\)/\1/')
zenity --question --title "Secure Remove" --text "Do you want to securely remove the following file(s)?\n$filenames"


if (( $? == 0 )); then
	let deleted=0
	( 
	
	for file in $file_uris; do

		shortfile=$(echo $file | sed -e 's/\%20/\ /g' -e 's/.*\///g')

		file_name=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g')

		
		echo "#Now removing $shortfile "
		echo $deleted*100/$num | bc
		
		srm -r "$file_name"
		
		if (( $? != 0 )); then
			zenity --info --text="$shortfile couldn't be securely removed" --title "Failure"
		fi
		$(( deleted++ ))
		
	done 
	) |
	 zenity --progress \
          --title="Secure Remove" \
          --text="Initializing" \
          --auto-close \
          --percentage=0 \ 
          --width=350
		  
fi



