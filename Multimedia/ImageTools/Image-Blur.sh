#!/bin/sh
##
## NAUTILUS
## SCRIPT: blur00_1file.sh
##
## PURPOSE: Makes a blurred file from a selected image file.
##          Prompts the user for a few typical ImageMagick 'convert'
##          blur parameters ( 'radius' and 'sigma' issued in the form
##          -blur  {radius}x{sigma}  ).
##               Examples: 0x1 OR 1x1 OR 1x2 OR 1x0.3
##                         to remove 'jaggies'.
##
##               Uses ImageMagick 'convert'.
##          Shows the new image file in an image viewer.
##
## Reference:  http://www.imagemagick.org/Usage/blur/#blur
##
## HOW TO USE: Click on the name of any file (or directory) in a Nautilus
##             directory list.
##             Then right-click and choose this script to run (name above).
##
## Created: 2010jun01
## Changed:

## FOR TESTING:
#  set -v
#  set -x

########################################
## Get the filename of the selected file.
########################################

   FILENAME="$1"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


####################################################################
## Get and check that the file extension is 'jpg' or 'png' or 'gif'.
##     Assumes one period (.) in filename, at the extension.
## COMMENTED, for now.
####################################################################
# FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
# if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
# then
#    exit
# fi


#######################################################
## Prompt for the blur parameter.
#######################################################
##     - 0x1
##     - 1x1
##     - 1x2
##     - 1x4
##     - 1x0.3
#######################################################

 BLURPARM=""
 BLURPARM=`zenity --list --radiolist \
         --title "Blur parameter?" \
         --text "Choose a blur parameter for ImageMagick 'convert'." \
         --column "" --column "{radius}x{sigma}" \
           TRUE  0x1 \
           FALSE 1x1 \
           FALSE 1x4 \
           FALSE 2x2 \
           FALSE 2x1`

 if test "$BLURPARM" = ""
 then
    exit
 fi


######################################################
## Get the 'stub' and suffix to use to name the
## new output file.
##     Assumes just one period (.) in the filename,
##     at the suffix.
######################################################
  FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`
  FILESUFFIX=`echo "$FILENAME" | cut -d'.' -f2`


###########################################
## Use 'convert' to make the new image file.
###########################################

   FILEOUT="${FILEMIDNAME}_blurred.$FILESUFFIX"

   ## FOR TESTING:
      set -x

   convert "$FILENAME"  -channel RGBA -blur $BLURPARM  "$FILEOUT"

   ## FOR TESTING:
      set -

##########################
## Show the new image file.
##########################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$IMGEDITOR "$FILEOUT" &

