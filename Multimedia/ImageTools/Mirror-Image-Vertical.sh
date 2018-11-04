#!/bin/sh
##
## Nautilus
## SCRIPT: tile01b_one_mirrorVert_jpgORpngORgif.sh
##
## PURPOSE: Make a larger image file from a selected image file
##          ('.jpg' or '.png' or '.gif') by adding a mirror-image
##          of the file --- in a north-south direction.
##             Uses ImageMagick 'convert', with '+clone', '-flip',
##             and '-append'.
##          Shows the new image file in an image viewer.
##
## Created: 2010mar13
## Changed: 

## FOR TESTING:
# set -v
# set -x

#########################################
## Get the filename of the selected file.
#########################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAME="$@"
  FILENAME="$1"


##################################################################
## Check that the selected file is a 'jpg' or 'png' or 'gif' file.
##################################################################

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
  if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
  then
     exit
  fi


#######################################################################
## Use 'convert' (with +clone and -flip) to make the new mirrored file.
#######################################################################

   FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||'`
   FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.png$||'`
   FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.gif$||'`

   FILEOUT="${FILENAMECROP}_mirrorVert.$FILEEXT"
   convert "$FILENAME" \( +clone -flip \) -append -gravity north \
           "$FILEOUT"

#####################################
## Show the new mirrored image file.
#####################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$IMGEDITOR "$FILEOUT" &

