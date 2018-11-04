#!/bin/sh
#Nautilus Script to convert PNG to PDF
#V.1.0
#Requires "imagemagick" package which includes "convert"
#
convert "$1" "${1%\.png}.pdf"