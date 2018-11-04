#!/bin/bash
echo
echo "  ~·~·~·~·~·~·~·~·~·~·~·~·~·"
echo " * Script By FrankRock.it *"
echo " ~·~·~·~·~·~·~·~·~·~·~·~··"
echo
# Selezionare il file avi ed aspettare la fine della conversione.
#
# By http://www.frankrock.it
# frankrock74@gmail.com
#
ASF=$@

mencoder "$ASF" -oac copy -ovc xvid -xvidencopts fixed_quant=2:chroma_opt:vhq=4 -o "$ASF".avi | zenity --progress --pulsate --auto-close --title="By FrankRock.it" --text="ATTENDERE! \n Sto convertendo "$ASF""

zenity --info --title="By FrankRock.it" --text="Conversione di "$ASF" eseguita!"

exit 0
