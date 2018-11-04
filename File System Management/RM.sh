#!/bin/bash

# Delete ~ from working directory
##########################################################################
#                           Nautilus LS                                  #
##########################################################################
#                                                                        #
# Created by Michal Horejsek.com (pxjava)                                #
# Email: horejsekmichal@gmail.com                                        #
# Version: 1.0 / 17.8.2009 14:40:37                                      #
#                                                                        #
##########################################################################

wdir=${NAUTILUS_SCRIPT_CURRENT_URI#file://}
wdir=${wdir//%20/ }

rm $wdir/*~
rm $wdir/.*~
rm $wdir/*.old
rm $wdir/*.bak
rm $wdir/*.OLD
rm $wdir/*.BAK
