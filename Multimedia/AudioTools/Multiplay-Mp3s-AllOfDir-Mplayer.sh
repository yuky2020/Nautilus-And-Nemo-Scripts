#!/bin/sh
##
## Nautilus
## SCRIPT: 97m_multiplay_mp3s_allOfDir_inMplayer.sh
##
## PURPOSE: Plays the mp3 files in the current directory, after
##          getting the filenames with 'ls' and 'grep'.
##          Plays the files with 'gmplayer'.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             right-click on any file in the directory, then
##             choose this Nautilus script to run.
##
## Created: 2010mar11
## Changed: 2010apr11 Touched up the comment statements.

## FOR TESTING:
# set -v

#########################################################
## Prepare a 'play list' file to hold the audio filenames.
#########################################################

  TEMPFILE="/tmp/mplayer.pls"
  rm -f $TEMPFILE

#########################################################
## Generate the 'play list' file, with 'ls' and 'grep'.
##
## NOTE: mplayer seems to need the string 'file://'
##       prefixed on fully-qualified filenames.
#########################################################

  ls  | grep '\.mp3$' | eval "sed 's|^|file://$CURDIR|' > $TEMPFILE"
  /usr/bin/gmplayer -loop 0 -playlist $TEMPFILE

  ## We could add a zenity prompt to 'shuffle' the files.
  # /usr/bin/gmplayer -loop 0 -shuffle -playlist $TEMPFILE

exit
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#############################################
## BELOW IS A FIRST VERSION :
##   mplayer invoked once for each music file.
##
## But it is difficult to break in and cancel
## the loop. Was using a 'kill' command or
## Gnome System Monitor.
#############################################

   FILENAMES=`ls`
#  FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

###################################
## START THE LOOP on the filenames.
###################################

for FILENAME in $FILENAMES
do

  #################################################
  ## Get and check that file extension is 'mp3'. 
  ## THIS ASSUMES one '.' in filename, at the extension.
  #################################################

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "mp3" 
  then
     continue
     # exit
  fi

  #############################
  ## Play the file.
  #############################

  /usr/bin/mplayer "$FILENAME"

done


