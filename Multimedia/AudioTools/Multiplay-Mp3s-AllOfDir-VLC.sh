#!/bin/sh
##
## Nautilus
## SCRIPT: 97v_multiplay_mp3s_allOfDir_inVLC.sh
##
## PURPOSE: Plays the mp3 files in the current directory, after
##          getting the filenames with 'ls' and 'grep'.
##          Plays the files with 'vlc'.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             right-click on any file in the directory, then
##             choose this Nautilus script to run. 
##
## NOTE: This implementation calls 'vlc' once for each file,
##       because I am concerned about passing all the filenames
##       on the VLC command line. There is a limit of around 2KB
##       (maybe much more nowadays) on the length of a command line.
##         It would be nice to use a 'playlist'
##         file to feed the filenames to ONE call of
##         'vlc', but after much web searching, I have
##         not found an example of doing that.
##
## Created: 2010mar11
## Changed: 2010apr11 Touched up the comment statements.

## FOR TESTING:
# set -v

#############################################
## Get the filenames in the current directory.
##
## Might need to use a NAUTILUS_SCRIPT var if
## blanks in filenames cause a problem.
#############################################

   FILENAMES=`ls`
#  FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


#########################################
## START THE LOOP on the filenames.
##
## Could use a Linux utility like 'shuf' to
## randomize the filenames. Could use zenity
## to prompt whether to shuffle.
#########################################

for FILENAME in "$FILENAMES"
do

  ##################################################
  ## Get and check that file extension is 'mp3'. 
  ## THIS ASSUMES one '.' in filename, at the extension.
  ##################################################

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "mp3" 
  then
     continue
     # exit
  fi

  ####################################
  ## Play the file with 'vlc'.
  ## Try to suppress Internet queries.
  ####################################

  /usr/bin/vlc --no-http-album-art --album-art 0 \
               --qt-start-minimized "$FILENAME"

  ## Some OTHER vlc options that might be useful:
  ## --one-instance
  ## --play-and-exit

done


