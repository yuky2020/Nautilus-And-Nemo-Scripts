#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multiCrop_jpgORpngORgifFiles_inputGEOM.sh
##
## PURPOSE: Crops a selected set of image files ('.gif' or '.jpg' or
##          '.png') according to a 'geometry' specification.
##                  Example: 200x100+0+50
##          Prompts the user for that geometry specification.
##          Shows each file as it is cropped.
##           
##
## Created: 2010apr01
## Changed: 

## FOR TESTING:
# set -v
# set -x

###########################################
## Get the filenames of the selected files.
###########################################

   FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


###########################################################
## Get the geometry to use for the crop of ALL the files. 
## Example: 200x100+0+50
###########################################################

    GEOMETRY="200x100+0+50"
    GEOMETRY=$(zenity --entry \
        --title "Enter GEOMETRY." \
        --text "Enter geometry for the crop :
        Example: 200x100+0+50 for ALL the selected files." \
        --entry-text "200x100+0+50")


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME in $FILENAMES
do

   ###################################################################
   ## Get and check that the file extension is 'jpg' or 'png' or 'gif'.
   ##    Assumes one period (.) in filename, at the extension.
   ###################################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
   if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   then
      exit
   fi


   ######################################################
   ## Get the 'stub' to use to name the new output file.
   ######################################################

   FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||'`
   FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.png$||'`
   FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.gif$||'`


   #######################################
   ## Use convert to do the cropping.
   #######################################

   FILEOUT="${FILENAMECROP}_cropped.$FILEEXT"
   convert "$FILENAME" -crop $GEOMETRY +repage  "$FILEOUT"


   #########################################################
   ## Show the cropped file.
   ## Close the viewer program to continue to the next file.
   #########################################################

   . $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

   $IMGEDITOR "$FILEOUT"

done



