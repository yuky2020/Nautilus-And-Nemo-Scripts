#!/bin/sh
##
## Nautilus
## SCRIPT: 02a_multiEdit_imgFiles_mtPaint_oneInstance.sh
##
## PURPOSE: Passes a selected set of image files ('.jpg' or
##          '.png' or '.gif' or whatever mtPaint reads)
##          and starts up mtPaint --- with a list of the filenames
##          on the right of the mtPaint window.
##
## NOTE: It would be nice to be able to select a bunch of image files
##       in a directory, in Nautilus, and then simply right-click
##       and choose to Open mtPaint --- BUT this starts an instance
##       of mtPaint for each image file selected. This script avoids
##       that problem.
##
## Created: 2010apr20
## Changed:

## FOR TESTING:
# set -v
# set -x

##
## Get the filenames of the selected files.
##

   FILENAMES="$*"
#  FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


##
## Call mtPaint with all the filenames passed in the
## command line.
##

mtpaint $FILENAMES





