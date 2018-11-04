#!/bin/sh
##
## Nautilus
## SCRIPT: 04_multiDownsize_4jpgFiles_YPIXhigh_2newDIR.sh
##
## PURPOSE: Changes the size of a set of selected '.jpg' files.
##          Prompts the user for a Y-size(pixels) to use for all
##          the files.
##             Puts the new files in a new directory,
##             named "photos_${YSIZE}y", in the current directory.
##             (The user can change this directory name or move the files
##              later.)
##          Uses ImageMagick 'convert' to do the resizing.
##
## NOTE: You could up-size files with this script, but that
##       usually results in loss of quality.
##
##       This script is oriented toward taking a batch of 'oversized'
##       '.jpg' files, like files from a digital camera, in a directory
##       where you want to keep the original files, and making a common,
##       smaller Y-size file from each original --- with the new, smaller
##       files being put into a (new) 'photos_YPIXELSy' subdirectory.
##
## Created: 2010feb17
## Changed: 2010apr01  Added zenity prompt for Y-height.

## FOR TESTING:
# set -v
# set -x

##
## Get the filenames of the selected files.
##

   FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


##
## Get the Y-height for the new sized image files. 
##

    YSIZE="600"
    YSIZE=$(zenity --entry --text "Enter the Y-pixel-size for the output image(s) :
        Typically about 450 to 650 pixels to fit in a browser/reader window." \
        --entry-text "600")


##
## Make the 'photos_${YSIZE}y' directory, if needed, in curdir.
## Move/rename the dir later, if needed.
##

DIR4resizedPHOTOS="photos_${YSIZE}y"

if test ! -d "$DIR4resizedPHOTOS"
then
     mkdir "$DIR4resizedPHOTOS"
fi


##
## START THE LOOP on the filenames.
##

for FILENAME in $FILENAMES
do

   ##
   ## Check that the file is a 'jpg' file.
   ##

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "jpg" 
   then 
      continue
      # exit
   fi


   ##
   ## Use 'convert' with '-resize' to make the resized jpg file.
   ##

   # FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||'`
   
   ## Strip off suffix of the form '_MMM...xNNN..._yadayada.jpg'
     FILENAMECROP=`echo "$FILENAME" | sed 's|_[0-9][0-9]*x[0-9][0-9]*.*\.jpg$||'`
   
   convert "$FILENAME" -resize x$YSIZE -quality 100 \
           "./$DIR4resizedPHOTOS/${FILENAMECROP}_XXXx${YSIZE}.jpg"

   ## Can then use the script 05_multiRename_jpgFiles_MMMxNNNtoXXXxYYY.sh
   ## to rename the resized photos with the XXX size filled in.

done




