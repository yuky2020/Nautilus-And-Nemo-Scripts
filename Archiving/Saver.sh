#!/bin/bash
"""
Type: Nautilus Script
Title: Sauver
Version: 1.1
Info: sauvegarde quelques fichiers et dossiers importants
      backup some important files et directories ("sauver"=to save)
Author: © Copyright (C) 2011, Airelle - http://rlwpx.free.fr/WPFF/nautilus.htm
Original language: french
Translations:
- to english: Airelle - http://rlwpx.free.fr/WPFF/nautilus.htm
License: GNU General Public License, version 3 or later - http://www.gnu.org/licenses/gpl.html
Usage : copier ce fichier dans le répertoire des scripts Nautilus de votre dossier personnel (~/.gnome2/nemo-scripts/)
        et vérifier que le script est exécutable (x). Le paquet "zenity" doit être installé.
        copy this file to the directory of Nautilus-scripts of your home (~/.gnome2/nemo-scripts/)
        and be sure that the script is executable. Package "zenity" must be installed.
"""

# Messages (en/fr)
case $LANG in
 en* )  msg_titre1='Sauver (Save)'
  msg_titre2='Choice of files and directories to backup'
  msg_titre3='Files and directories'
  msg_choix1=' 1. [quick (root)] MBR and partition tables'
  msg_choix2=' 2. [quick] System configuration files'
  msg_choix3=' 3. [quick] Personal configuration files'
  msg_choix4=' 4. Personnal Office sub-directories LibO/OOo (in 7z)'
  msg_choix5=' 5. Personnal browsers sub-directories Cr/FF/Op (in 7z)'
  msg_choix6=' 6. [slow] Personal home directory (incremental)'
  msg_choix7=' 7. [very slow] Personal home directory (full in tgz)'
  msg_choix8=' 8. [slow (root)] Users home directories (incremental)'
  msg_choix9=' 9. [very slow (root)] Users home directories (full in tgz)'
  msg_job41='Compressing LibO directory...'
  msg_job42='Compressing OOo directory...'
  msg_job51='Compressing Chromium directory...'
  msg_job52='Compressing Firefox directory...'
  msg_job53='Compressing Opera directory...'
  msg_job6='Backing up personal home directory...'
  msg_job7='Compressing personal home directory...'
  msg_job8='Backing up of users home directories...'
  msg_job9='Compressing users home directories...'
  msg_info1='Finished.\nFiles have been updated in\n'
  msg_info2='Finished.\nFiles have been saved in\n'
  msg_info3='\n\WARNING!\nThe /tmp/ directory will be ERASED\nYou have to move these backups to\nan external storage device (CD, HD, USBK...).'
  ;;
 * )
  msg_titre1='Sauver'
  msg_titre2='Choix des fichiers et dossiers à sauvegarder'
  msg_titre3='Dossiers et fichiers'
  msg_choix1=' 1. [rapide (root)] MBR et tables de partition'
  msg_choix2=' 2. [rapide] Fichiers de configuration système'
  msg_choix3=' 3. [rapide] Fichiers de configuration personnelle'
  msg_choix4=' 4. Sous-dossiers personnels Office LibO/OOo (en 7z)'
  msg_choix5=' 5. Sous-dossiers personnels navigateurs Cr/FF/Op (en 7z)'
  msg_choix6=' 6. [lent] Dossier personnel (incrémental)'
  msg_choix7=' 7. [très lent] Dossier personnel (complet en tgz)'
  msg_choix8=' 8. [lent (root)] Dossiers utilisateurs (incrémental)'
  msg_choix9=' 9. [très lent (root)] Dossiers utilisateurs (complet en tgz)'
  msg_job41='Compression du dossier LibO...'
  msg_job42='Compression du dossier OOo...'
  msg_job51='Compression du dossier Chromium...'
  msg_job52='Compression du dossier Firefox...'
  msg_job53='Compression du dossier Opera...'
  msg_job6='Sauvegarde du dossier personnel...'
  msg_job7='Compression du dossier personnel...'
  msg_job8='Sauvegarde des dossiers utilisateurs...'
  msg_job9='Compression des dossiers utilisateurs...'
  msg_info1='Terminé.\nLes fichiers ont été mis à jour dans\n'
  msg_info2='Terminé.\nLes fichiers ont été sauvegardés dans\n'
  msg_info3='\n\nATTENTION !\nLe dossier /tmp/ sera VIDÉ !\nVous devez exporter ces sauvegardes\n(sur CD, clef USB, disque dur externe...)'
  ;;
esac

# Répertoires de destination
dirsave="/tmp/Backup"
datesave=$(date +%Y%m%d.%H%M)
newdirsave="/tmp/Backup"$datesave

# Choix des fichiers ou dossiers à sauvegarder
choice=$(zenity --list --checklist --width=500 --height=400 --title="${msg_titre1}" --text="${msg_titre2}" --column "" --column "${msg_titre3}" \
 TRUE "${msg_choix1}" \
 TRUE "${msg_choix2}" \
 TRUE "${msg_choix3}" \
 FALSE "${msg_choix4}" \
 FALSE "${msg_choix5}" \
 FALSE "${msg_choix6}" \
 FALSE "${msg_choix7}" \
 FALSE "${msg_choix8}" \
 FALSE "${msg_choix9}" \
)

# Vérification
if [ $choice -eq "" ]; then
  exit -1
 else
  mkdir $dirsave
  mkdir $newdirsave
fi

# SAUVEGARDES

# MBR et tables de partitions (root)
case "$choice" in *" 1."* )
  dd if=/dev/sda of=$newdirsave/mbr.$datesave.img bs=512 count=63
  dd if=/dev/sda of=$newdirsave/part1.$datesave.bin bs=512 count=1
  dd if=/dev/sda2 of=$newdirsave/part2.$datesave.bin bs=512 count=1
  dd if=/dev/sda3 of=$newdirsave/part3.$datesave.bin bs=512 count=1
  dd if=/dev/sda4 of=$newdirsave/part4.$datesave.bin bs=512 count=1
  dd if=/dev/sda5 of=$newdirsave/part5.$datesave.bin bs=512 count=1
  ;;
esac

# configuration système (GRUB, fstab, serveur Xorg, paquets installés, pare-feu, certificats, réseau)
case "$choice" in *" 2."* )
  cp /boot/grub/grub.cfg $newdirsave
  cp /boot/grub/grub2.cfg $newdirsave
  cp /boot/grub/menu.lst $newdirsave
  cp /etc/apt/sources.list $newdirsave
  cp /etc/apt/sources.list.distUpgrade $newdirsave
  cp /etc/cert/ca.pem $newdirsave
  cp /etc/cert/user.pem $newdirsave
  cp /etc/cert/user.prv $newdirsave
  cp /etc/network/interfaces $newdirsave
  cp /etc/NetworkManager/nm-system-settings.conf $newdirsave
  cp /etc/wicd/wired-settings.conf $newdirsave
  cp /etc/X11/xorg.conf $newdirsave
  cp /etc/fstab $newdirsave
  cp /etc/hosts $newdirsave
  cp /etc/issue $newdirsave
  cp /etc/ld.so.conf $newdirsave
  cp /etc/rc.local $newdirsave
  cp /etc/resolv.conf $newdirsave
  cp /etc/wifi-radar.conf $newdirsave
  cp /etc/wpa_supplicant.conf $newdirsave
  cp /proc/partitions $newdirsave
  cp /etc/init.d/*iptables* $newdirsave
  cp /etc/init.d/dbus $newdirsave
  cp /lib/init/upstart-job $newdirsave
  dpkg --get-selections > $newdirsave/liste_paquets
  # restaurer : sudo apt-get update & sudo dpkg --set-selections < $newdirsave/liste_paquets & sudo apt-get -u dselect-upgrade
  ;;
esac

# configuration personnelle (menus, applications)
case "$choice" in *" 3."* )
  cp ~/.local/share/applications/mimeapps.list $newdirsave
  cp ~/.local/share/applications/mimeinfo.cache $newdirsave
  cp ~/.config/menus/settings.menu $newdirsave
  cp ~/.config/menus/applications.menu $newdirsave
  cp ~/.kde/share/apps/akregator/data/feeds.opml $newdirsave
  cp ~/.local/share/rhythmbox/*.xml $newdirsave
  dpkg gconftool-2 --dump / > $newdirsave/user_conf.xml
  # restaurer : gconftool-2 --load=$newdirsave/user_conf.xml	
  ;;
esac

# répertoires d'Office (configuration, préférences)
case "$choice" in *" 4."* )
  7z a -r $newdirsave/LibO.$datesave.7z ~/.libreoffice/ | zenity --title="${msg_titre1}" --progress --pulsate --auto-close --no-cancel --text="${msg_job41}"
  7z a -r $newdirsave/OOo.$datesave.7z ~/.openoffice.org/ | zenity --title="${msg_titre1}" --progress --pulsate --auto-close --no-cancel --text="${msg_job42}"
  ;;
esac

# répertoires des navigateurs (configuration, préférences)
case "$choice" in *" 5."* )
  7z a -r $newdirsave/Chromium.$datesave.7z ~/.config/chromium| zenity --title="${msg_titre1}" --progress --pulsate --auto-close --no-cancel --text="${msg_job51}"
  7z a -r $newdirsave/Firefox.$datesave.7z ~/.mozilla | zenity --title="${msg_titre1}" --progress --pulsate --auto-close --no-cancel --text="${msg_job52}"
  7z a -r $newdirsave/Opera.$datesave.7z ~/.opera | zenity --title="${msg_titre1}" --progress --pulsate --auto-close --no-cancel --text="${msg_job53}"
  ;;
esac

# dossier personnel
case "$choice" in *" 6."* )
  rsync -aq --exclude "*.thumbnails" ~ $dirsave/home/ | zenity --title="${msg_titre1}" --progress --pulsate --auto-close --no-cancel --text="${msg_job6}"
  ;;
esac

# dossier personnel compressé
case "$choice" in *" 7."* )
  tar cfvz $newdirsave/user.$datesave.tgz ~ | zenity --title="${msg_titre1}" --progress --pulsate --auto-close --text="${msg_job7}"
  ;;
esac

# dossiers utilisateurs
case "$choice" in *" 8."* )
  rsync -aq --exclude "*.thumbnails" /home/ $dirsave/home/ | zenity --title="${msg_titre1}" --progress --pulsate --auto-close --no-cancel --text="${msg_job8}"
  ;;
esac

# dossiers utilisateurs compressés
case "$choice" in *" 9."* )
  tar cfvz $newdirsave/users.$datesave.tgz /home/ | zenity --title="${msg_titre1}" ²--progress --pulsate --auto-close --text="${msg_job9}"
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
