#!/bin/sh
##
## Nautilus
## SCRIPT: 98m_multiplay_mp3s_selectedShuffled_inMplayer.sh
##
## PURPOSE: Plays SELECTED mp3 files in the current directory.
##          Plays the files with 'gmplayer'. Uses a zenity prompt
##          to determine whether to 'shuffle' the files.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             select the files to play (can use the Ctl key with or
##             without the Shift key),
##             right-click on the selected files in the directory,
##             then choose this Nautilus script to run.
##
## Created: 2010mar11
## Changed: 2010apr11 Touched up the comment statements.
##

## FOR TESTING:
# set -v

#######################################
## Prepare a playlist file for gmplayer.
#######################################

  TEMPFILE="/tmp/mplayer.pls"
  rm -f "$TEMPFILE"

####################################
## We use 'echo' and 'grep' to filter out
## the non-mp3 files selected and put the
## filtered names into the playlist file.
##
## NOTE: These filenames are fully
## qualified with 'file://' prefixed
## to each full filename.
####################################

  echo "$NAUTILUS_SCRIPT_SELECTED_URIS" | grep '\.mp3$' > "$TEMPFILE"


#############################################
## A zenity OK/Cancel prompt for 'Shuffle?'.
#############################################

  zenity  --question --title "Shuffle?" \
          --text  "Shuffle (randomize) the songs?
                   Cancel = No."

  if test $? = 0
  then
     ANS="Yes"
  else
     ANS="No"
  fi

## An ALTERNATE zenity prompt (radiolist for Yes/No to 'Shuffle?').
##
#  ANS=$(zenity --list --radiolist \
#               --title "Shuffle?" --text "Shuffle (randomize) the songs?" \
#               --column "Cancel" --column "= Yes" \
#              TRUE Yes FALSE No)
#
#  if test "$ANS" = ""
#  then
#     ANS="Yes"
#  fi


#############################################
## Play the playlist, with 'gmplayer'.
#############################################

  if test "$ANS" = "Yes"
  then
     /usr/bin/gmplayer -shuffle -playlist "$TEMPFILE"
  else
     /usr/bin/gmplayer -playlist "$TEMPFILE"
  fi

exit 
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#################################################
## BELOW IS A FIRST VERSION :
##     mplayer invoked once for each music file.
##
## But it is difficult to break in and cancel
## the loop. Was using a 'kill' command or
## Gnome System Monitor.
#################################################

   FILENAMES_GET="$@"
#  FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

###########################################
## Shuffle the filenames.
##
## NOTE:
## 'sed' is used to change a 'space' separator between
## the filenames into line-feeds --- because 'shuf' wants
## separate lines to shuffle, not words in a string.
##     This assumes no embedded blanks in the filenames.
##
## NOTE: Could try the '-shuffle' option of mplayer, below.
#########################################

   FILENAMES=`echo "$FILENAMES_GET" | sed 's| |\n|g' | shuf`

###########################################
## START THE LOOP on the filenames.
###########################################

for FILENAME in "$FILENAMES"
do

  #######################################
  ## Get and check that file extension is 'mp3'. 
  ## Assumes one '.' in filename, at the extension.
  #######################################

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "mp3" 
  then
     continue
     # exit
  fi

  #######################################
  ## Play the file.
  #######################################

  /usr/bin/mplayer "$FILENAME"
# /usr/bin/mplayer -shuffle "$FILENAME"

done


