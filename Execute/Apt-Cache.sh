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

action=$(zenity --list --radiolist --width 430 --height 270 \
	--title "Apt Cache" --text "Choose an Action to perform" \
	--column Pick --column Action \
	TRUE "showpkg (show information for a package)" \
	FALSE "showsrc (show information for a source-package)" \
	FALSE "search (search in the database via regular expressions)" \
	FALSE "show (show information for a package)" \
	FALSE "depends (show dependencies of a package)" \
	FALSE "rdepends (show reverse dependencies of a package)" \
	FALSE "pkgnames (list names of all installed packages)")

showpkg () {

	package=$(zenity --entry --title Package --text "Choose a package")
	apt-cache showpkg $package > /tmp/apt_cache.txt
	zenity --text-info --title "Result" --width=640 --height=480 --filename=/tmp/apt_cache.txt

}

showsrc () {

	package=$(zenity --entry --title Package --text "Choose a package")
	apt-cache showsrc $package > /tmp/apt_cache.txt
	zenity --text-info --title "Result" --width=640 --height=480 --filename=/tmp/apt_cache.txt

}

search () {

	term=$(zenity --entry --title Package --text "Enter search-term")
	apt-cache search $term > /tmp/apt_cache.txt
	zenity --text-info --title "Result" --width=640 --height=480 --filename=/tmp/apt_cache.txt

}

show () {

	package=$(zenity --entry --title Package --text "Choose a package")
	apt-cache show $package > /tmp/apt_cache.txt
	zenity --text-info --title "Result" --width=640 --height=480 --filename=/tmp/apt_cache.txt

}

depends () {

	package=$(zenity --entry --title Package --text "Choose a package")
	apt-cache depends $package > /tmp/apt_cache.txt
	zenity --text-info --title "Result" --width=640 --height=480 --filename=/tmp/apt_cache.txt

}

rdepends () {

	package=$(zenity --entry --title Package --text "Choose a package")
	apt-cache rdepends $package > /tmp/apt_cache.txt
	zenity --text-info --title "Result" --width=640 --height=480 --filename=/tmp/apt_cache.txt

}

pkgnames () {

	apt-cache pkgnames > /tmp/apt_cache.txt
	zenity --text-info --title "Result" --width=640 --height=480 --filename=/tmp/apt_cache.txt

}

case $action in

	showpkg* )
		showpkg
	;;

	showsrc* )
		showsrc
	;;

	search* )
		search
	;;

	show* )
		show
	;;

	depends* )
		depends
	;;

	rdepends* )
		rdepends
	;;

	pkgnames* )
		pkgnames
	;;

esac
