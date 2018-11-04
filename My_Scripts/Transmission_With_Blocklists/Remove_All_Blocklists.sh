#!/bin/bash

# Creator:	Inameiname
# Version:	1.2
# Last modified: 24 October 2011
#
# Automatically removes all Blocklists prior to running Transmission

BLOCKLISTDIR="$HOME/.config/transmission/blocklists"

if [ ! -d $BLOCKLISTDIR ];then
    mkdir -p $BLOCKLISTDIR
else
    /bin/rm -fv -R $BLOCKLISTDIR
    mkdir -p $BLOCKLISTDIR
fi
