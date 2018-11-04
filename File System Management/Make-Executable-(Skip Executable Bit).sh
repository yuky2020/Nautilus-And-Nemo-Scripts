#!/bin/bash
if [ "$(id -u)" != "0" ]; then printf "\n * You must run this script as root.\n\n"; exit 0; fi
echo '[Desktop Entry]
Type=Application
Name=Wine Windows Program Loader
Exec=wine start /unix %f
MimeType=application/x-ms-dos-executable;application/x-msi;application/x-win-lnk;application/x-ms-shortcut
Icon=wine
NoDisplay=true
Icon=wine
StartupNotify=true' > /tmp/wine.desktop
sudo cp --remove-destination /tmp/wine.desktop /usr/share/applications/wine.desktop
sudo rm -f /tmp/wine.desktop
