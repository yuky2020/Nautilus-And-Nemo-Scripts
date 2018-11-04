#!/bin/bash
"""
Type: Nautilus Script
Title: Lister 
Version: 1.1
Info: crée un catalogue détaillé des fichiers ou répertoires sélectionnés
      create a full listing of selected files and directories
Author: © Copyright (C) 2011, Airelle - http://rlwpx.free.fr/WPFF/nautilus.htm
License: GNU General Public License, version 3 or later - http://www.gnu.org/licenses/gpl.html
Usage : copier ce fichier dans le répertoire des scripts Nautilus de votre dossier personnel
        (~/.gnome2/nemo-scripts/) et vérifier que le script est exécutable (x).
        copy this file to the directory of Nautilus-scripts of your home
        (~/.gnome2/nemo-scripts/) and be sure that the script is executable.
"""

IFS='
'
for file in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS ;
do
 ls -a -l -R -X "${file}" > $(basename "${file}").log
done
gedit $(basename "${file}").log

# EOF
