#!/bin/bash
#
# nautilus-gdm-settings
#
# papallo83@live.it

if 	[ -f /usr/share/gdm/autostart/LoginWindow/gnome-appearance-properties.desktop ];

then

	if	zenity --question --title "GNOME Display Manager" --text "Overwrite previous configuration?"

	then

		if 	 zenity --question --title "GNOME Display Manager" --text "Please save your session! System will now log out!"

		then

			gksu -D GDM ln -fs /usr/share/applications/gnome-appearance-properties.desktop /usr/share/gdm/autostart/LoginWindow/
			/usr/bin/gnome-session-save --force-logout
		
		else

			exit 1

		fi

	else

		exit 1

	fi

else

	if	zenity --question --title "GNOME Display Manager" --text "Please save your session! System will now log out!"

	then

		gksu -D GDM ln -s /usr/share/applications/gnome-appearance-properties.desktop /usr/share/gdm/autostart/LoginWindow/
		/usr/bin/gnome-session-save --force-logout

	else

		exit 1

	fi

fi
