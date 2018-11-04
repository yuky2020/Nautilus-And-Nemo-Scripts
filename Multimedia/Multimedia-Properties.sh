#!/bin/bash
"""
Type: Nautilus Script
Title: Prop
Version: 1.0
Info: affiche les propriétés d'un fichier audio ou vidéo.
      displays the properties of an audio or video file.
Author: © Copyright (C) 2013, Airelle - http://rlwpx.free.fr/WPFF/nautilus.htm
Original language: french
Translations:
- to english: Airelle - http://rlwpx.free.fr/WPFF/nautilus.htm
License: GNU General Public License, version 3 or later - http://www.gnu.org/licenses/gpl.html
Usage : copier ce fichier dans le répertoire des scripts Nautilus de votre dossier personnel (~/.gnome2/nemo-scripts/)
        et vérifier que le script est exécutable (x). Les paquets mplayer et zenity doivent être installés.
        copy this file to the directory of Nautilus-scripts of your home (~/.gnome2/nemo-scripts/)
        and be sure that the script is executable (x). Packages mplayer and zenity must be installed.
"""

# Messages
case $LANG in
 en* )
  msg_titre='Properties of'
  ;;
 * )
  msg_titre='Propriétés de'
 ;;
esac

# Analyse
 if=`mplayer -msglevel identify=1 -frames 0 "$1" | grep detected`
 if2=`mplayer -msglevel identify=4 -frames 0 "$1" | grep ID_DEMUXER`
 if3=`mplayer -msglevel identify=4 -frames 0 "$1" | grep ID_LENGTH`
 ia=`mplayer -msglevel identify=1 -frames 0 "$1" | grep AUDIO:`
 iv=`mplayer -msglevel identify=1 -frames 0 "$1" | grep VIDEO:`

# Rapport
zenity --info --title="${msg_titre} $1" --text="$if\n\n$if2\n$if3 s\n\n$ia\n\n$iv"

# EOF

