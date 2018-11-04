#!/bin/bash
"""
Type: Nautilus Script
Title: Scanner
Version: 1.0
Info: scanne des fichiers ou répertoires avec l'antivirus ClamAV.
      scan files or directories with ClamAV antivirus (scanner = to scan).
Author: © Copyright (C) 2013, Airelle - http://rlwpx.free.fr/WPFF/nautilus.htm
Original language: french
License: GNU General Public License, version 3 or later - http://www.gnu.org/licenses/gpl.html
Usage : copier ce fichier dans le répertoire des scripts Nautilus de votre dossier personnel (~/.gnome2/nemo-scripts/)
        et vérifier que le script est exécutable (x). Les paquets "clamav" et "clamav-freshclam" doivent être installés.
        copy this file to the directory of Nautilus-scripts of your home (~/.gnome2/nemo-scripts/)
        and be sure that the script is executable. Packages "clamav" and "clamav-freshclam" (for updates) must be installed.
"""

# Messages
case $LANG in
 en* )
  msg='Analysis in progress...'
  ;;
 * )
  msg='Analyse en cours...'
 ;;
esac

# Analyse
clamscan -rv --bell --log=ClamAV.log --max-filesize=9M --max-scansize=99M "$@" | zenity --progress --pulsate --auto-close --title="ClamAV" --text="$msg"
zenity --text-info --width=800 --height=600 --title="$titre" --filename=ClamAV.log

rm -f ClamAV.log

# EOF
