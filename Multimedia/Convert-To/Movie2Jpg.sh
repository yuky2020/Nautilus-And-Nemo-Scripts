#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multiJPGs_fromMovieFile_ffmpeg.sh
##
## PURPOSE: Extracts '.jpg' files from a selected movie file,
##          at a user-specified time sampling rate.
##          Uses 'ffmpeg'.
##          Prompts for the sampling rate using zenity.
##
## Reference: http://electron.mit.edu/~gsteele/ffmpeg/ (circa 2005) with
##            corrections according to 'man ffmpeg'
##
## Created: 2010apr17
## Changed:

## FOR TESTING:
# set -v
# set -x

#########################################
## Get the filename of the selected file.
#########################################

#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$@"
   FILENAME="$1"

###############################################################
## Check that the file extension seems to indicate
## a movie file ('mpg' or 'flv' or 'wmv' or 'avi' or 'mov' or
## 'ogv' or whatever suffix we might add). Exit if no match.
##
##   (Assumes one dot [.] in the filename, at the extension.)
###############################################################

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "mpg" -a  "$FILEEXT" != "flv" -a \
          "$FILEEXT" != "wmv" -a  "$FILEEXT" != "ogv" -a \
          "$FILEEXT" != "avi" -a  "$FILEEXT" != "mov"
  then
     exit
  fi


######################################################################
## Prompt for the sampling rate at which to extract the '.jpg' images.
##
## Example: 8 for every 8 seconds.
##
##  "hh:mm:ss[.xxx]" syntax is also supported by ffmpeg.
######################################################################
   SAMPLETIMING="0.5"
   SAMPLETIMING=$(zenity --entry \
              --title "SAMPLE RATE for JPG image Extraction." \
              --text "\
Enter SAMPLING RATE, for JPG image Extraction.
     Examples: 1     for sampling an image every 1 second.
               0.5   for sampling an image every 2 seconds (1/2).
               0.1   for sampling an image every 10 seconds (1/10).
               0.05  for sampling an image every 20 seconds (1/20).
               0.025 for sampling an image every 40 seconds (1/40).
               0.01  for sampling an image every 100 seconds (1/100).
               0.005 for sampling an image every 200 seconds (about every 3.3 mins).
               0.001 for sampling an image every 1000 seconds (about every 16 mins)." \
              --entry-text "0.5")

  if test "$SAMPLETIMING" = ""
  then
     exit
  fi

####################################################################
## Get the middle name of the movie file ---
## to make a name for the jpg file.
##
##    (Assumes one dot in the movie filename, at the file extension.)
#####################################################################
FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


##########################################################
## Prepare the filenames for the '.jpg' output file(s).
##########################################################

# FILES2DELETE=`ls ${FILENAMECROP}_*.jpg`
# for FILE in $FILES2DELETE
# do
#   rm "$FILE"
# done


################################################################
## Use 'ffmpeg' to extract the '.jpg' files from the movie file.
################################################################

ffmpeg -i "$FILENAME" -f image2 -r $SAMPLETIMING "${FILENAMECROP}_%03d.jpg"

###########################################################
## Show the first jpg file in an image viewer or editor.
##
##   (Could save the image to a more meaningful filename by
##    using the 'Save as ...' option of the editor.)
###########################################################

  FILEOUT1="${FILENAMECROP}_001.jpg"

  if test ! -f "$FILEOUT1"
  then
     exit
  fi

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$IMGVIEWER  "$FILEOUT1"


