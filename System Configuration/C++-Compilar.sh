#!/bin/bash

case ${1#*.}
in
	c)
		GCC=`which gcc`
		$GCC "$1" -o "${1%%.*}" && {
			Xdialog --msgbox "File successfully compiled: \n${1%%.*}" 10 50
			exit 0;
		} || {
			Xdialog --msgbox "Compilation failed" 10 30
			exit 1;
		}
		;;
	cpp)
		GPP=`which g++`
		$GPP "$1" -o "${1%%.*}" && {
			Xdialog --msgbox "File successfully compiled: \n${1%%.*}" 10 50
			exit 0;
		} || {
			Xdialog --msgbox "Compilation failed" 10 30
			exit 1;
		}

		;;
	*)
		echo -e "Error, source code is not C or C + +";
		exit 1;
esac
