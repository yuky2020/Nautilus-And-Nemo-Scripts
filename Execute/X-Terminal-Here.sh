#!/bin/sh
##
## Nautilus
## SCRIPT: 00_xTerminal_here.sh
##
## PURPOSE: This script opens an xterm with the command prompt 'positioned'
##          in the directory you select.
##
## HOW TO USE: Right-click on any file (or directory) in a Nautilus
##             directory list.
##             Under 'Scripts', choose to this script to run (name above).
##
## Created: 2010apr03
## Changed: 2010may19 Added a title to the terminal to show the curdir.

cd $NAUTILUS_SCRIPT_CURRENT_URI

# exec xterm -fg white -bg black

CURDIR=`pwd`
CURDIR=`basename "$CURDIR"`
exec xterm -fg white -bg black -title "$CURDIR"


