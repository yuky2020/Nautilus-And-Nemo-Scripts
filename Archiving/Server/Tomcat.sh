#!/bin/bash
ans=$(zenity  --title="Tomcat Management" --list  --width=200 --height=200 --text "Select from list below:" --radiolist  --column "Run" --column "Task" TRUE "Tomcat-Start" FALSE "Tomcat-Stop" FALSE "Tomcat-Restart" --separator=":")

arr=$(echo $ans | tr "\:" "\n")
clear
for x in $arr
do

     


if [ $x = "Tomcat-Start" ]
	then
		echo "=================================================="
		echo -e $RED"Starting Tomcat"$ENDCOLOR
		/usr/bin/notify-send "Starting Tomcat"
		
/opt/tomcat/bin/startup.sh
                /usr/share/server/tomcat

                

	fi


if [ $x = "Tomcat-Stop" ]
	then
		echo "=================================================="
		echo -e $RED"Stoping Tomcat"$ENDCOLOR
		/usr/bin/notify-send "Stoping Tomcat"
		
/opt/tomcat/bin/shutdown.sh
                /usr/share/server/tomcat

                

	fi

  if [ $x = "Tomcat-Restart" ]
	then
		echo "=================================================="
		echo -e $RED"Restarting Tomcat"$ENDCOLOR
		/usr/bin/notify-send "Restarting Tomcat"
		
/opt/tomcat/bin/restart.sh
                /usr/share/server/tomcat

                

	fi
 

done
