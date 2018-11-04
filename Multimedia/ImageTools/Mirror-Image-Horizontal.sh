#!/bin/sh
##
## Nautilus
## SCRIPT: tile01a_one_mirrorHoriz_jpgORpngORgif.sh
##
## PURPOSE: Makes a larger image file from a selected image file
##          ('.jpg' or '.png' or '.gif') by adding a mirror-image
##          of the file --- in an east-west direction.
##             Shows the new image file in an image viewer.
##          Uses ImageMagick 'convert', with '+clone', '-flop', and
##          '+append'.

## Created: 2010mar13
## Changed: 

## FOR TESTING:
# set -v
# set -x

#########################################
## Get the filename of the selected file.
#########################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"
  FILENAME="$1"


###################################################################
## Check that the selected file is a 'jpg' or 'png' or 'gif' file.
###################################################################

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
  if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
  then
     exit
  fi


#######################################################################
## Use 'convert' (with +clone and -flop) to make the new mirrored file.
#######################################################################

   FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||'`
   FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.png$||'`
   FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.gif$||'`

   FILEOUT="${FILENAMECROP}_mirrorHoriz.$FILEEXT"
   convert "$FILENAME" \( +clone -flop \) +append -gravity east \
           "$FILEOUT"


####################################
## Show the new mirrored image file.
####################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$IMGEDITOR "$FILEOUT" &

