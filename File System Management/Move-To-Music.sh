#!/bin/sh

for arg
do
   if [ -f ~/Music/"$arg" ];    then
      MSG="File: '$arg' already exists in directory. Overwrite?"
      if
         gdialog --title "Overwrite?" --defaultno --yesno "$MSG" 200 100

      then
         mv "$arg" ~/Music/"$arg"
      fi
   else
     mv "$arg" ~/Music/"$arg"
   fi

done
