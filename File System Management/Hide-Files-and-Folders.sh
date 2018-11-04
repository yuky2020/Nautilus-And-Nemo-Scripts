#!/bin/bash
[ -f "./.${1}" ] && {
	zenity --info --text="The file is hidden";
	exit 0;
} || {
	mv -vi "./${1}" "./.${1}"
	exit 0;
}
