username=$(zenity --title="Envied Megauploader" --width=270 --entry --text "Insert your Megaupload Username" --entry-text "Your username here"); echo $username
if [ $username ];then
password=$(zenity --entry --title="Envied Megauploader" --width=270 --text="Insert your Megaupload Password" --entry-text "Your password here" ); echo $password
fi
#===============================================================================
FILE=`zenity --file-selection --title="Select the file you wish to upload"`

        case $? in
                 0)
                        echo "\"$FILE\" selected.";;
                 1)
                        echo "No file selected.";;
                -1)
                        echo "No file selected.";;
        esac
#================================================================================
description=$(zenity --entry --title="File description" --text="Insert the file description" --entry-text "Your username here")
plowup megaupload "$FILE" --auth "$username":"$password" -d "$description" 2>&1 | zenity --title="Envied Megauploader" --width 500 --height 500 --text-info
#================================================================================
exito
