#!/bin/bash


###### WATCH ANALOG TV
sh -c "tvtime & sox -r 48000 -t alsa hw:1,0 -t alsa hw:0,0"
