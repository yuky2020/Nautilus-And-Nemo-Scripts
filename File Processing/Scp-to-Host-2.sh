#!/bin/sh
#
# This script scp's file/s to a given url.
#
# Distributed under the terms of GNU GPL version 2 or later
#
# Copyright (C) Keith Conger <acid@twcny.rr.com>
#
# Install in your ~/Nautilus/scripts directory.
# You need to be running Nautilus 1.0.3 +

URL=$(gdialog --title "scp file(s) to?" --inputbox "user@host:/" 200 550 2>&1)

gnome-terminal -t "Copying file.." -x scp $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS $URL

