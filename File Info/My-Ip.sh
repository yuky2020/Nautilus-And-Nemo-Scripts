#!/bin/bash
"""
Type: Nautilus Script
Title: MonIP
Version: 1.1
Info: connaître son adresse IP publique.
      to know the public IP address (Mon IP = My IP).
Author: © Copyright (C) 2012, Airelle - http://rlwpx.free.fr/WPFF/nautilus.htm
Original language: french
Translations:
- to english: Airelle - http://rlwpx.free.fr/WPFF/nautilus.htm
License: GNU General Public License, version 3 or later - http://www.gnu.org/licenses/gpl.html
Usage : copier ce fichier dans le répertoire des scripts Nautilus de votre dossier personnel (~/.gnome2/nemo-scripts/)
        et vérifier que le script est exécutable (x). Le paquet zenity doit être installé.
        copy this file to the directory of Nautilus-scripts of your home (~/.gnome2/nemo-scripts/)
        and be sure that the script is executable (x). Package zenity must be installed.
"""

# Messages
case $LANG in
 en* )
  msg_titre='My IP is...'
  msg_defaut='impossible to find : verify the connection.'
  ;;
 * )
  msg_titre='Mon IP est...'
  msg_defaut='impossible à trouver : vérifier la connexion'
 ;;
esac

# Lecture
IP=`GET rlwpx.free.fr/WPFF/MonIP2.php | sed -n '/[\x20]$/p'`
if [ $IP -eq ]; then IP=${msg_defaut}; fi;

# Affichage
zenity --info --title="${msg_titre}" --text="$IP"

# EOF


