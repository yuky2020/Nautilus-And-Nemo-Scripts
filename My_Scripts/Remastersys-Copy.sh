#! /bin/bash



##################################################
# Copy Remastersys backups to '~/Backups' folder #
# (only after Remastersys has backed-up stuff)	 #
##################################################

# requires: sudo apt-get install remastersys
    notify-send -t 3000 -i /usr/share/icons/gnome/32x32/status/info.png "Remastersys ISO Copy Started"
    DISTRIB_ID=`cat /etc/lsb-release | grep DISTRIB_ID | cut -d '=' -f 2`
    DISTRIB_CODENAME=`lsb_release -cs | sed "s/^./\u&/"`
    if [ ! -d "$HOME/Backups" ]; then
	mkdir "$HOME/Backups"
    fi
    if [ ! -d "$HOME/Backups/$DISTRIB_ID $DISTRIB_CODENAME Backup `date +-%e-%m-%Y`" ]; then
	mkdir "$HOME/Backups/$DISTRIB_ID $DISTRIB_CODENAME Backup `date +-%e-%m-%Y`"
	cd "$HOME/Backups/$DISTRIB_ID $DISTRIB_CODENAME Backup `date +-%e-%m-%Y`"
	echo 'Password:		password' >> Password.txt
	cp /home/remastersys/remastersys/custom-backup.iso "$HOME/Backups/$DISTRIB_ID $DISTRIB_CODENAME Backup `date +-%e-%m-%Y`"
	cd ..
	cd ..
	notify-send -t 3000 -i /usr/share/icons/gnome/32x32/status/info.png "Remastersys ISO Copy Finished"
    else
	mkdir "$HOME/Backups/$DISTRIB_ID $DISTRIB_CODENAME Backup `date +-%e-%m-%Y_%H%M`"
	cd "$HOME/Backups/$DISTRIB_ID $DISTRIB_CODENAME Backup `date +-%e-%m-%Y_%H%M`"
	echo 'Password:		password' >> Password.txt
	cp /home/remastersys/remastersys/custom-backup.iso "$HOME/Backups/$DISTRIB_ID $DISTRIB_CODENAME Backup `date +-%e-%m-%Y_%H%M`"
	cd ..
	cd ..
	notify-send -t 3000 -i /usr/share/icons/gnome/32x32/status/info.png "Remastersys ISO Copy Finished"
    fi
