#!/bin/bash

#Search file in selected dir of nautilus.
##########################################################################
#                        Nautilus "Search" Script                 #
##########################################################################
#                                                                        #
# Created by Xinyu Du                                                    #
# Emails: glacier_05@yahoo.com.cn                                        #
##########################################################################
if [ "$1" = "" ];then
	wdir=${NEMO_SCRIPT_CURRENT_URI#file://}
	wdir=${wdir//%20/ }
else
	filetype=$(file "$1")
	filetype=${filetype##*: }

	if [ "$filetype" = "directory" ];then
		wdir=${NEMO_SCRIPT_SELECTED_FILE_PATHS%%$1*}
		wdir=$wdir/$1
	else
		wdir=${NEMO_SCRIPT_SELECTED_FILE_PATHS%%$1*}
	fi
fi
gnome-search-tool --path="$wdir"


