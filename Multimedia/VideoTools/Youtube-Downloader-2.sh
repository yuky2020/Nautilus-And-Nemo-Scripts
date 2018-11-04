#!/bin/sh
# Questo script serve per scaricare video da youtube
# basta inserire indirizzo del video e il nome scelto per il video...
# By http://www.frankrock.it
# frankrock74@gmail.com

echo 'Script By www.FrankRock.it'
echo

var=`zenity --entry --title="By FrankRock.it" --text="Inserisci indirizzo youtube del video che intendi scaricare:"`

if [ $? = 0 ] ; then

varname=`zenity --entry --title="By FrankRock.it" --text="Inserisci il nome che vuoi dare al video"`

if [ $? = 0 ] ; then

#echo date >> /home/$USER/Video_Scaricati/Video_Scaricati.txt
echo "$varname": "$var" >> /home/$USER/Video/Video_Scaricati.txt
echo >> /home/$USER/Video/Video_Scaricati.txt

youtube-dl "$var" | zenity --progress --pulsate --auto-close --auto-kill --title="By FrankRock.it" --text="Sto scaricando il file $varname \n Attendere!"

mv *.flv "$varname".flv

zenity --question --title="By FrankRock.it" --text="vuoi vedere il video $varname a schermo intero?"

if [ $? = 0 ] ; then

mplayer -identify -fs ./"$varname".flv
mv "$varname".flv /home/$USER/Video/

else

mplayer -identify ./"$varname".flv
mv "$varname".flv /home/$USER/Video/

fi
fi
fi

zenity --info --title="By FrankRock.it" --text="Operazione conclusa\! \n Script By FrankRock.it v 1.0"

exit 0
