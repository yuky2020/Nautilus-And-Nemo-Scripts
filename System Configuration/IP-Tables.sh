#!/bin/bash
echo
echo "  ~·~·~·~·~·~·~·~·~·~·~·~·~·"
echo " * Script By FrankRock.it *"
echo " ~·~·~·~·~·~·~·~·~·~·~·~··"
echo

# By http://www.frankrock.it
# frankrock74@gmail.com

sudo iptables -P INPUT   DROP

sudo iptables -P FORWARD   DROP

sudo iptables -A INPUT  -i lo -j ACCEPT

sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#
# Qui sotto le Porte che decidiamo di lasciare aperte
#

sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

sudo iptables -A INPUT -p tcp --dport 21 -j ACCEPT

sudo iptables -A OUTPUT -p tcp --dport 21 -j ACCEPT

# questo script va lanciato quando si vuole usarlo perche non rende definitive le regole
# impostate...
# si puo impostare rc.local per richiamare questo script...
# cosi all avvio sarà attivo
# Basta aggiungere fra le righe di commento (Blu) e la riga exit 0
# questa stringa:
# /home/$USER/percorso script/iptables.sh
#oppure metterlo negli script di nautilus ;)

# IMPORTANTE: Se usate ftp va usato in passive mode

