#!/bin/bash
#11/13/2010
#this script allows you to scp a file to a static list of remote hosts
#NOTE: you must have ssh key based authorization previously setup and have created a file that lists the hosts ip or fqdn separated by newlines
#such as a file called ~/.scp_hosts with the following text inside:
#192.168.0.2
#192.168.0.53
#10.0.1.80


#scp_to -- nautilus script that scp's files to a fixed list of hosts in a file
#created by Brad Smith (brad.smith@gmail.com)
#NEED: zenity, ssh key based auth, host file

#CONSTANTS
HOSTS='/home/bradleyd/.scp_hosts'
FILEPATH=`echo $NAUTILUS_SCRIPT_SELECTED_URIS | sed 's@file://@@g'`
SCP='/usr/bin/scp'
SSH_ID="$HOME/.ssh/id_rsa.pub" #make sure you are using ssh keys or this is a waste of time
ZENITY='/usr/bin/zenity '
#ZENITY_PROGRESS_OPTIONS='--auto-close --auto-kill' #you can remove this if you like

#sanity checks
for sanity_check in $HOSTS $ZENITY $SSH_ID $SCP $FILEPATH

do
     ZENITY_ERROR_SANITY="There is an error, it involved $sanity_check.\n Probably binary or file missing"
     if [ ! -e $sanity_check ]
       then
#         zenity --error --text="$(eval "echo \"$ZENITY_ERROR_SANITY\"")"
         zenity --error --text="$ZENITY_ERROR_SANITY"
         exit
     fi
done


#check whether copying file or directory
if [ -d "$FILEPATH" ]; then
	SCP="$SCP -r "
fi

#pick host to copy to
RESULT=`cat $HOSTS | zenity --list --title "SCP HOSTS" --text "Pick a host to scp to.." --column "HOSTS"`
#TODO needs a better check if user clicked cancel on list--dont want any artifacts left over for failed scp command
if [ $? -ne 0 ]
then
  exit
fi

#PASSEd ALL CHECKS; heavy lifting
$SCP $FILEPATH $RESULT: | $($ZENITY --progress --text="copying $(basename $FILEPATH)" --pulsate $ZENITY_PROGRESS_OPTIONS)
if [ $? -eq 0 ]
then
  zenity --info --text="SCP Succeeded!"
else
  zenity --error --text="SCP failed to $RESULT"
  exit
fi
