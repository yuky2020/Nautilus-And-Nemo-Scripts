#! /bin/bash

#       Copyright 2014 yasser <yasser33311 [at] Gmail.com> 
#       apt-get install ultracopier
 
 

sel=( /media/* ); 
drive=$( zenity --title="Send files" --list --checklist --column="#"  --column="Drivers" $(for i in ${!sel[@]}; do echo "$i"; echo "${sel[$i]}"; done) )


if [ "$drive" = "" ]; then 
    exit;
fi

res=( $(echo "$drive|" | sed '/|/s// /gp;d') )

for i in ${!res[@]}; do 
ultracopier cp $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS "${res[$i]}" ;
done


