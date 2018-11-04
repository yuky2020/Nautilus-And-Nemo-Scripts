#!/bin/sh


if [ -f /usr/bin/wkhtmltopdf ];
             then

website=$(zenity --title  "Enter your website address: "  --entry --text="Ex: http://google.com " --width 300)
name=$(zenity --title  "Enter ps name: "  --entry --text="Ex: google-page \nUse no spaces" --width 300 )
cd $HOME/Desktop
wkhtmltopdf $website $name.ps | zenity --title="Saving..." --progress --pulsate --auto-close --no-cancel --text="Saving your page to Desktop and coverting to ps...\n $website" --width 350
 
else 
echo | zenity --progress --title="The program not installed" --text=" Install using commandline:\n \n sudo apt-get install wkhtmltopdf" --width 300
fi
