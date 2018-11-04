#!/bin/bash
ans=$(zenity  --title="Servers Management" --list  --width=200 --height=200 --text "Select from list below:" --radiolist  --column "Run" --column "Task" TRUE "SimpleHTTPServer8080" FALSE "SimpleHTTPServer8088" FALSE "SimpleHTTPServer8888" --separator=":")

arr=$(echo $ans | tr "\:" "\n")
clear
for x in $arr
do


if [ $x = "SimpleHTTPServer8080" ]
	then
		echo "=================================================="
		echo -e $RED"SimpleHTTPServer:8080"$ENDCOLOR
		/usr/bin/notify-send "SimpleHTTPServer:8080"
	       gnome-terminal -- python -m SimpleHTTPServer 8080
	fi



if [ $x = "SimpleHTTPServer8088" ]
	then
		echo "=================================================="
		echo -e $RED"SimpleHTTPServer:8080"$ENDCOLOR
		/usr/bin/notify-send "SimpleHTTPServer:8080"
	       gnome-terminal -- python -m SimpleHTTPServer 8088
	fi


if [ $x = "SimpleHTTPServer8888" ]
	then
		echo "=================================================="
		echo -e $RED"SimpleHTTPServer:8888"$ENDCOLOR
		/usr/bin/notify-send "SimpleHTTPServer:8888"
	       gnome-terminal -- python -m SimpleHTTPServer 8888
	fi

done

