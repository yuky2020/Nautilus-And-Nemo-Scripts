#!/bin/sh

# Created by jennie
# An extremely basic script to email books to a Kindle device
# from the Nautilus file manager, using any gmail account
# You will need to replace every instance of myusername and mypassword with your own
# Requires: sudo apt-get install calibre


calibre-smtp -r smtp.gmail.com --port 587 --username myusername@gmail.com --password mypassword -vv --subject convert --attachment $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS myusername@gmail.com myusername@free.kindle.com "email"
