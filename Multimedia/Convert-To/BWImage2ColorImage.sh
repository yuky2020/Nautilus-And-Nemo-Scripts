#!/bin/sh
##
## Nautilus
## SCRIPT: color01_one_applyCOLOR2BlacksGrays_jpgORpngORgifFile.sh
##
## PURPOSE: Converts blacks and grays of an image file ('.jpg' or
##          '.png' or '.gif') to shades of the specified color.
##          Prompts the user for the color.
##              Uses the ImageMagick 'convert' program.
##          Shows the new image file in an image viewer.
##
## Reference:  http://www.imagemagick.org/Usage/color/#level-colors
##
## Created: 2010apr01
## Changed: 

## FOR TESTING:
# set -v
# set -x

##
## Get the filename of the selected file.
##

   FILENAME="$1"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


##
## Get and check that the file extension is 'jpg' or 'png' or 'gif'.
##     Assumes one period (.) in filename, at the extension.

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
then
   exit
fi


##
## Get the 'stub' to use to name the new output file.
##
  FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||'`
  FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.png$||'`
  FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.gif$||'`

##
## Get the color to use for converting blacks and grays to
## shades of the specified color.
## Reference:  http://www.imagemagick.org/Usage/color/#level-colors

   LEVELCOLOR="blue"
   LEVELCOLOR=$(zenity --entry --text "Enter a 'level color' :
   If you specify blue,
    blacks go to blue ;
    grays  go to light blue ;
    whites stay white" \
                --entry-text "blue")

##
## Use 'convert' to make the new output file.
##
   FILEOUT="${FILENAMECROP}_$LEVELCOLOR.$FILEEXT"
   convert "$FILENAME" +level-colors $LEVELCOLOR,white \
        "$FILEOUT"

###########################
## Show the new image file.
###########################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$IMGEDITOR "$FILEOUT" &

