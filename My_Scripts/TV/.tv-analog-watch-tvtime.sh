#!/bin/sh
sox -s -r 32000 -c 2 -t alsa hw:1,0 -s -r 32000 -c 2 -t alsa hw:0,0 & 
tvtime
t=`pidof sox`;
kill $t;
