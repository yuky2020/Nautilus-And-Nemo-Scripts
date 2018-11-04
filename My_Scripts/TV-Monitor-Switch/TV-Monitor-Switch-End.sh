#!/bin/bash

###### use the command: "xrandr" to discover what
# the proper connected video outputs there are attached
# such as VGA-0 (monitor), LVDS1 (Laptop screen), S-video, VGA1
# (VGA-to-TV Converter Box), etc.

mode="$(xrandr -q|grep -A1 "LVDS1 connected"| tail -1 |awk '{ print $1 }')"
if [ -n "$mode" ]; then
  mode1="$(xrandr -q|grep -A1 "VGA1 connected"| tail -1 |awk '{ print $1 }')"
  if [ -n "$mode1" ]; then
    xrandr --output LVDS1 --mode 1280x800 --output VGA1 --off
  else
    echo "No VGA1 monitor is connected so nothing to do."
  fi
else
  mode2="$(xrandr -q|grep -A1 "VGA-0 connected"| tail -1 |awk '{ print $1 }')"
  if [ -n "$mode2" ]; then
    mode3="$(xrandr -q|grep -A1 "S-video connected"| tail -1 |awk '{ print $1 }')"
    if [ -n "$mode3" ]; then
      xrandr --output VGA-0 --mode 1024x768 --output S-video --off
    else
      echo "No S-video monitor is connected so nothing to do."
    fi
  else
    echo "No other monitor is connected so nothing to do."
  fi
fi

