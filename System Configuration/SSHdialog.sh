#!/bin/bash
### Copyright (c) 2010 Remy van Elst
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

VERSION="1.2 beta."
TITLE="SSHdialog $VERSION"
HOSTSFILE="~/hosts"
if [ -e $HOSTSFILE ]; then
	awk 'NF > 0' $HOSTSFILE > /tmp/sshost.hosts && cat /tmp/sshost.hosts > $HOSTSFILE
else
	echo "Host file does not exist, please create it"
	echo "Use the following format:"
	echo; echo "number,servername,user,url/ip,port"
	echo "Example:"
	echo "1,VPS1,-,vps1.example.com,2223"
	echo "2,VPS2,john,vps2.example.org,2222"
	echo "3,Company Webserver,www,10.0.0.210,22"
	echo "4,Router,root,192.168.1.1,22"
	echo; echo "If you want the current user to be used as the username then use a - (dash)."
	echo "Each value is seperated by a , (comma), and make sure you don't have double numbers. If you have only the first number will work."
	echo "If the syntax is not correct the script will fail so please make sure there are no errors..."
	echo
	exit 1
fi
WIDTH=50
HEIGHT=40
MENUSIZE=6
TEMPF=`TEMPF 2>/dev/null` || TEMPF=/tmp/sshost.$$
OLDIFS=$IFS
WHICHSSH="`whoami`@${HOSTN[$SSHOST]}"
DIALOG=${DIALOG=dialog}
IFS=$'\n'
ALINES=($(awk 'BEGIN{FS=","} {print $1}' $HOSTSFILE | wc -l))
LINES=($(awk 'BEGIN{FS=","} {print $1, "\"" $2 "\""}' $HOSTSFILE))
NAMES=($(awk 'BEGIN{FS=","} {print $2}' $HOSTSFILE))
UNAME=($(awk 'BEGIN{FS=","} {print $3}' $HOSTSFILE))
HOSTN=($(awk 'BEGIN{FS=","} {print $4}' $HOSTSFILE))
HOSTP=($(awk 'BEGIN{FS=","} {print $5}' $HOSTSFILE))

# if [ $ALINES -gt 6 ]; then MENUSIZE=$ALINES; else MENUSIZE=6; fi
MENUSIZE=$ALINES
SMURF="$DIALOG --extra-button --extra-label \"Edit Hosts\" --cancel-label \"Exit\" --ok-label \"Connect\" --menu \"$TITLE\" $HEIGHT $WIDTH $MENUSIZE ${LINES[*]}"
eval $SMURF 2> $TEMPF
RHOST=$?
KEUZE=`cat $TEMPF`
SSHOST=$[$KEUZE - 1]

	if [ ${UNAME[$SSHOST]} == "-" ]; then
		UNAME2=`whoami`
		WHICHSSH="$UNAME2@${HOSTN[$SSHOST]}"
	else
		UNAME2=${UNAME[$SSHOST]}
		WHICHSSH="$UNAME2@${HOSTN[$SSHOST]}"
	fi

clear

case $RHOST in
  0)
	echo "Connecting user $UNAME2 to ${HOSTN[$SSHOST]} on port ${HOSTP[$SSHOST]}."
	ssh  $WHICHSSH -p ${HOSTP[$SSHOST]}
	echo "ssh terminated, byebye"
	echo "This script is made by Raymii from http://raymii.org"
	;;
  1)
	echo "You selected exit, we will quit"
	exit 0
	;;
  3)
	nano $HOSTSFILE
	exec bash $0
	exit 0
	;;
  255)
	echo "You pressed ESC, we will exit.";
	exit 0
	;;
esac

rm -f $TEMPF
exit 0
