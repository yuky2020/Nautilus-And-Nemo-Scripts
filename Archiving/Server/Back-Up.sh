#!/bin/bash
"""
Type: Nautilus Script
Title: Sauver
Version: 1.2
 Package zenity must be installed.
"""

# Messages (en/fr)
case $LANG in
 en* )  msg_titre1='Server Backup'
  msg_titre2='Choice of files and directories to backup'
  msg_titre3='Files and directories'
msg_choix11=' 11. [(root)] LAMP backup (full folders 7z)'
msg_choix12=' 12. [(root)] Samba backup (full folders 7z)'
msg_choix13=' 13. [(root)] SSH backup (full folders 7z)'
msg_choix14=' 14. [(root)] Proftpd backup (full folders 7z)'
msg_choix15=' 15. [(root)] var/www folder backup (full folders 7z)'
  
 msg_job11='Backing up LAMP & proFTPd directories...7z'
msg_job12='Backing up Samba directories...7z'
msg_job13='Backing up SSH directories...7z'
msg_job14='Backing up Proftpd directories...7z'
msg_job15='Backing up var/www directories...7z'

  msg_info1='Finished.\nFiles have been updated in\n'
  msg_info2='Finished.\nFiles have been saved in\n'
  msg_info3='\n\WARNING!\nYou have to move these backups to\nan external storage device (CD, HD, USBK...).'
  ;;
 * )
  msg_titre1='Sauver'
  msg_titre2='Choix des fichiers et dossiers à sauvegarder'
  msg_titre3='Dossiers et fichiers'
  
msg_choix11=' 11. [(root)] LAMP backup (full in tgz)'
msg_choix12=' 11. [(root)] Samba backup (full in tgz)'
msg_choix13=' 13. [(root)] SSH backup (full folders 7z)'
msg_choix14=' 14. [(root)] Proftpd backup (full folders 7z)'
  msg_choix15=' 15. [(root)] var/www folder backup (full folders 7z)'

 msg_job11='Backing up LAMP  directories...'
 msg_job12='Backing up Samba directories...'
msg_job13='Backing up SSH directories...7z'
msg_job14='Backing up Proftpd directories...7z'
msg_job15='Backing up var/www directories...7z'

  msg_info1='Terminé.\nLes fichiers ont été mis à jour dans\n'
  msg_info2='Terminé.\nLes fichiers ont été sauvegardés dans\n'
  msg_info3='\n\nATTENTION !\nLe dossier /tmp/ sera VIDÉ !\nVous devez exporter ces sauvegardes\n(sur CD, clef USB, disque dur externe...)'
  ;;
esac

# Répertoires de destination
dirsave="/tmp"
datesave=$(date +%Y%m%d.%H%M)
newdirsave="/tmp/Backup"$datesave

# Choix des fichiers ou dossiers à sauvegarder
choice=$(zenity --list --checklist --width=330 --height=230 --title="${msg_titre1}" --text="${msg_titre2}" --column "" --column "${msg_titre3}" \
 TRUE "${msg_choix11}" \
 False "${msg_choix15}" \
 False "${msg_choix12}" \
 False "${msg_choix13}" \
 False "${msg_choix14}" \
 
)

# Vérification
if [ $choice -eq "" ]; then
  exit -1
 else
  mkdir $dirsave
  mkdir $newdirsave
fi

# SAUVEGARDES



# dossiers utilisateurs compressés
case "$choice" in *" 11."* )
 7z a -r $newdirsave/LAMP.$datesave.7z /etc/apache2 /etc/php5 /etc/phpmyadmin /etc/webalizer | zenity --title="${msg_titre1}" --progress --pulsate --auto-close --no-cancel --text="${msg_job11}"
  ;;
esac


case "$choice" in *" 12."* )
 7z a -r $newdirsave/SAMBA.$datesave.7z /etc/samba | zenity --title="${msg_titre1}" --progress --pulsate --auto-close --no-cancel --text="${msg_job12}"
  ;;
esac


case "$choice" in *" 13."* )
 7z a -r $newdirsave/SSH.$datesave.7z /etc/ssh | zenity --title="${msg_titre1}" --progress --pulsate --auto-close --no-cancel --text="${msg_job13}"
  ;;
esac



case "$choice" in *" 14."* )
 7z a -r $newdirsave/PROFTPD.$datesave.7z /etc/proftpd | zenity --title="${msg_titre1}" --progress --pulsate --auto-close --no-cancel --text="${msg_job14}"
  ;;
esac


case "$choice" in *" 15."* )
 7z a -r $newdirsave/WWWW.$datesave.7z /var/www | zenity --title="${msg_titre1}" --progress --pulsate --auto-close --no-cancel --text="${msg_job15}"
  ;;
esac


# fin
case "$choice" in
 *"mental"* )
  zenity --info --title="${msg_titre1}" --text="${msg_info1}""${newdirsave}""${msg_info3}"
  ;;
 " "* )
  zenity --info --title="${msg_titre1}" --text="${msg_info2}""${newdirsave}""${msg_info3}"
  ;;
esac

# EOF
