#!/bin/bash
"""
Type: Nautilus Script
Title: Alerter
Version: 3.0
Info: une simple alarme programmable visuelle et sonore.
      just a basic visual and audible alarm (alerter = to alert).
Author: © Copyright (C) 2011, Airelle - http://rlwpx.free.fr/WPFF/nautilus.htm
Original language: french
Translations:
- to english: Airelle - http://rlwpx.free.fr/WPFF/nautilus.htm
License: GNU General Public License, version 3 or later - http://www.gnu.org/licenses/gpl.html
Usage : copier ce fichier dans le répertoire des scripts Nautilus de votre dossier personnel (~/.gnome2/nemo-scripts/)
        et vérifier que le script est exécutable (x). Le paquet zenity doit être installé.
        copy this file to the directory of nemo-scripts of your home (~/.gnome2/nemo-scripts/)
        and be sure that the script is executable (x). Package zenity must be installed.
"""
IFS='
'
# Messages
case $LANG in
 en* )
  msg_titre="Alerter (Alert)"
  msg_param1="Time alert (hh:mm) or delay in minutes :"
  msg_param2="Message to display (facultative) :"
  msg_param3="Sound to play (facultative) :"
  msg_err1="Bad input:\nChoose the waiting period (1 to 1440)\nor an hour (00:00 to 23:59)."
  msg_err2="Invalid time:\nThe maximum is 23:59."
  msg_err3="Invalid time delay:\nThe minimum is 1 (minute) and\nthe maximum is 1440 (minutes)."
  msg_info="It is "
  msg_defaut="It's time now!"
  ;;
 * )
  msg_titre="Alerter"
  msg_param1="Heure de l'alerte (hh:mm) ou délai en minutes :"
  msg_param2="Message à afficher (facultatif) :"
  msg_param3="Choisissez le fichier sonore (facultatif) :"
  msg_err1="Saisie incorrecte :\nEntrez un délai (1 à 1440) ou\nune heure (00:00 à 23:59)."
  msg_err2="Heure non valide :\nLe maximum est 23:59."
  msg_err3="Délai non valide :\nLe minimum est de 1 (minute) et\nle maximum est de 1440 (minutes)."
  msg_info="Il est "
  msg_defaut="C'est l'heure !"
 ;;
esac

# Heure
valeur=$(zenity --entry --title="${msg_titre} $(date +%H:%M)" --text="${msg_param1}")
if [ $? -eq 1 ]; then exit; fi;

# Vérification
case $valeur in
 *[!0-9:]*|"" )
  zenity --error --title="${msg_titre}" --text="${msg_err1}"; exit -1
 ;;
 *:* )
  hh=${valeur%%:*};mm=${valeur##*:};alerte=$hh$mm
  if [ $hh -gt 23 ] || [ $mm -gt 59 ]; then zenity --error --title="${msg_titre}" --text="${msg_err2}"; exit -1; fi;
 ;;
 * )
  if [ $valeur -lt 1 ] || [ $valeur -gt 1440 ]; then zenity --error --title="${msg_titre}" --text="${msg_err3}"; exit -1; fi;
  alerte=$(date +%H%M --date='+'$valeur' minutes')
 ;;
esac

# Message
msg_msg=$(zenity --entry --title="${msg_titre}" --text="${msg_param2}")
if [ $msg_msg -eq ]; then msg_msg=$msg_defaut; fi;

# Bip
msg_son=`cat ~/.gnome2/nemo-scripts/.alerte/Alerte`
# Choix du son :
# msg_son=`zenity --file-selection --title="${msg_titre}" --filename="/usr/share/sounds/" --text=${msg_param3}`
if [ $msg_son -eq ]; then msg_son="/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga"; fi;

# Veille
until [ $(date +%H%M) -eq $alerte ]
do
 sleep 6
done

# Alerte
case $LANG in
 fr* )
  msg_info="${msg_info} $(date +%H) h $(date +%M)"
 ;;
 * )
  msg_info="${msg_info} $(date +%H:%M)"
 ;;
esac
mplayer -nogui -quiet $msg_son
zenity --warning --title="${msg_titre}" --text=" ${msg_info} \n ${msg_msg}"

# EOF
