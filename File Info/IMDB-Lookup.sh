#!/bin/bash

# variables
#browser='google-chrome'
browser='firefox'

for file in `echo $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS`
do
	title=`echo $file | sed 's/.*\///g;s/....$//g'`
	url=`curl -s "http://www.deanclatworthy.com/imdb/?q=$title&type=text" | grep "imdburl" | cut -d"|" -f2`
	$browser "$url"
done
