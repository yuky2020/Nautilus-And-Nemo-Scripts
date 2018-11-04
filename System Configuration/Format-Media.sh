#!/bin/bash

# Copyright 2009 hemanth <hemanth@gmail.com> www.h3manth.com
#       
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#       
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#       
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.
media=( /dev/*sd* ) 
drive=$( zenity --title="Send files" --list --checklist --column="#"  --column="Drivers" $(for i in ${!media[@]}; do echo "$i"; echo "${media[$i]}"; done) )
res=( $(echo "$drive|" | sed '/|/s// /gp;d') )
format_type=$(zenity  --list  --text "Which file format ? " --radiolist --column "Pick" --column "options" TRUE "ext3" FALSE "fat"  --separator=":"); 

if [ "$drive" = "" ]; then 
    exit;
fi

if [ "$format_type" = "" ]; then 
    exit;
fi

for i in ${!res[@]}; do 
    sudo umount "${res[$i]}"
	done

if [ "$format_type" = "fat" ]; then 
   for i in ${!res[@]}; do 
     sudo mkfs.vfat "${res[$i]}"
   done
fi

if [ "$format_type" = "ext3" ]; then 
    
   for i in ${!res[@]}; do 
     sudo mkfs.ext3 "${res[$i]}"
   done
     
fi


if [ $? -eq 0 ]; then
zenity --info --text="$res Foramted in $format_type format "
else
zenity --info --text="Failed to format "
fi
