#!/bin/bash

#------------------------------------------------------
# Imprime un mensaje de trazas
#------------------------------------------------------
function DEBUG
{
       HOUR=`date +"%m-%d-%y %H:%M"`
       TYPE="INFO"
       printf "%s %s : %s \n" "$HOUR" "$TYPE" "${1}"
}
#------------------------------------------------------

#---------------------------------------------------------------
# Reiniciar Xwinwrap con el fichero que se pasa como parametro
#---------------------------------------------------------------
function XWINWRAP
{
FICHERO=$1
DEBUG "Fichero es [$FILE]"

# Chequear que el fichero no este vacio
if [ -z $FICHERO ];
then
	# No se indico ningun fichero, salimos
	exit;
else
	DEBUG "File is $FILE"
	# TODO: Chequeamos si esta en ejecucion xwinwrap y lo paramos
	killall xwinwrap
	sleep 1
	# Reanudamos xwinwrap con el nuevo fichero
	DEBUG "Reanudando xwinwrap con $FILE..."
	xwinwrap -ni -o 1.0 -fs -s -st -sp -b -nf -- mplayer -loop 0 -wid WID -nosound -quiet "${FILE}" &
fi
}
#----------------------------------------------------------------


#----------------------------------------------------------------
# Principal
#----------------------------------------------------------------
# REQUIERE: zenity, mplayer y xwinwrap
# Puedes encontrar muchos videos en http://www.dreamscene.org/
#----------------------------------------------------------------
# Descarga de xwinwrap: http://tech.shantanugoel.com/projects/linux/shantz-xwinwrap
#----------------------------------------------------------------

VERSION="1.1"
ZENITY=$(which zenity)

# Textos

select_file="Select a file (.AVI, .WMV .MKV)."
error_nofiles="No file selected."

case $LANG in

es* )
	# Spanish
	select_file="Selecciona un archivo (.AVI, .WMV .MKV)."
	error_nofiles="Ningún archivo seleccionado."
	;;

esac

# Mostrar el cuadro de dialogo para seleccionar el fichero:
FILE=`$ZENITY --file-selection --title="$select_file" --file-filter="videos | *.wmv *.avi *.mkv"`

case $? in
                0)
                       DEBUG "\"$FILE\" selected."
                       #FICHERO=`echo $FILE | tail -1 | awk '{print $3}'` # necesario pq en mi caso añade progname= RGBA=
                       XWINWRAP $FILE
                       ;;

                1)
                        echo "$error_nofiles"
		        killall xwinwrap
			;;
               -1)
                       echo "$error_nofiles";;
esac




