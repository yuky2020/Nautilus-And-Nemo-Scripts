#!/bin/bash

ARSIZES="128x128 96x96 72x72 64x64 56x56 48x48 32x32 22x22 16x16"

echo $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS > ~/.gnome2/nemo-scripts/.temp_cloning_list

# for file_path_from in $@
for file_path_from in $(cat ~/.gnome2/nemo-scripts/.temp_cloning_list)
do

# The script doesn't work if I leave this "if" thingy on. Don't know why:
#	if   [ -f $file_path_from ]; then # --------------- what's this?
		#icono que vamos a clonar
		selected_icon_name=`basename $file_path_from`

		#ubicacion
		selected_icon_folder=`dirname $file_path_from`

		#apps, device, mimetype, etc....
		selected_icon_category=`echo $file_path_from | sed "s/\(.*\)\/\(.*\)\/\(.*\)\/\(.*\)/\3/g"`

		#128x128, 96x96, 64x64, etc sin la X (64x64 => 6464)
		selected_icon_size=`echo $file_path_from | sed "s/\(.*\)\/\(.*\)\/\(.*\)\/\(.*\)/\2/g" | sed "s/x//g"`

		#nombre del tema de iconos
		selected_icon_theme=`echo $file_path_from | sed "s/\(.*\)\/\(.*\)\/\(.*\)\/\(.*\)/\1/g"`

		counter=0
#		window=`kdialog --progressbar "Making clones" 8`
#		++++++++++++++++
#	window=`zenity --title="Clonator" --text="Making clones" `
#  window=`zenity --title="Clonator" --text="Making clones" --auto-close`
# Coludn't figure out what the zenity equivalent is so I put this instead:
notify-send --icon=$file_path_from --expire-time=30 'Clonator is cloning this icon.'

		for icon_destination_folder in $ARSIZES
		do

			let "counter +=1"
			#solo clona el icono a carpetas de tamaño menor del actual

			if [ `echo $icon_destination_folder | sed "s/x//g"` -lt $selected_icon_size ]; then

				#si el icono es un enlace simbólico hace un clon corrigiendo hacia donde apunta
				if [ -h $file_path_from ]; then
					destino=`ls -l $file_path_from | sed "s/.*\(-> \)//g"`
					destino=`basename $destino`

					#recrea enlace simbólico sobreescribiendo existentes (-f)

#					dcop "$window" setLabel "Enlazando $selected_icon_name en $icon_destination_folder"
#					dcop "$window" setProgress "$counter"
#					echo "Creating an symlinks to $selected_icon_theme/$icon_destination_folder/$selected_icon_category/$destino en $selected_icon_theme/$icon_destination_folder/$selected_icon_category/$selected_icon_name"
#
# I don't know why this doesn't work. Its as if --expire-time is totally ignored:
# notify-send --icon=~/.icons/clonator.svg --expire-time=30 "Creating symlinks to $icon_destination_folder/$selected_icon_category/$destino en $selected_icon_name"

					ln -s -f $selected_icon_theme/$icon_destination_folder/$selected_icon_category/$destino $selected_icon_theme/$icon_destination_folder/$selected_icon_category/$selected_icon_name
				else

					#crea imagen escalada
#					dcop "$window" setLabel "Creating $selected_icon_name on $icon_destination_folder"
# 				  dcop "$window" setProgress "$counter"
#					echo "Creating $file_path_from of $icon_destination_folder pixel in $selected_icon_theme/$icon_destination_folder/$selected_icon_category/$selected_icon_name"
#
# I don't know why this doesn't work. Its as if --expire-time is totally ignored:
# notify-send --icon=~/.icons/clonator.svg  --expire-time=30 "Creating $selected_icon_name of $icon_destination_folder pixel in $icon_destination_folder..."

# ----------------------------THE JOB
					convert $file_path_from -resize $icon_destination_folder $selected_icon_theme/$icon_destination_folder/$selected_icon_category/$selected_icon_name
# ----------------------------THE JOB
				fi

			else
# The script croaks if I comment these three dcop thingies out. Don't know why :

				dcop "$window" setLabel "Ignore $selected_icon_name on $icon_destination_folder"
			  dcop "$window" setProgress "$counter"

			fi
		done

		dcop "$window" close
#	fi
done
#
#
rm -f ~/.gnome2/nemo-scripts/.temp_cloning_list
#
