#!/bin/bash
#
# nautilus-gdm-save-settings
#
# papallo83@live.it

if 	[ -f /usr/share/gdm/autostart/LoginWindow/gnome-appearance-properties.desktop ];

then

	if	zenity --question --title "GNOME Display Manager" --text "Save GDM configuration?"

	then

		if	gksu -D GDM rm /usr/share/gdm/autostart/LoginWindow/gnome-appearance-properties.desktop

		then
	
			zenity --info --title "GNOME Display Manager" --text "GDM configuration saved!"

		else

			exit 1

		fi

	else

		exit 1

	fi

else

	zenity --error --title "GNOME Display Manager" --text "You must configure GDM!"

fi
