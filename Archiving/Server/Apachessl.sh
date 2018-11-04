#!/bin/bash
ans=$(zenity  --title="Apache SSL" --list  --width=200 --height=200 --text "Select from list below:" --radiolist  --column "Run" --column "Task" TRUE "Apache-ssl-enable" FALSE "Apache-ssl-disable" --separator=":")

arr=$(echo $ans | tr "\:" "\n")
clear
for x in $arr
do

     
if [ $x = "Apache-ssl-enable" ]
	then
		echo "=================================================="
		echo -e $RED"Start servers..."$ENDCOLOR
		/usr/bin/notify-send "Start servers..."
	       sudo a2ensite default-ssl
                 sudo service apache2 reload
              
               
	fi


if [ $x = "Apache-ssl-disable" ]
	then
		echo "=================================================="
		echo -e $RED"Stop servers..."$ENDCOLOR
		/usr/bin/notify-send "Stop servers..."
	       sudo a2dissite default-ssl
                sudo service apache2 reload
	fi

done
