#!/bin/bash

###### extract audio from DVD VOB files
INPUT_FILE=$(zenity --entry --text="Please input the file and location for the VOB file:")
OUTPUT_FILE=$(zenity --entry --text="Please input a name for the desired AC3 audio file:")
mplayer "$INPUT_FILE" -aid 128 -dumpaudio -dumpfile "$OUTPUT_FILE"
