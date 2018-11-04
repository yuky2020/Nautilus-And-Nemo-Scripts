#!/bin/bash
# Font-Installer
##########################################################################
#                              Font Installer                            #
##########################################################################
#                                                                        #
# Created by Federico Vecchio (Vecna)                                    #
#                                                                        #
##########################################################################
# Language Settings ---------------------------------------------------- #
ok='Font(s) installed!'
title_ok='Font Installer'

title_wait='Updating'
wait='Updating font cache...'

errors='An error has occured'
title_errors='Error'

# End of language settings ----------------------------------------------#
##########################################################################


if [[ ! -e "~/.fonts" ]]; then
	mkdir -p ~/.fonts
fi

(c=0)

(for arg do
        n=$#
        nomefont=`basename "$arg"`
	files=`echo "$arg" | sed 's/ /\\ /g'`
	mv "${files}" ~/.fonts
        c=$((c+1))
echo $((c*100/$n))
done) | zenity --progress --title "$title_ok" --text "Copying fonts...";


gksu fc-cache -fv | zenity --progress --pulsate --title "$title_wait" --text "$wait";
if [ "$?" -gt 0 ]; then
      zenity --error --text "$errors" --title "$title_errors"
else
zenity --info  --title "$title_ok" --text="$ok"
fi

exit 0

