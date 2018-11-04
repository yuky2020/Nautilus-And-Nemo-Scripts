#!/bin/sh
# copyhome:  copies the selected file(s) to home directory
# (if able)

for arg 
do
   if [ -f ~/Documents/"$arg" ];    then
      MSG="File: '$arg' already exists in home directory. Overwrite?"
      if    
         gdialog --title "Overwrite?" --defaultno --yesno "$MSG" 200 100 
      
      then
         cp "$arg" ~/Documents/"$arg"
      fi
   else
     cp "$arg" ~/Documents/"$arg"
   fi

done