#!/bin/sh
##
## Nautilus
## SCRIPT: 06_multiRenameORdelete_jpgORpngORgifFiles.sh
##
## PURPOSE: Takes a list of selected image files and loops thru the list
##          and for each file
##             1) shows the image file with $IMGVIEWER
##             2) puts up a zenity entry-field prompt to offer to rename the file
##             3) puts up a zenity question prompt whether to delete the file
##     NOTES:
##          Of course, you can change $IMGVIEWER to use another image program
##          that brings up an image quickly, like mtpaint --- or use
##          $IMGEDITOR.
##
##          Then you could crop the file (or do some other edit), save it ---
##          then rename or delete the file.
##             (Ordinarily, you would rename it rather than
##              delete it, if you just went to the trouble to edit it.)
##
##          The delete is done with the 'rm' command, rather than moving
##          the file to Trash.
##
##          The rename is done with the 'mv' command. It simply renames it
##          in the current directory. You can move the file to an appropriate
##          directory after renaming.
##
##
## Created: 2010aug24
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


###################################
## START THE LOOP on the filenames.
###################################

for FILENAME in $FILENAMES
do

  ###########################################################
  ## Check that the file is a 'jpg' or 'png' or 'gif' file.
  ###########################################################

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
  then
     continue
     # exit
  fi

  ###################################################
  ## Show the file with eog (or mtpaint) or whatever.
  ###################################################

   . $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

   # $IMGEDITOR "$FILENAME" &
     $IMGVIEWER "$FILENAME" &


  ###################
  ## RENAME option. 
  ###################

    NEWNAME=""
    NEWNAME=$(zenity --entry --title "RENAME file ??" \
            --text "Enter a NEW name for the file, OR close the window or Cancel." \
            --entry-text "$FILENAME")

    if test ! "$NEWNAME" = ""
    then
       mv "$FILENAME" "$NEWNAME"
       FILENAME="$NEWNAME"
    fi


   #############################################
   ## DELETE option.
   #############################################

    zenity --question --title "DELETE file ??" \
           --text "Delete '$FILENAME' ?
                   Cancel = No."

    if test $? = 0
    then
       rm "$FILENAME"
    fi


  ################
  ## Continue?
  ################

    zenity --question --title "CONTINUE ??" \
           --text "Continue processing image files ?
                   Cancel = Exit = Stop processing."

    if test ! $? = 0
    then
       exit
    fi

done





