#!/bin/bash
ans=$(zenity  --title="Servers Live Logs" --list  --width=300 --height=300 --text "Select from list below:" --radiolist  --column "Run" --column "Task" TRUE "Apache_access_log" False "Apache_error_log" FALSE "Apache_ssl_log" FALSE "Apache_vhosts_log" FALSE "Proftpd_log" FALSE "Proftpd_transfer_log" FALSE "Auth_and_SSH_log" --separator=":")

arr=$(echo $ans | tr "\:" "\n")
clear
for x in $arr
do

     
if [ $x = "Apache_access_log" ]
	then
		echo "=================================================="
		echo -e $RED"Apache_access_log."$ENDCOLOR
		/usr/bin/notify-send "Apache_access_log."
	       tail -f /var/log/apache2/access.log | zenity --title "Apache Access Log Viewer(don't close window to see live log)" --text-info --width 1024 --height 600 & /usr/share/server/server_logs.sh
	fi


if [ $x = "Apache_error_log" ]
	then
		echo "=================================================="
		echo -e $RED"Apache_error_log"$ENDCOLOR
		/usr/bin/notify-send "Apache_error_log"
	       tail -f /var/log/apache2/error.log | zenity --title "Apache Error Log Viewer (don't close window to see live log)" --text-info --width 1024 --height 600 & /usr/share/server/server_logs.sh
	fi


	



if [ $x = "Apache_ssl_log" ]
	then
		echo "=================================================="
		echo -e $RED"apache_ssl_log"$ENDCOLOR
		/usr/bin/notify-send "apache_ssl_log"
              tail -f /var/log/apache2/ssl_access.log | zenity --title "Apache SSL access Log Viewer (don't close window to see live log)" --text-info --width 1024 --height 600 & /usr/share/server/server_logs.sh
	fi


if [ $x = "Apache_vhosts_log" ]
	then
		echo "=================================================="
		echo -e $RED"apache_vhosts_log"$ENDCOLOR
		notify-send "apache_vhosts_log"
tail -f /var/log/apache2/other_vhosts_access.log | zenity --title "Apache Vhosts Log Viewer(don't close window to see live log)" --text-info --width 1024 --height 600 & /usr/share/server/server_logs.sh
	fi




       if [ $x = "Proftpd_log" ]
	then
		echo "=================================================="
		echo -e $RED"Proftpd_log"$ENDCOLOR
		notify-send "Proftpd_log"
		
               tail -f /var/log/proftpd/proftpd.log | zenity --title "Proftpd Log Viewer (don't close window to see live log)" --text-info --width 1024 --height 600 & /usr/share/server/server_logs.sh
fi

 if [ $x = "Proftpd_transfer_log" ]
	then
		echo "=================================================="
		echo -e $RED"Proftpd_transfer_log"$ENDCOLOR
		notify-send "Proftpd_transfer_log"
		
               tail -f /var/log/proftpd/xferlog | zenity --title "Proftpd File Transfered Log Viewer (don't close window to see live log)" --text-info --width 1024 --height 600 & /usr/share/server/server_logs.sh
fi


if [ $x = "Auth_and_SSH_log" ]
	then
		echo "=================================================="
		echo -e $RED"Auth and SSH_log"$ENDCOLOR
		notify-send "Auth and SSH_log"
		
               tail -f /var/log/auth.log | zenity --title "Auth and SSH Log Viewer (don't close window to see live log)" --text-info --width 1024 --height 600 & /usr/share/server/server_logs.sh
fi


done
