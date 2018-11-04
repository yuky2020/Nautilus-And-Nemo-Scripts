#!/bin/bash
ans=$(zenity  --title="Servers Management" --list  --width=300 --height=400 --text "Select from list below:" --radiolist  --column "Run" --column "Task" TRUE "Status-Servers" FALSE "Start-Servers"  FALSE "Stop-Servers" FALSE "Start-All-Servers" FALSE "Stop-All-Servers" FALSE "Apache_SSL" FALSE "Tomcat" FALSE "Server-Live-Logs" FALSE "Server-Backup" FALSE "Webalizer" --separator=":")

arr=$(echo $ans | tr "\:" "\n")
clear
for x in $arr
do

     
if [ $x = "Start-Servers" ]
	then
		echo "=================================================="
		echo -e $RED"Start servers..."$ENDCOLOR
		/usr/bin/notify-send "Start servers..."
	       /usr/share/server/start_server.sh
               /usr/share/server/servers.sh
	fi


if [ $x = "Server-Backup" ]
	then
		echo "=================================================="
		echo -e $RED"Backup servers..."$ENDCOLOR
		/usr/bin/notify-send "Backup servers..."
	       /usr/share/server/back-up.sh
               /usr/share/server/servers.sh
	fi

if [ $x = "Server-Live-Logs" ]
	then
		echo "=================================================="
		echo -e $RED"Server-Logs"$ENDCOLOR
		/usr/bin/notify-send "Server-Logs"
	       /usr/share/server/server_logs.sh
               
	fi


if [ $x = "Stop-Servers" ]
	then
		echo "=================================================="
		echo -e $RED"Stop servers..."$ENDCOLOR
		/usr/bin/notify-send "Stop servers..."
	      /usr/share/server/stop_server.sh
               /usr/share/server/servers.sh
	fi


	



if [ $x = "Start-All-Servers" ]
	then
		echo "=================================================="
		echo -e $RED"Starting All servers..."$ENDCOLOR
		/usr/bin/notify-send "Starting All servers..."
                service apache2 start
                service proftpd start
                service smbd start
                service mysql start
		service ssh start
                service winbind start
                service webmin start
/opt/tomcat/bin/startup.sh

                /usr/share/server/servers.sh
	fi


if [ $x = "Stop-All-Servers" ]
	then
		echo "=================================================="
		echo -e $RED"Stoping All servers..."$ENDCOLOR
		/usr/bin/notify-send "Stoping All servers..."
                service apache2 stop
                service proftpd stop
                service smbd stop
                service mysql stop
		service ssh stop
                service winbind stop
                service webmin stop
/opt/tomcat/bin//shutdown.sh
                /usr/share/server/servers.sh
	fi




       if [ $x = "Status-Servers" ]
	then
		echo "=================================================="
		echo -e $RED"Starting Status-Servers"$ENDCOLOR
		/usr/bin/notify-send "Starting Status-Servers"
		
                /usr/share/server/status.sh
               
               /usr/share/server/servers.sh

	fi




if [ $x = "Apache_SSL" ]
	then
		echo "=================================================="
		echo -e $RED"Starting Apache-ssl"$ENDCOLOR
		/usr/bin/notify-send "Starting Apache-ssl"
		
                /usr/share/server/apachessl.sh
                 
               
                /usr/share/server/servers.sh

	fi


if [ $x = "Tomcat" ]
	then
		echo "=================================================="
		echo -e $RED"Starting Tomcat"$ENDCOLOR
		/usr/bin/notify-send "Starting Tomcat"
		
                /usr/share/server/tomcat

                /usr/share/server/servers.sh

	fi



  if [ $x = "Webalizer" ]
	then
		echo "=================================================="
		echo -e $RED"http://localhost/webalizer"$ENDCOLOR
		/usr/bin/notify-send "http://localhost/webalizer"
		sudo webalizer
               /usr/share/server/servers.sh
                
	fi

 

done
