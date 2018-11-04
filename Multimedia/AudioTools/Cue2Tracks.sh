#!/bin/bash

#Small script for converting and splitting music
#for normal work mac and shntool packages required
#
#Небольшой скрипт для конвертирования и разбития музыки
#для корректной работы требуются пакеты mac, shntool

err="An error occurred during convertation."
sucsess="Conversion completed successfully."
notcue="Please, choose .cue file."
nofile="Can't find supported format files."
waiting="Please wait. Convertation is running now."
choosefmt="Please, choose output format."

if [ "${LANG%%.*}" = "ru_UA" ] || [ "${LANG%%.*}" = "ru_UA" ]; then
	err="Возникла ошибка во время конвертации."
	sucsess="Конвертирование прошло успешно."
	notcue="Пожалуйста, выбирите .cue фаил."
	nofile="Не найдено ни одного файла известного формата."
	waiting="Подождите, идет конвертация."
	choosefmt="Пожалуйста, выбирите формат выходного файла."
fi

cue="$1"
image="${cue%%.cue}"
ext=""

if [ "$image" ]; then
	if [ -f "$image.ape" ]; then
		ext="$image"".ape"
	fi
	if [ -f "$image"".wav" ]; then
		ext="$image"".wav"
	fi
	if [ -f "$image.flac" ]; then
		ext="$image"".flac"
	fi
	if [ "$ext" = "" ]; then
		zenity --error --text "$nofile"
		exit -1
	fi
	echo $ext
	out=`zenity --title="cue2tracks" --list --radiolist --column="" --column="" --column="Format" --hide-column=2 --text="$choosefmt" \
		TRUE	"flac"		"Free Lossless Audio Codec (.flac)" \
		FALSE	"shntool"	"RIFF WAVE file format (.wav)" \
		FALSE	"mac"		"Monkey's Audio Compressor (.ape)"`
	shntool split "$ext" -f "$cue" -o $out -t "%n - %t" 2>&1 | zenity --title="cue2tracks" --progress --pulsate --auto-close --no-cancel --text="$waiting"
	if [ "$?" = -1 ] ; then
		zenity --error --text="$err"
	else
		zenity --info --text="$sucsess"
	fi
else
	zenity --error --text="$notcue"
fi
