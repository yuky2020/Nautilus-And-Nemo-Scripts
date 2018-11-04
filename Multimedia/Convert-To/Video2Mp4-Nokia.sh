##########
#!/bin/bash
#
# video2nokia_mp4 - Make nokia 5800/97/N8 compatible mp4 video file from other video files
#           
# Author  - Asif Ali Rizvan
#
# Version:	1.0
#
# Usage   - video2nokia_mp4.sh $1
#           Run this script either from the terminal or by right clicking the video file and selecting the script
# 
##########

	for i in "$@"
	do
	ffmpeg -i "$1" -f mp4 -vcodec libxvid -s 640x320 -b 720k -r 24  -acodec libmp3lame -ab 128 -ar 44100 -ac 2 "$1.mp4"
	notify-send -t 5000 "$i Converted"
	done
