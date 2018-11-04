#! /bin/sh

# Autor: Cristtopher Quintana Toledo
# Email: cristtopher@debian.cl
#

rm ~/.gconf/desktop/gnome/peripherals/keyboard/%gconf.xml
sudo /etc/init.d/gdm restart
