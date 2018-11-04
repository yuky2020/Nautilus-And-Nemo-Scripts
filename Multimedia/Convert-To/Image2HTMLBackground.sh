#!/bin/sh
##
## Nautilus
## SCRIPT: tile03_GEN_tileDemoPage_4imgFile.sh
##
## PURPOSE: For a selected image file, generates an HTML page
##          using the image file as a background 'tile' for the
##          'body' of the HTML page.
##              Shows the HTML page in a web browser.
##
## Created: 2010apr01
## Changed: 2010apr06 Put output HTML file in /tmp if the
##                    current directory is not writeable.
##                    Adjust filename for background statment.
## Changed: 2010apr06 Add escaped-quotes in the url() statement,
##                    to handle files with spaces in the name.

## FOR TESTING:
# set -v
# set -x

#########################################
## Get the filename of the selected file.
#########################################

# FILENAME="$@"
  FILENAME="$1"


###########################################################
## Set the HTML output filename and, in var FILENAME2,
## put the image filename in a format suitable to the
## 'background: url();' statement of the 'body' statment.
##
##     We put the HTML file in the current directory
##     (the same directory as the image file) if the user
##     has write-permission to the directory. If not,
##     we put the HTML file in /tmp and set FILENAME2
##     accordingly.
###########################################################
   CURDIR="`pwd`"
   HTMFILE="tiledemo.htm"
   if test ! -w "$CURDIR"
   then
      HTMFILE="/tmp/$HTMLFILE"
      FILENAME2="$CURDIR/$FILENAME"
   else
      FILENAME2="./$FILENAME"
   fi

   if test -f "$HTMFILE"
   then
      rm -f "$HTMFILE"
   fi

################################################################
## Write out the HTML page with body (background-tile) statement
## putting HTMFILE in the current directory.
################################################################
   echo "
<html>
<head>
<title>
Web Page tiled with $FILENAME
</title>
<style>
body {
background: url(\"$FILENAME2\");
background-repeat: repeat;
background-attachment: scroll;
}
</style>
</head>
<body>
<p align=\"center\">
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
</body>
</html>
" > "$HTMFILE"

######################################################
## Display the HTML page for the selected image file.
######################################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$HTMLVIEWER "$HTMFILE" &

