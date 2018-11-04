#!/bin/bash
#########################################################
#							#
# This are NScripts v3.6				#
#							#
# Licensed under the GNU GENERAL PUBLIC LICENSE 3	#
#							#
# Copyright 2007 - 2009 Christopher Bratusek		#
#							#
#########################################################

TERMINAL="$(gconftool-2 --get /desktop/gnome/applications/terminal/exec) \
$(gconftool-2 --get /desktop/gnome/applications/terminal/exec_arg)"

if [[ $TERMINAL == "" ]]; then
	TERMINAL="xterm -e"
fi

action=$(zenity --list --radiolist \
	--height 260 --width 420 \
	--title Apt --text "Choose an Action to perform" \
	--column "Pick" --column "Action" \
	TRUE "update (Update Package Database)" \
	FALSE "upgrade (install updates (same dist))" \
	FALSE "dist-upgrade (install updates (dist +1))" \
	FALSE "autoclean (Clean Archive Cache)" \
	FALSE "autoremove (Remove no longer needed packages)" \
	FALSE "source (install source package)" \
	FALSE "build-dep (Install Build-Dependencies for a package)")

case $action in

	update* )
		$TERMINAL "su -c \"apt-get update\""
	;;

	dist-upgrade* )
		$TERMINAL "su -c \"apt-get dist-upgrade\""
	;;

	autoclean* )
		$TERMINAL "su -c \"apt-get clean\""
		$TERMINAL "su -c \"apt-get autoclean\""
	;;

	autoremove* )
		$TERMINAL "su -c \"apt-get autoremove\""
	;;

	source* )
		package=$(zenity --entry --title Package --text "Which package's source to install?")
		$TERMINAL "su -c \"apt-get source $package\""
	;;

	build-dep* )
		package=$(zenity --entry --title Package --text "Which package's build dependencies to install?")
		$TERMINAL "su -c \"apt-get build-dep $package\""
	;;

esac
