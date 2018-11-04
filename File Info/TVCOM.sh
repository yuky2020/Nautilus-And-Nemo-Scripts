#!/bin/bash

# defines
TV_URI='http://www.tv.com/search.php?type=11&stype=all&tag=search%3Bfrontdoor&qs=TV&stype=program'
TV_BROWSER='firefox'
TV_SEPCHAR='+'

# Open TV_BROWSER with TV_URI
##########################################################################
#                     Nautilus "TV.Com" Script                           #
##########################################################################
#                                                                        #
# Created by Michal Horejsek.com (pxjava), but modified for TV.Com by me #
# Email: horejsekmichal@gmail.com                                        #
# Version: 1.1 / 26.7.2009 15:20:54                                      #
#                                                                        #
##########################################################################

TV=${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS} # get selected file paths

TV=${TV##*/} # remove path (/home/user/../)
TV=${TV%.*} # remove type (.avi, .mkv)

TV=${TV// /.} # replace space (" ") to dot (".")

TV=`echo $TV | tr '[:upper:]' '[:lower:]'` # to lowercase
TV=`echo $TV | tr '\.\-\_' $TV_SEPCHAR` # replace .-_ to separate character
TV=`expr "$TV" : '\([^\[\(]*\)'` # remove brackets
if [ "`expr "$TV" : '\(.*\)[0-9][0-9][0-9][0-9]'`" != "" ]; then
  TV=`expr "$TV" : '\(.*\)[0-9][0-9][0-9][0-9]'` # remove year
fi

TV_URI=${TV_URI/TV/$TV} # create URI

`$TV_BROWSER $TV_URI` # execute command
