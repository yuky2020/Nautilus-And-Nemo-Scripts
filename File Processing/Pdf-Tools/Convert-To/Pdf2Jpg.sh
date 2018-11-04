#!/bin/sh
#Nautilus Script to convert PDF to JPG with 300dpi resolution
#V.1.0
#Requires "imagemagick" package which includes "convert"
#
convert -density 300 "$1" "${1%\.pdf}.jpg"