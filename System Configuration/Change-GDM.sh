#!/bin/bash
#CHANGE GDM BY ANTONIOSERRANOL / ASL2690
#   asl2690@gmail.com
# twitter.com/antonioserranol
# elblogsobreubuntu.wordpress.com
# artescritorio.com
#	USE THIS SCRIPT BY YOUR OWN RISK
#	
#	
#
#
################################################################
################################################################
 
opcion=`/usr/bin/zenity --title="Change GDM GUI by antonioserranol" --width=400 --height=220 \
                         --text="Hi $USER ! what do you want? 				|Change GDM GUI by antonioserranol" \
                         --list --column="Seleccionar" --column="  " \
                         --radiolist FALSE "Use GDM Appearance Preference" FALSE "Select a Wallpaper" FALSE "Current GTK Theme as GDM Theme" FALSE "Current Wallpaper as GDM Background"  FALSE "Remove GDM Appearance Preference" `
 

if [ $? -eq 0 ]
then
        IFS="|"
        for opcion in $opcion
        do
################### PREF DE GDM
               if [ "$opcion" = "Use GDM Appearance Preference" ];
                then 
                
		sudo cp /usr/share/applications/gnome-appearance-properties.desktop /usr/share/gdm/autostart/LoginWindow
		zenity --question --text="Do you want close Session to make the changes immediately?"; case $? in
          	 0)
                        sudo /etc/init.d/gdm restart ;;
                 1)
                        echo "No"
			notify-send "I recommend you close your sessions to make the changes" -i gdm-setup;;
                 
        esac

###################### SELECCIONAR WALLPAPER
 		
               elif [ "$opcion" = "Select a Wallpaper" ]
                     then
               imagen=`zenity --file-selection --title="Selecct a Wallpaper"`

			
			sudo chmod 777 $imagen			
			#sudo cp $imagen /usr/share/backgrounds/
			sudo -u gdm gconftool-2 --set --type string /desktop/gnome/background/picture_filename "$imagen"
			zenity --question --text="Do you want close Session to watch the changes immediately?"; case $? in
          	 0)
                        sudo /etc/init.d/gdm restart ;;
                 1)
                        echo "No"
			notify-send "I recommend you close your sessions to make the changes" -i gdm-setup;;
                
        		esac

####################### QUITAR PREF GDM			
            	  elif [ "$opcion" = "Remove GDM Appearance Preference" ]
                     then
                   sudo rm -rf /usr/share/gdm/autostart/LoginWindow/gnome-appearance-properties.desktop & killall gnome-panel & killall nautilus
                     zenity --info \
			 --text="Finished .. Have a nice day ;)"

##################### USAR WALLPAPER ACTUAL

            
	      elif [ "$opcion" = "Current Wallpaper as GDM Background" ]
		then
		
			FONDO_ACTUAL=$(gconftool-2 --get /desktop/gnome/background/picture_filename)
		if [ ! -a "$FONDO_ACTUAL" ]; then	
			sudo -u gdm gconftool-2 --set --type string /desktop/gnome/background/picture_filename "$FONDO_ACTUAL"
		fi
	
	zenity --question --text="Do you want close Session to watch the changes immediately?"; case $? in
          	 0)
                       sudo /etc/init.d/gdm restart ;;
                 1)
                        echo "No ";;
		esac
              
################AGREGAR el tema

		elif [ "$opcion" = "Current GTK Theme as GDM Theme" ]
		 then 
			TEMA_ACTUAL=$(gconftool-2 --get /desktop/gnome/interface/gtk_theme)
		if [ ! -a "$TEMA_ACTUAL" ]; then	
		
		sudo -u gdm gconftool-2 --set --type string /desktop/gnome/interface/gtk_theme "$TEMA_ACTUAL"

		fi
	
	zenity --question --text="Do you want close Session to watch the changes immediately?"; case $? in
         	
		 0)
                       sudo /etc/init.d/gdm restart ;;
                 1)
                        echo "No ";;
		  
        esac

###########################
               fi
        done
       IFS=""

fi


