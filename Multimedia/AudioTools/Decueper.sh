#!/bin/bash
"""
Type: Nautilus Script
Title: Decueper
Version: 1.0
Info: découpe une image CD audio selon les pistes en fichiers au format Flac (sans perte)
      "Decueper" est un jeu de mots entre "découper" et "cue" (fichier de métadonnées d’une image disque)
      cut an audio image CD to his tracks in the losless Flac format
      "Decueper" is a french play on words based on the combination of words "découper" (to cut) and "cue" (index file)
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

IFS='
'
# Messages
case $LANG in
 en* )
  msg_titre="Decueper (Split)"
  msg_job1="Spliting of "
  msg_job2=".\nPlease wait during the tracks extraction."
  msg_info="Spliting finished. Enjoy!\n\nNote that track names may be uncomplete ou redondant\nbecause of the variability of metadata completion."
  msg_erreur1=" is not a CUE sheet."
  msg_erreur2="The audio image file"
  msg_erreur3="was not found."
  msg_erreur4="Error! Please, vérify:\n- if ther is special characters in tags, for example \"/\";\n- the integrity of the audio file;\n- your reading/writing rights (rw) ;\n- the dependencies\n  (install cuetools shntool flac wavpack\n  and xmms2-plugin-apefile);\n- the free space on your disk (about 400 Mo needed)."
 ;;
 * )
  msg_titre="Decueper"
  msg_job1="Découpage de "
  msg_job2=".\nVeuillez patienter pendant l'extraction des pistes."
  msg_info="Découpage en Flac terminé. Bonne écoute !\n\nNotez que le nom des pistes peut comporter des manques\nou des redondances en raison des métadonnées utilisées."
  msg_erreur1=" n'est pas un fichier CUE d'index de pistes."
  msg_erreur2="L'image audio"
  msg_erreur3="n'a pas été trouvée."
  msg_erreur4="Erreur ! Veuillez vérifier :\n- l'absence de caractères spéciaux dans les tags, par exemple \"/\" ;\n- l'intégrité du fichier audio ;\n- vos droits en écriture (rw) ;\n- les dépendances\n  (installer cuetools shntool flac wavpack\n  et xmms2-plugin-apefile) ;\n- l'espace disque libre (prévoir 400 Mo)."
 ;;
esac

# Vérification du fichier cue sheet
csf="$1"
fn="${csf%%.cue}"
cue=$(echo "${csf##*.}"|tr A-Z a-z)
if [ ! -f "$csf" ] || [ "$cue" != "cue" ]; then
 zenity --error --title="${msg_titre}" --text=$csf"${msg_erreur1}"
 exit -1
fi

# Recherche du fichier image correspondant
ext=""
if [ -f "$fn"."ape" ]; then ext="ape"; fi
if [ -f "$fn"."APE" ]; then ext="APE"; fi
if [ -f "$fn"."flac" ]; then ext="flac"; fi
if [ -f "$fn"."FLAC" ]; then ext="FLAC"; fi
if [ -f "$fn"."wav" ]; then ext="wav"; fi
if [ -f "$fn"."WAV" ]; then ext="WAV"; fi
if [ -f "$fn"."wv" ]; then ext="wv"; fi
if [ -f "$fn"."WV" ]; then ext="WV"; fi
if [ "$ext" == "" ]; then
 zenity --error --title="${msg_titre}" --text="${msg_erreur2}\n$fn.ape/flac/wav/wv\n${msg_erreur3}"
 exit -1
fi

# Découpage en pistes Flac
cuebreakpoints "$csf" | shnsplit -o flac "$fn.$ext" | zenity --title="${msg_titre}" --progress --pulsate --auto-close --text="${msg_job1}"$fn.$ext"${msg_job2}"

# Ajout des tags
cuetag "$csf" split-track*.flac

# Renommage des fichiers
 for i in split-track*.flac
  do 
  piste=$(metaflac $i --show-tag=TRACKNUMBER)
  interprete=$(metaflac $i --show-tag=PERFORMER)
  auteur=$(metaflac $i --show-tag=ARTIST)
  album=$(metaflac $i --show-tag=ALBUM)
  titre=$(metaflac $i --show-tag=TITLE)
  nt="${piste#TRACKNUMBER=}_${auteur#ARTIST=}_${interprete#PERFORMER=}_${album#ALBUM=}_${titre#TITLE=}.flac"
  np=`echo ${nt} | tr -d -c [:alnum:]" ._-"`
  mv $i $np
 done

# Fin
if [ "$?" = -1 ]; then
 zenity --error --title="${msg_titre}" --text="${msg_erreur4}"
else
 zenity --info --title="${msg_titre}" --text="${msg_info}"
fi

# EOF
