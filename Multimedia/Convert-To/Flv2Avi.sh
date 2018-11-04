#!/bin/bash


# flv2avi 2.0 by r0ot
# 2008 - bash & zenity
# elteter0ot@gmail.com

ans=$(zenity  --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png" --width="540" --height="400" --list  --text "Select option" --radiolist  --column "Pick" --column "Option" --column "Description" FALSE "flv2avi_1" "Convert 1 flv to avi" FALSE "flv2avi_2" "Convert 2 flv to avi" FALSE "flv2avi_3" "Convert 3 flv to avi" FALSE "flv2avi_4" "Convert 4 flv to avi" FALSE "flv2avi_5" "Convert 5 flv to avi" FALSE "avimerge2" "Merge 2 avi in 1 avi" FALSE "avimerge3" "Merge 3 avi in 1 avi" FALSE "avimerge4" "Merge 4 avi in 1 avi" FALSE "avimerge5" "Merge 5 avi in 1 avi"); echo $ans

if [ $? -eq 1 ] ; then
exit 1
fi

case $ans in

"flv2avi_1") 
FILE=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`

        case $? in
                 0)
                        ffmpeg -i $FILE -b 256000 -f avi -vcodec copy -acodec copy $FILE.avi
	zenity --info \
	--text "Animated desktop \"$FILE\" convert!";;
                 1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
                -1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
        esac
;;

"flv2avi_2") 
FILE=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE2=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
        case $? in
                 0)
                        ffmpeg -i $FILE -b 256000 -f avi -vcodec copy -acodec copy $FILE.avi
			ffmpeg -i $FILE2 -b 256000 -f avi -vcodec copy -acodec copy $FILE2.avi
	zenity --info \
	--text "Animated desktop \"$FILE\" and \"$FILE2\" convert!";;
                 1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
                -1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
        esac
;;

"flv2avi_3") 
FILE=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE2=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE3=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
        case $? in
                 0)
                        ffmpeg -i $FILE -b 256000 -f avi -vcodec copy -acodec copy $FILE.avi
			ffmpeg -i $FILE2 -b 256000 -f avi -vcodec copy -acodec copy $FILE2.avi
			ffmpeg -i $FILE3 -b 256000 -f avi -vcodec copy -acodec copy $FILE3.avi
	zenity --info \
	--text "Animated desktop \"$FILE\" and \"$FILE2\" and \"$FILE3\" convert!";;
                 1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
                -1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
        esac
;;

"flv2avi_4") 
FILE=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE2=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE3=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE4=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
        case $? in
                 0)
                        ffmpeg -i $FILE -b 256000 -f avi -vcodec copy -acodec copy $FILE.avi
			ffmpeg -i $FILE2 -b 256000 -f avi -vcodec copy -acodec copy $FILE2.avi
			ffmpeg -i $FILE3 -b 256000 -f avi -vcodec copy -acodec copy $FILE3.avi
			ffmpeg -i $FILE4 -b 256000 -f avi -vcodec copy -acodec copy $FILE4.avi
	zenity --info \
	--text "Animated desktop \"$FILE\" and \"$FILE2\" and \"$FILE3\" and \"$FILE4\" convert!";;
                 1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
                -1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
        esac
;;

"flv2avi_5") 
FILE=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE2=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE3=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE4=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE5=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
        case $? in
                 0)
                        ffmpeg -i $FILE -b 256000 -f avi -vcodec copy -acodec copy $FILE.avi
			ffmpeg -i $FILE2 -b 256000 -f avi -vcodec copy -acodec copy $FILE2.avi
			ffmpeg -i $FILE3 -b 256000 -f avi -vcodec copy -acodec copy $FILE3.avi
			ffmpeg -i $FILE4 -b 256000 -f avi -vcodec copy -acodec copy $FILE4.avi
			ffmpeg -i $FILE5 -b 256000 -f avi -vcodec copy -acodec copy $FILE5.avi
	zenity --info \
	--text "Animated desktop \"$FILE\" and \"$FILE2\" and \"$FILE3\" and \"$FILE4\" and \"$FILE5\" convert!";;
                 1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
                -1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
        esac
;;

"avimerge2") 
FILE=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE2=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`

        case $? in
                 0)
                        avimerge -i $FILE $FILE2 -o ~/merged.avi
	zenity --info \
	--text "Animated desktop \"$FILE\" and \"$FILE2\" merged!";;
                 1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
                -1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
        esac
;;

"avimerge3") 
FILE=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE2=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE3=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`

        case $? in
                 0)
                        avimerge -i $FILE $FILE2 $FILE3 -o ~/merged.avi
	zenity --info \
	--text "Animated desktop \"$FILE\" and \"$FILE2\" and \"$FILE3\" merged!";;
                 1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
                -1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
        esac
;;

"avimerge4") 
FILE=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE2=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE3=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE4=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`

        case $? in
                 0)
                        avimerge -i $FILE $FILE2 $FILE3 $FILE4 -o ~/merged.avi
	zenity --info \
	--text "Animated desktop \"$FILE\" and \"$FILE2\" and \"$FILE3\" and \"$FILE4\" merged!";;
                 1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
                -1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
        esac
;;

"avimerge5") 
FILE=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE2=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE3=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE4=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`
FILE5=`zenity --file-selection --title "flv2avi 2.0 by r0ot" --window-icon="/usr/local/share/gflv2avi/a-desk64x64.png"`

        case $? in
                 0)
                        avimerge -i $FILE $FILE2 $FILE3 $FILE4 $FILE5 -o ~/merged.avi
	zenity --info \
	--text "Animated desktop \"$FILE\" and \"$FILE2\" and \"$FILE3\" and \"$FILE4\" and \"$FILE5\" merged!";;
                 1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
                -1)
        zenity --info \
	--text "Animated desktop CANCEL!";;
        esac
;;
esac
