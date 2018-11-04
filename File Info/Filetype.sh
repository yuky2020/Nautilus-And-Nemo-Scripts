#!/bin/sh
# Copyright (C) Sept 13, 2001 Shane Mueller <smueller@umich.edu>
# http://www-personal.umich.edu/~smueller/Nautilus-Scripts
#
#
for arg
do
 
filetype=$(file "$arg")

  gdialog --title "File-Type Determinator" --msgbox "File $filetype" 200 200

done