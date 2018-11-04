#!/bin/bash
# Shell script utility to sync a .m3u playlist
# Once destinations are read they can be process in processLine() function
# You can call script as follows, to read myfile.m3u:
# ./syncmyfavoritemusic myfile.m3u 'destination'
# -----------------------------------------------
# Copyright (c) 2010 M.Reza SaidAfkan
# This script is licensed under GNU GPL version 2.0 or above
# User Define Function (UDF)
processLine(){
line="$@" # get input from keyboard
cp -ru $line $DEST | echo "\"$line\" done" # copy the separated lines of the .m3u file to the desired destination. Notifies as "done" in the command line if the copying process was successful
}
DEST=$2 # define variables into th User Defined Function
cat $1 | grep -v '#' | sed "s:\b:$HOME:" > "$1.bak" # define variables into th User Defined Function. It is assumed that the media files are located in the user's home directory. You can edit this as your own configuration
# reads a file line line. Visit http://bash.cyberciti.biz/ for more information.
FILE="$1.bak"
BAKIFS=$IFS
IFS=$(echo -en "\n\b")
exec 3<&0
exec 0<"$FILE"
while read -r line
do
# use $line variable to process line in processLine() function
processLine $line
done
exec 0<&3
IFS=$BAKIFS
rm "$1.bak"
exit 0
