#!/bin/bash
#
#############################################
#           Versión 0.9                     #
#           Para Debian                     #   
# Creado por: erar123 erar_123@hotmail      #
#############################################  
#
killall AnimatedDesktopStarter


NOMBREBASE=`basename "$*"`
direc="$PWD/$NOMBREBASE"
opacidad="0.6"
SON=" -nosound"
Buscar=$(find ~/.AnimatedDesktop/ -name "AnimatedDesktopStarter")
Buscar1=${Buscar:`expr length $Buscar`-22:22}

if [ "$Buscar1" = "AnimatedDesktopStarter" ]; then
	leer_opac=$(sed -n '4p' ~/.AnimatedDesktop/AnimatedDesktopStarter)
	leer_opac1=${leer_opac:1:`expr length "$leer_opac"`-1}
	opacidad=$leer_opac1
	leer_son=$(sed -n '5p' ~/.AnimatedDesktop/AnimatedDesktopStarter)
	leer_son1=${leer_son:1:`expr length "$leer_son"`-1}
	SON=$leer_son1
fi

if [ "$NOMBREBASE" = "" ]; then
# Parte del Codigo Modificado de VideoFondo.sh	
# Realizado inicialmente por Catrip <alktrip@gmail.com>	
# y retocado por aabilio <aabilio@gmail.com>		
# WTFPL <http://en.wikipedia.org/wiki/WTFPL> 		
# Modificado por erar123 erar_123@hotmail.com
############################################


opcion1="End Play"
opcion2="Back to previous video"
opcion3="Opacity"
opcion4="Sound"

con_sonido="Video with sound"
sin_sonido="Video without sound"

function fun_opacidad {
	opacidad=$(zenity --list --width="60" --height="415" --text "Select an option" --title "Opacity Level" --column "Opacity" `for (( c=1; c<=9; c++ )); do echo -n "0.$c "; done` 1.0)
}

function fun_typeson {
	typeson=$(zenity --list --width="315" --height="260" --text "Video options" --title "Screen Saver" --column "Opción" "$con_sonido" "$sin_sonido")
	if [ "$typeson" = "$sin_sonido" ]; then
		SON=" -nosound"
	fi
	if [ "$typeson" = "$con_sonido" ]; then
		unset SON
	fi
}

function main {
type=$(zenity --list --width="415" --height="260" --text "Select the operation to perform" --title "Animated Desktop"  --column "Option" "$opcion1" "$opcion2" "$opcion3" "$opcion4")

if [ "$type" = "$opcion1" ]; then

	killall xwinwrap
        killall xwinwrap
	exit

fi

if [ "$type" = "$opcion2" ]; then
	Proceso=`ps -A | grep xwinwrap`
	Proceso1=${Proceso:`expr length $Proceso`-8:8}
	if [ "$Proceso1" != "xwinwrap" ]; then
	~/.AnimatedDesktop/AnimatedDesktopStarter
	else
	cp ~/.AnimatedDesktop/AnimatedDesktopStarter ~/.AnimatedDesktop/AnimatedDesktopStarter1
	cp ~/.AnimatedDesktop/AnimatedDesktopStarterBack ~/.AnimatedDesktop/AnimatedDesktopStarter
	cp ~/.AnimatedDesktop/AnimatedDesktopStarter1 ~/.AnimatedDesktop/AnimatedDesktopStarterBack
	rm ~/.AnimatedDesktop/AnimatedDesktopStarter1
 	~/.AnimatedDesktop/AnimatedDesktopStarter
	fi
	exit

fi
if [ "$type" = "$opcion3" ]; then
	leer_direc=$(sed -n '3p' ~/.AnimatedDesktop/AnimatedDesktopStarter)
	direc=${leer_direc:1:`expr length "$leer_direc"`-1}
	leer_NOMBREBASE=$(sed -n '2p' ~/.AnimatedDesktop/AnimatedDesktopStarter)
	NOMBREBASE=${leer_NOMBREBASE:1:`expr length "$leer_NOMBREBASE"`-1}
	fun_opacidad
	if [ "$opacidad" = "" ]; then
		main
	fi
fi
if [ "$type" = "$opcion4" ]; then
	leer_direc=$(sed -n '3p' ~/.AnimatedDesktop/AnimatedDesktopStarter)
	direc=${leer_direc:1:`expr length "$leer_direc"`-1}
	leer_NOMBREBASE=$(sed -n '2p' ~/.AnimatedDesktop/AnimatedDesktopStarter)
	NOMBREBASE=${leer_NOMBREBASE:1:`expr length "$leer_NOMBREBASE"`-1}
	fun_typeson
	if [ "$typeson" = "" ]; then
	main
	fi
fi

if [ "$type" = "" ]; then
	exit
fi
}
main
#################################################
fi

killall xwinwrap
Buscar=$(find ~/.AnimatedDesktop/ -name "AnimatedDesktopStarter")
Buscar1=${Buscar:`expr length $Buscar`-22:22}

if [ "$Buscar1" = "AnimatedDesktopStarter" ]; then

	rm ~/.AnimatedDesktop/AnimatedDesktopStarterBack
	cp ~/.AnimatedDesktop/AnimatedDesktopStarter ~/.AnimatedDesktop/AnimatedDesktopStarterBack

fi

hora1=`date +%r`


rm ~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#!/bin/bash" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#$NOMBREBASE" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#$direc" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#$opacidad" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#$SON" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#Terminar proceso xwinwrap" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "killall xwinwrap" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#COMANDOS xwinwrap para poner los videos como escritorio animado" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "xwinwrap -ni -o $opacidad -fs -s -st -sp -b -nf -- mplayer -wid WID -quiet$SON \"$direc\" -loop 0" >>~/.AnimatedDesktop/AnimatedDesktopStarter
chmod u+rxw ~/.AnimatedDesktop/AnimatedDesktopStarter
~/.AnimatedDesktop/AnimatedDesktopStarter

Proceso=`ps -A | grep xwinwrap`
Proceso1=${Proceso:`expr length $Proceso`-8:8}

NOMBREBASE1=${NOMBREBASE:`expr length $NOMBREBASE`-4:1}
hora2=`date +%r`

if [ "$Proceso1" != "xwinwrap" ] && [ "$NOMBREBASE1" != "." ]; then


hora3=`date +%r`

rm ~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#!/bin/bash" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#$NOMBREBASE" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#$direc" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#$opacidad" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#$SON" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#Terminar proceso xwinwrap" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "killall xwinwrap" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "#COMANDOS xwinwrap para poner los protectores de pantalla como escritorio animado" >>~/.AnimatedDesktop/AnimatedDesktopStarter
echo "xwinwrap -ni -o $opacidad -argb -fs -s -st -sp -nf -b -- \"$direc\" -window-id WID" >>~/.AnimatedDesktop/AnimatedDesktopStarter
chmod u+rxw ~/.AnimatedDesktop/AnimatedDesktopStarter

~/.AnimatedDesktop/AnimatedDesktopStarter

hora4=`date +%r`

fi

if [ "$hora1" == "$hora2" ] && [ "$hora3" == "$hora4" ]; then
	
	cp ~/.AnimatedDesktop/AnimatedDesktopStarterBack ~/.AnimatedDesktop/AnimatedDesktopStarter
	chmod u+rxw ~/.AnimatedDesktop/AnimatedDesktopStarter
	rm ~/.AnimatedDesktop/AnimatedDesktopStarterBack
	~/.AnimatedDesktop/AnimatedDesktopStarter

fi

