#!/bin/sh
#Nautilus Script to convert JPG to PDF
#V.1.0
#Requires "imagemagick" package which includes "convert"
#
convert "$1" "${1%\.jpg}.pdf"