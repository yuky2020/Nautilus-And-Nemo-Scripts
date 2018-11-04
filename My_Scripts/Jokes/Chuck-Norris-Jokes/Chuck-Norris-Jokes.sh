#!/bin/bash

notify-send -t 8000 -i /usr/share/icons/gnome/32x32/status/info.png " " "`shuf -n1 /home/$USER/.gnome2/nemo-scripts/My_Scripts/Jokes/Chuck-Norris-Jokes/.chuck-norris-jokes.txt`"
