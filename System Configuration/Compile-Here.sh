#!/bin/sh
	#################################################
	#	Created by: DjSpider			#
	#	Email: spider.36@wp.eu			#
	#################################################

OUT=$(zenity --title "Output file"  --entry --text="Type output filename")


FILE="$@"


g++ "$FILE" -o "$OUT"
