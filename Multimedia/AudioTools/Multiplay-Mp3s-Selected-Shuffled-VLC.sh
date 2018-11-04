#!/bin/sh
##
## Nautilus
## SCRIPT: 98v_multiplay_mp3s_selectedShuffled_inVLC.sh
##
## PURPOSE: Plays SELECTED mp3 files in the current directory.
##          Plays the files with 'vlc'. Uses a zenity prompt
##          to determine whether to 'shuffle' the files.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             select the files to play (can use Ctl key with or
##             without the Shift key),
##             right-click on the selected files in the directory,
##             then choose this Nautilus script to run.
##
## Started: 2010mar11
## Changed: 2010apr11 Touched up the comment statements.
##

## FOR TESTING:
# set -v

#######################################
## Get the selected filenames.
##
## NOTE: If there is a problem with too many
## filenames (characters) on the vlc command line,
## may have to try to create a 'playlist' file to
## feed the filenames to 'vlc'. But documentation
## on whether this is possible was not found by me.
#######################################

#  FILENAMES_GET="$@"
#  FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_URIS"
   FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

## FOR TESTING:
#   echo "$FILENAMES_GET" |  zenity  --list  \
#        --title "Nautilus Script - Files" \
#        --text  "Nautilus Script - Files Selected" \
#        --column "Files"


#######################################
## Make a 'playlist' input file for VLC.
## COMMENTED, for now.
#######################################
#  TEMPFILE="/tmp/vlc.pls"
#  rm -f "$TEMPFILE"

#  ## We use 'grep' to filter out the non-mp3 files selected.
#  echo "$NAUTILUS_SCRIPT_SELECTED_URIS" | grep '\.mp3$' > "$TEMPFILE"


## FOR TESTING:
#   cat "$TEMPFILE" |  zenity  --list  \
#        --title  "$TEMPFILE" \
#        --text "$TEMPFILE" \
#        --column "Files"


############################################
## A zenity OK/Cancel prompt for 'Shuffle?'.
############################################

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

###################################################################
## Make a sequence of input filenames for VLC.
## NOTE: There is a limit of about 2K bytes or so on a command line.
##
## It would be better to find a way to put the filenames in a playlist
## file in a format that VLC would accept.
## Mplayer seems simpler (and better documented) in this regard.
##
## We could use 'shuf', if necessary, to shuffle the files
## in a playlist file.
##
##     NOTE: The '--random' option of vlc, below ---
##           seems to work. Probably don't need to use 'shuf'.
##
## NOTE: If the filenames came from $@  and we use 'shuf',
##  'sed' can be used to change a 'space' separator between
##  the filenames into line-feeds --- because 'shuf' wants
##  separate lines to shuffle, not words in a string.
##  ** This assumes no embedded blanks in the filenames. **
##
## NOTE: If the filenames came from $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS,     
##  'sed' can be used, after using 'shuf' to shuffle the filenames,
##  to change a line-feed on the end of each line to a 'space' separator
##  between the filenames --- in order to feed the filenames to 'vlc'
##  on the command line.  [This seems to be necessary because
##  I have not found a way to pass a suitable playlist file to vlc on
##  the command line. There is a '--open' option of 'vlc' but I could
##  not determine if this is meant for use with a playlist file.]
####################################################################

## For filenames from $@:
## We could use 'shuf' if '--random' does not work properly:
##
#   FILENAMES=`echo "$FILENAMES_GET" | sed 's| |\n|g' | shuf | sed 's|\n| |g'`

## For filenames from $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS:
## We remove the line-feeds to pass the names on the 'vlc' command line.
##
   FILENAMES=`echo "$FILENAMES_GET"| sed 's|\n| |g'`


#######################################
## Play the selected files, with vlc --
## with shuffle or without.
#######################################

  if test "$ANS" = "Yes"
  then
     /usr/bin/vlc --random --loop --no-http-album-art --album-art 0 \
                  --one-instance --playlist-enqueue --qt-start-minimized $FILENAMES
     ## Some possible alternatives:
     # cat "$TEMPFILE" | shuf |  /usr/bin/vlc -
     #
     # cat "$TEMPFILE" | shuf |  /usr/bin/vlc --loop \
     #     --no-http-album-art --album-art 0 --qt-start-minimized -
  else
     /usr/bin/vlc --loop --no-http-album-art --album-art 0 \
                  --one-instance --playlist-enqueue --qt-start-minimized $FILENAMES
     ## A possible alternative is to quit after one play-through,
     ## instead of looping indefinitely:
     ## Use '--play-and-exit' instead of '--loop'.
     ##
     ## Some other possible alternatives:
     # cat "$TEMPFILE" |  /usr/bin/vlc -
     #
     # cat "$TEMPFILE" |  /usr/bin/vlc --loop --no-http-album-art --album-art 0 \
     #     --qt-start-minimized -  
  fi

exit
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################

############################################################
## ORIGINAL VERSION --- using a loop through the filenames.
## Initiates VLC over and over, instead of calling VLC once.
##
## NOTE: It is difficult to break in and cancel
## the loop. Was using a 'kill' command or
## Gnome System Monitor.
############################################################

#######################################
## Get the selected filenames.
##
## NOTE: If there is a problem with blanks in
## filenames, we may have to get the filenames
## with a NAUTILUS_SCRIPT var.
#######################################

   FILENAMES_GET="$@"
#  FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

############################################################
## Code to shuffle the filenames, when using $@
## to get the selected filenames.
##
## NOTE:
## 'sed' is used to change a 'space' separator between
## the filenames into line-feeds --- because 'shuf' wants
## separate lines to shuffle, not words in a string.
##     This assumes no embedded blanks in the filenames.
##
## NOTE: Could try the '--random' option of vlc, below ---
##       if we find out how to submit an arbitrarily long
##       playlist --- say, in a playlist file.
############################################################

#   FILENAMES=`echo "$FILENAMES_GET" | sed 's| |\n|g' | shuf`
## No file shuffling, for now.
## Could add a zenity prompt, above -- for Yes or No.

######################################
## START THE LOOP on the filenames.
######################################

for FILENAME in "$FILENAMES"
do

  ##################################################
  ## Get and check that file extension is 'mp3'. 
  ## Assumes one '.' in filename, at the extension.
  ##################################################

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "mp3" 
  then
     continue
     # exit
  fi

  #########################
  ## Play the file with vlc.
  #########################

  /usr/bin/vlc --no-http-album-art --album-art 0 --play-and-exit \
               --qt-start-minimized "$FILENAME"

done


