#!/bin/sh
##
## Nautilus
## SCRIPT: color00_one_THRESHOLD2WhiteBlackFile_jpgORpngORgifFile.sh
##
## PURPOSE: Makes a black-and-white file from a selected image file
##          ('.jpg' or '.png' or '.gif').
##          Prompts the user for a threshold level (%) to determine
##          what range of gray-shades to turn black.
##               (0  = all colors to white except black;
##                99 = all colors but the whitest to black)
##               Uses ImageMagick 'convert'.
##          Shows the new image file in an image viewer.
##
## Reference:  http://www.imagemagick.org/Usage/quantize/#threshold
##
## Created: 2010apr01
## Changed: 

## FOR TESTING:
# set -v
# set -x

########################################
## Get the filename of the selected file.
########################################

   FILENAME="$1"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


####################################################################
## Get and check that the file extension is 'jpg' or 'png' or 'gif'.
##     Assumes one period (.) in filename, at the extension.
####################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
then
   exit
fi


#######################################################
## Get the 'stub' to use to name the new output file.
#######################################################
  FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||'`
  FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.png$||'`
  FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.gif$||'`

############################################################
## Get the threshold level (%) to use ---
##   -1 turns every color white
##    0 turns every color white, except black
##   50 turns lighter colors white, darker colors black
##  100 turns every color black.
##   http://www.imagemagick.org/Usage/quantize/#threshold
############################################################
    THRESHOLD="50"
    THRESHOLD=$(zenity --entry --text "Enter a threshold :
    0 for all colors white, except black ;
   50 for light colors to white, dark colors to black ;
  100 for all colors to black." \
                --entry-text "50")

#############################################
## Use 'convert' to make the new output file.
#############################################
   FILEOUT="${FILENAMECROP}_threshold${THRESHOLD}.$FILEEXT"
   convert "$FILENAME" -threshold ${THRESHOLD}%  "$FILEOUT"


#############################
## Show the new image file.
#############################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$IMGEDITOR "$FILEOUT" &

