#!/bin/bash
# Author : Cezar Matei
process=`ps -u $USER | zenity --list --column "Please select a process to unpause:" --text="List all $USER processes:" --width 450 --height 570`

ans=`echo $?`

	if test "$ans" -eq "0" ;
	then

		select=`echo $process | cut -d" " -f1`
		
		kill -CONT $select
			ans1=`echo $?`
			if [ "$ans1" == "0" ] ;
			then 
			select1=`echo $process | cut -d":" -f3  | cut -d" " -f2`
 			echo | zenity --info --text="Process '$select1' with pid '$select' was unpaused!" --width 400 --height 150
			else
 			echo | zenity --error --text="Process '$select1' with pid '$select' not found!" --width 200 --height 100
			fi
	exit 0
 	fi 
 
	if test "$ans" -eq "1" ;
	then
	echo | zenity --error --text="You have cancel" --width 200 --height 100
	exit 0
	fi

 
