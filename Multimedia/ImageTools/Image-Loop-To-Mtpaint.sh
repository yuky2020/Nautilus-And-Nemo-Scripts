#!/bin/sh
##
## Nautilus
## SCRIPT: 02b_multiEdit_imgFiles_mtPaint_forLoop.sh
##
## PURPOSE: Uses a 'for' loop to pass a user-selected set of image filenames,
##          one at a time, to 'mtPaint'. This script starts up 'mtPaint' one
##          time for each filename. The next instance of 'mtPaint' does not
##          start until the previous instance is closed.
##
##              (It is up to the user to select image files that are
##               in formats that mtPaint reads --- such as
##               JPG or PNG or GIF.)
##
##          This script is an alternative to another script
##               02a_multiEdit_imgFiles_mtPaint_oneInstance.sh
##          which passes the selected image filenames (over 100, for example)
##          to mtPaint on a command line, which starts up ONE instance of
##          mtPaint --- for ALL the filenames. With this technique,
##          mtPaint is started WITH a LIST of the filenames on the RIGHT
##          of the mtPaint window. Unfortunately, with that method, mtPaint
##          behaves in a confusing fashion in relation to mouse 'focus'
##          between 
##                  - the editing window 
##                  - the scrollbar of the editing window, and
##                  - the filename window of mtPaint.
##          Certain mouse clicks cause unintentional switches to the 'next'
##          image file in the list. That is, the 'next' image file becomes
##          the file displayed in the editing window. The user has to be
##          careful to click in the edit window after clicking in the
##          filename window, to restore 'focus' to the editing window.
##
## NOTE: A THIRD alternative:
##       It would be nice to be able to select a bunch (over 100, say) of
##       image files in a directory, in Nautilus, and then simply right-click
##       and choose to Open mtPaint --- BUT this SIMULTANEOUSLY starts an
##       instance of mtPaint for each image file selected, consuming a huge
##       amount of memory (and starts a ridiculous number of windows).
##             This script avoids that problem.
##       However, the right-click-and-choose-mtPaint method IS workable,
##       if one selects no more than about 10 image files at a time.       
##
## Created: 2010may19
## Changed:

##
## Get the filenames of the selected files.
##

#  FILENAMES="$*"
   FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


##
## Call mtPaint for each filename --- in a 'for' loop.
##

## FOR TESTING:
# set -v
# set -x

for FILENAME in $FILENAMES
do
  mtpaint $FILENAME
done

## FOR TESTING:
# set -

exit

##
## The following code uses a while-read loop, instead of a for loop.
##

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# echo "$FILENAMES" | \
# while read FILE
# do
#   mtpaint $FILE
# done




