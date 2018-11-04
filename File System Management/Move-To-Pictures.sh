#!/bin/sh

for arg
do
   if [ -f ~/Pictures/"$arg" ];    then
      MSG="File: '$arg' already exists in directory. Overwrite?"
      if
         gdialog --title "Overwrite?" --defaultno --yesno "$MSG" 200 100

      then
         mv "$arg" ~/Pictures/"$arg"
      fi
   else
     mv "$arg" ~/Pictures/"$arg"
   fi

done
