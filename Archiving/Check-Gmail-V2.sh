#!/bin/bash
#
# lunedì-28-05-2012
# Ora: 15:01
# By http://www.frankrock74.it
# frankrock74@gmail.com
#
### Riempi le 4 variabili con i tuoi dati
## variabili → PASSWRD ; UTENTE ; SOUNDM ; ICON
# Lancia senza terminale lo script e inseriscilo nella applicazioni di avvio cosi sara' sempre attivo
## Lo script fornisce una notifica se arriva una mail controllando ogni 10 minuti
# Nella notifica appare un link che se clickato aprira' il browser in gMail
# Uso → Ubuntu 12.04
#

while [ 0 ]; do

PASSWRD="TuaPassword"
UTENTE="tua@mail.com"
SOUNDM="~/your/path/Soudn/Advise.wav"
ICON="~/your/path/Icon/Icon.png"

sleep 10m

echo -e "Check New Message... \c"
 
atomlines=`wget -T 3 -t 1 -q --secure-protocol=TLSv1 \
 --no-check-certificate \
 --user=$UTENTE --password=$PASSWRD \
 https://mail.google.com/mail/feed/atom -O - \
 | wc -l`

atomline=`wget -T 3 -t 1 -q --secure-protocol=TLSv1 \
 --no-check-certificate \
 --user=$UTENTE --password=$PASSWRD \
 https://mail.google.com/mail/feed/atom -O - > ~/.dati`

mitt=`cat ~/.dati | grep email | cut -d '>' -f 2 | cut -d '<' -f 1 `

echo -e "\r\c"

if [ $atomlines -gt 8 ] ;

then

notify-send "Mail in arrivo" "Mittente: $mitt \n\nApri gmail: <i>https://mail.google.com/mail/u/0/?shva=1#inbox</i> `mplayer $SOUNDM`" -i $ICON

rm -f ~/.dati

else

rm -f ~/.dati

fi

done
#
# Tutti i pacchetti e gli script in essi contenuti sono proprietà di FrankRock74.it, inventati e scritti da me.
# Liberamente usabili modificabili e da distribuire gratuitamente
#
