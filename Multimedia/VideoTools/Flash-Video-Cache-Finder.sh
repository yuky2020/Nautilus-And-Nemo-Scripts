#!/bin/bash

###### flash video cache finder
# Creator: 	marcaemus
# Version:		1.1
# Last Modified:	31 October 2011
# Find cached video while watching and without needing downloader extensions
# Type moz at a prompt to find the vid.
# Tested with Firefox (Icecat), Chromium, Midori, Uzbl, Konqueror, and Arora

# Make sure we have lsof
if  [ -x /usr/sbin/lsof ]; then
	LSOF=/usr/sbin/lsof
elif [ -x /usr/bin/lsof ]; then
	LSOF=/usr/bin/lsof
elif [ -x /usr/local/bin/lsof ]; then
	LSOF=/usr/local/bin/lsof
else
	echo "lsof was not found... exiting"
	return 1
fi
# Find a process ID and go there
PROCDIR=$( $LSOF -X | grep Flash | tail -n1 | awk '{ print $2 }' )
# Not found? exit gracefully
if [ "$PROCDIR" == "" ]; then
	echo "No running instance found"
	return 1
fi
cd /proc/$PROCDIR/fd
# Stat through the file descriptors looking for video
MQ=$( for i in *; do stat $i | head -n1 | grep "tmp/Flash" | awk '{ print $2 }'; done )
# Another exit point
if [ "$MQ" == "" ]; then
	echo "No video found"
	return 1
fi
#Finally, print them all out
for i in $MQ; do
	j=${i#?}
	echo "Video at "${j%?}
done

