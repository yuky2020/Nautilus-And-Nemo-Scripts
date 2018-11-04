#!/bin/sh
#
# athabaskan.sh - gui based manager for Apache
#



action=$(zenity --list --height=280 --text "Select Action" \
    --radiolist \
    --column "Pick" \
    --column "Action" \
    TRUE "Apache2" \
    FALSE "ProftpD" \
    FALSE "SSH" \
    FALSE "Mysql" \
    FALSE "Winbind" \
    FALSE "monitorix" \
    FALSE "Webmin" \
    FALSE "Smbd" );
#
# Check to see if the user has hit Cancel - if so $action will
# be null    
#
if [ -z "$action" ]; then
    exit 0
fi
# convert action to lowercase for insertion into the command we'll eventually
# execute
action=`echo $action |tr '[A-Z]' '[a-z]'`
#
# Now build the command string
#
command=" service $action start"

# 
# setup a temp file to hold the command output
#
TFILE="$$.tmp"
#
# Now prompt for the sudo password
#

     $command >$TFILE

   
#
# Get the command output for populating the dialog box
# if it's null and the status was asked for, it's cos Apache isn't running
#
msg=`cat $TFILE`
if [ -z "$msg" ] && [ "$action" = "status" ]; then
    msg="Server is not running."
fi
zenity --info --text "$msg"
# cleanup the temp file
rm $TFILE
exit 0
