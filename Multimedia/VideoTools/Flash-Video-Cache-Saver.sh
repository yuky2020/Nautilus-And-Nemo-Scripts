#!/bin/bash

###### flash video cache saver
# Creator: 	marcaemus
# Version:		0.2
# Last Modified:	01 November 2011
# Find cached flash video and copy to user's home directory
# Usage: mozz [filename] (where filename is the name you want to save as)


# Check for given filename
if [ $# -ne 1 ]; then
	echo "Usage: mozz [filename]"
	exit 65
fi
# Make sure we have lsof
if  [ -x /usr/sbin/lsof ]; then
	LSOF=/usr/sbin/lsof
elif [ -x /usr/bin/lsof ]; then
	LSOF=/usr/bin/lsof
elif [ -x /usr/local/bin/lsof ]; then
	LSOF=/usr/local/bin/lsof
else
	echo "lsof was not found... exiting"
	exit 1
fi
# Look for flvs in user's home - if not, create one
if [ ! -d $HOME/flvs ]; then
	echo -e "\033[0;31mCreating " $HOME"/flvs"
	mkdir -v $HOME"/flvs"
fi
# Find a process ID and go there
PROCDIR=$( $LSOF -X | grep Flash | tail -n1 | awk '{ print $2 }' )
# Not found? exit gracefully
if [ "$PROCDIR" == "" ]; then
	echo "No running instance found"
	exit 1
fi
# To warn us if nothing happens
flvflag=0
# Stat through FDs and copy the first
for i in /proc/$PROCDIR/fd/*; do
	j=$( stat $i | head -n1 | grep "tmp/Flash")

	if [ ${#j} -gt 0 ]; then
		k=$( echo $j | awk '{ print $2 }' )
		l=${k#?}
		m=$( cp -v ${l%?} $HOME"/flvs/"$1".flv" )
		echo -e "\033[0;32m$m"
		echo -e "\033[0;34mCurrent filesize: \033[0;35m"$( stat --format=%s $HOME"/flvs/"$1".flv" )
		flvflag=1
		break
	fi
done
# Echo the warning
if [ $flvflag -eq 0 ]; then
	echo "Warning: no video was copied"
fi

