#!/bin/sh
"""
Type: Nautilus Script
Title: Ouvrir
Version: 1.0
Info: choisit une application tierce pour ouvrir un fichier.
      select an (unlisted) application to open a file (ouvrir = to open).
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
  msg_titre="Open with..."
  msg_texte="Select an application "
  ;;
 * )
  msg_titre="Ouvrir avec..."
  msg_texte="Choisissez une application "
 ;;
esac

# Ouverture
prg=`zenity --file-selection --title=${msg_titre} --filename="/usr/bin/" --text=${msg_texte}`
$prg "$@"

# EOF
