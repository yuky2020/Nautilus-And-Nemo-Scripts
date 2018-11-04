#!/bin/bash

#Autore script: Mattia Castiglione
#Sito: http://c2asr.altervista.org

cartella=`basename "$*"`
direc="$PWD/$cartella"

namweb=$(ls /dev/video*);

vformat="avi";

device=$(zenity --entry --text "Insert the name of webcam(default: video0)\nPossible device name:\n$namweb\nYou can change device from script menu" --entry-text "video0");

while true; do


action=$(zenity --list --width 400 --height 310 --title "WebCam Manager" --text " Choose action:" --radiolist --column="Pick" --column="Action" FALSE "Show video"   TRUE "Record video" FALSE "Record Audio + Video" FALSE "Spy Rec" FALSE "Choose video Format" FALSE "Change device" FALSE "Info"  FALSE "Exit manager");

case "$action" in
  "Show video")
	
	ffplay -f video4linux2 -b 2000000 -s 320x240 /dev/$device
	zenity --info --title="WebRec Manager"  --text "If video don't start change device from menù."

     ;;


  "Record video")
          resolution=$(zenity  --list --width 200 --height 250 --text " Choose Video Resolution:" --radiolist  --column "Pick" --column "Resolution" TRUE "320x240"  FALSE "640x480" FALSE "hd480" FALSE "hd720" FALSE "hd1080");


framerate=$(zenity --scale --text "Choose video framerate(default: 15)" --min-value=10 --max-value=30 --value=15 --step 1);

bi=$(zenity --scale --text "Choose video quality" --min-value=1 --max-value=5 --value=1 --step 2);

bitrate=$bi*1000000


exec xterm -T "Log webrec" -e ffmpeg -y -f video4linux2 -s $resolution -r $framerate -i /dev/$device -b $bitrate video.$vformat &  zenity --info --title="WebRec Manager"  --text "WebCam video recorder strated!\nClic on OK to stop recording"


pkill xterm

if $(zenity --question --title="WebRec Manager"  --text "Show registration?");
	then mplayer video.$vformat
	zenity --info --title="WebRec Manager"  --text "Recording made successfully, you can find the video in $direc \nIf you have problem with record change device from menù!";
else
	zenity --info --title="WebRec Manager"  --text "Recording made successfully, you can find the video in $direc \nIf you have problem with record change device from menù!";
fi


     ;;

 "Record Audio + Video")
     resolution=$(zenity  --list --width 200 --height 250 --text " Choose Video Resolution:" --radiolist  --column "Pick" --column "Resolution" TRUE "320x240"  FALSE "640x480" FALSE "hd480" FALSE "hd720" FALSE "hd1080");


framerate=$(zenity --scale --text "Choose video framerate(default: 15)" --min-value=10 --max-value=30 --value=15 --step 1);

bi=$(zenity --scale --text "Choose video quality" --min-value=1 --max-value=5 --value=1 --step 2);

bitrate=$bi*1000000


exec xterm -T "Log webrec" -e ffmpeg -y -f alsa -ac 2 -i hw:0,0 -f video4linux2 -s $resolution -r $framerate -i /dev/$device -acodec libmp3lame -ar 44100 -ab 128k -b $bitrate video.avi &  zenity --info --title="WebRec Manager"  --text "WebCam video recorder strated!\nClic on OK to stop recording"


pkill xterm

if $(zenity --question --title="WebRec Manager"  --text "Show registration?");
	then mplayer video.avi
	zenity --info --title="WebRec Manager"  --text "Recording made successfully, you can find the video in $direc \nIf you have problem with record change device from menù!";
else
	zenity --info --title="WebRec Manager"  --text "Recording made successfully, you can find the video in $direc \nIf you have problem with record change device from menù!";
fi


     ;;

	"Spy Rec") 
		ffmpeg -y -f video4linux2 -s 320x240 -r 30 -i /dev/$device -b 1000000 video.$vformat & zenity --info --title="WebRec Manager"  --text "Clic on notification to stop Spy Rec" & zenity --notification --window-icon="" --text="Spy Rec..." 
	pkill ffmpeg

	;;

	  "Choose video Format")

     		vformat=$(zenity  --list  --text " Choose Video Format:" --radiolist  --column "Pick" --column "Format" TRUE "avi"  FALSE "ogg");

	;;

	"Change device") 
		device=$(zenity --entry --text "Insert the name of webcam(Now is: $device)\nPossible device name:\n$namweb" --entry-text "video0");
	;;
	
	"Info") 
	export DEMO_TXT="<b>WebCamRec</b>\\nThis script is a simple webcam manager\\n\\n<b>Author:</b>Mattia Castiglione\\n<b>Site:</b> <a href = \"http://c2asr.altervista.org/?a=webcamrec\">http://casr.altervista.org</a>"
		zenity --info --title="WebRec Manager"  --text "$DEMO_TXT"
	;;

	"Exit Manager")
		action=*
	;;

	*)

	break
	;;
	
esac
done
