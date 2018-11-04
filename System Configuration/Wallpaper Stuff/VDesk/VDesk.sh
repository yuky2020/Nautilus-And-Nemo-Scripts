#!/bin/bash

##################################################
#             VDesk - Visual Desktop             #
#                                                #
# Title: VDesk - Visual Desktop                  #
# Version: 1.3                                   #
#                                                #
#                                                #
#                                                #
#            Authors and Contributors            #
#                                                #
# Lead Writer: ~ |Anthony|                       #
#     TechTweakerz@comcast.net                   #
#     http://www.craigslistdecoded.com           #
#                                                #
# Assistant Programmer: ~ Anthony Nordquist      #
#     salinelinux@gmail.com                      #
#     http://www.salineos.com                    #
#                                                #
#                                                #
#                                                #
#                 VDesk Licensing                #
#                                                #
# - DO NOT REMOVE ANY COMMENTS FROM VDESK        #
# - YOU ARE PROHIBITED FROM REDISTRIBUTING       #
#   VDESK - VISUAL DESKTOP                       #
# - YOU ARE PROHIBITED FROM MODIFYING VDESK -    #
#   VISUAL DESKTOP IN ANY WAY                    #
#                                                #
##################################################

UserName=$(whoami)
VIDEO_DIR="$HOME/.gnome2/nemo-scripts/System Configuration/Wallpaper Stuff/VDesk"

#################################################
#               Initiate Functions              #

video() {
  dir=$(grep -B 0  "vid_dir=" $VIDEO_DIR/.config | awk -F "=" '{print $2}')
  vopac=$(grep -B 0  "vid_opac=" $VIDEO_DIR/.config | awk -F "=" '{print $2}')
  left=${vopac%??} right=${vopac:(-2)} opac=$left.$right
  vol=$(grep -B 0  "vol=" $VIDEO_DIR/.config | awk -F "=" '{print $2}')
  mprofile_state=$(grep -B 0  "mprofile_state=" $VIDEO_DIR/.config | awk -F "=" '{print $2}')
  list_files
  killall xwinwrap
  rm /tmp/mplayer-control
  mkfifo /tmp/mplayer-control
  if [ "$mprofile_state" = "FALSE" ] ; then
    xwinwrap -ni -o "$opac" -fs -s -st -sp -b -nf -- mplayer -volume $vol -slave -input file=/tmp/mplayer-control -wid WID -really-quiet "$dir/$file" -loop 0 & initiate
  elif [ "$mprofile_state" = "TRUE" ] ; then
    mprofile=$(grep -B 0  "mprofile=" $VIDEO_DIR/.config | awk -F "=" '{print $2}')
    xwinwrap -ni -o "$opac" -fs -s -st -sp -b -nf -- mplayer -profile "$mprofile" -volume $vol -slave -input file=/tmp/mplayer-control -wid WID -really-quiet "$dir/$file" -loop 0 & initiate
  fi
  exit
}

screen_saver() {
  dir=$(grep -B 0  "ss_dir=" $VIDEO_DIR/.config | awk -F "=" '{print $2}')
  sopac=$(grep -B 0  "ss_opac=" $VIDEO_DIR/.config | awk -F "=" '{print $2}')
  left=${sopac%??} right=${sopac:(-2)} opac=$left.$right
  list_files
  killall xwinwrap
  xwinwrap -ni -argb -fs -s -o "$opac" -st -sp -nf -b -- "$dir/$file" -root -window-id WID & initiate
  exit
}

stop() {
  killall xwinwrap
  rm /tmp/mplayer-control
  initiate
}

#################################################

#################################################
#            Video Options Functions            #

set_vol() {
  vol_lev=$(zenity --scale \
    --window-icon="/usr/share/pixmaps/vdesk.png" \
    --title="VDesk - Visual Desktop" \
    --text="Adjust in-play volume" \
    --min-value=0 \
    --max-value=100 \
    --step=1 \
    --value="$vol")
  case $? in
    0)
      echo "set_propert volume " $vol_lev > /tmp/mplayer-control ;;
    1)
      vol_lev=$vol ;;
  esac
}

mute() {
  echo "mute" > /tmp/mplayer-control
}

pause() {
  echo "pause" > /tmp/mplayer-control
}

track() {
  echo "switch_audio" > /tmp/mplayer-control
}

#################################################

#################################################
#              Video Options Dialog             #

vidopt_exit() {
  if [ "$vidopt" = "Set Volume" ] ; then
    set_vol ;
    initiate ;
    elif [ "$vidopt" = "Mute / Unmute" ] ; then
      mute ;
      video_options ;
    elif [ "$vidopt" = "Pause / Unpause" ] ; then
      pause ;
      video_options ;
    elif [ "$vidopt" = "Change Track" ] ; then
      track ;
      video_options ;
  fi
}

video_options() {
  vidopt=$(zenity --list \
     --window-icon="/usr/share/pixmaps/vdesk.png" \
    --title="VDesk - Visual Desktop" \
    --text="Change your in-play settings" \
    --width="220" \
    --height="250" \
    --column="Options" \
    "Set Volume" \
    "Mute / Unmute" \
    "Pause / Unpause" \
    "Change Track")
  case $? in
    0)
      vidopt_exit
  ;;
    1)
      initiate
  ;;
    -1)
      zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title "Unexpected Error" --text "Something AwFuL Happened!"
      exit
  ;;
    5)
      zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title "VDesk Timeout" --text "Come Back When You're Ready!"
      exit
  ;;
  esac
}
#################################################


#################################################
#           Directory Selection Dialog          #

get_dir() {
  dir=""
  dir=$(zenity --file-selection \
    --window-icon="/usr/share/pixmaps/vdesk.png" \
    --filename=$HOME/$UserName \
    --title="VDesk - Visual Desktop ~ Select your $dir_type folder" \
    --directory)
  case $? in
    0)
      zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title "VDesk - Visual Desktop" --text "$dir_type Directory set to: $dir"
  ;;
    1)
      config_dialog
  ;;
    -1)
      zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title "VDesk - Visual Desktop" --text "Something AwFuL Happened!\nHit OK to close"
      exit
  ;;
    5)
      zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title "VDesk Timeout" --text "Come Back When You're Ready!"
      exit
  ;;
  esac
}

#        End Directory Selection Dialog         #
#################################################


#################################################
#     Open File Selection based on initiate     #


list_files() {
  files="" #need to clear $files or else the list grows and grows
  for i in $(ls "$dir"); do
    if [ -f "$dir/$i" ]; then
      files="$files $i"
    fi
  done

  file=$(zenity --list \
    --window-icon="/usr/share/pixmaps/vdesk.png" \
    --title="VDesk - Visual Desktop" \
    --text="Select Your Background" \
    --width="220" \
    --column="Options" \
    $files)
  case $? in
    0)
      echo "" > /dev/null
  ;;
    1)
      initiate
  ;;
    -1)
      zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title "Unexpected Error" --text "Something AwFuL Happened!"
      exit
  ;;
    5)
      zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title "VDesk Timeout" --text "Come Back When You're Ready!"
      exit
  ;;
  esac
}

#################################################

#################################################
#              Auto Start Dialogs               #

activate() {
  state=$(grep -B 0  "X-GNOME-Autostart-enabled=" "$HOME/.config/autostart/VDesk.desktop" | awk -F "=" '{print $2}') ;
  type=$(grep -B 0  "auto_start_type=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
  cfile=$(grep -B 0  "auto_start_file=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
  ans=$(zenity --question --window-icon="/usr/share/pixmaps/vdesk.png" --title="VDesk - Visual Desktop" --text="Your current Auto Start $type is:\n$cfile.\n\nWould you like to change this?") ;
  case $? in
    0)
      ans=$(zenity --list \
        --window-icon="/usr/share/pixmaps/vdesk.png" \
        --title="VDesk - Visual Desktop" \
        --text="Auto Start Options" \
        --column="" \
        "Video" \
        "Screen Saver")
      case $? in
        0)
          if [ "$ans" = "Video" ] ; then
            dir=$(grep -B 0  "vid_dir=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
            list_files ;
            sed -i -e "s|X-GNOME-Autostart-enabled=$state|X-GNOME-Autostart-enabled=true|g" $HOME/.config/autostart/VDesk.desktop ;
            sed -i -e "s|auto_start_type=$type|auto_start_type=Video|g" $VIDEO_DIR/.config ;
            sed -i -e "s|auto_start_file=$cfile|auto_start_file=$dir/$file|g" $VIDEO_DIR/.config ;
            zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title="VDesk - Visual Desktop" --text="~~ Auto Start Activated ~~\n\nVDesk will now start when you login.\nEnjoy!" ;
            initiate ;
          elif [ "$ans" = "Screen Saver" ] ; then
            dir=$(grep -B 0  "ss_dir=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
            list_files ;
            sed -i -e "s|X-GNOME-Autostart-enabled=$state|X-GNOME-Autostart-enabled=true|g" $HOME/.config/autostart/VDesk.desktop ;
            sed -i -e "s|auto_start_type=$type|auto_start_type=Screen Saver|g" $VIDEO_DIR/.config ;
            sed -i -e "s|auto_start_file=$cfile|auto_start_file=$dir/$file|g" $VIDEO_DIR/.config ;
            zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title="VDesk - Visual Desktop" --text="~~ Auto Start Activated ~~\n\nVDesk will now start when you login.\nEnjoy!" ;
            initiate ;
          fi
        ;;
        1)
          auto_start
        ;;
      esac
    ;;
    1)
      sed -i -e "s|X-GNOME-Autostart-enabled=$state|X-GNOME-Autostart-enabled=true|g" $HOME/.config/autostart/VDesk.desktop
      zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title="VDesk - Visual Desktop" --text="~~ Auto Start Activated ~~\n\nVDesk will now start when you login.\nEnjoy!"
      initiate
    ;;
  esac
}

auto_start_exit() {
  if [ $auto = "Activate" ] ; then
    activate ;
  elif [ $auto = "Deactivate" ] ; then
    state=$(grep -B 0  "X-GNOME-Autostart-enabled=" "$HOME/.config/autostart/VDesk.desktop" | awk -F "=" '{print $2}') ;
    sed -i -e "s|X-GNOME-Autostart-enabled=$state|X-GNOME-Autostart-enabled=false|g" $HOME/.config/autostart/VDesk.desktop ;
    zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title="VDesk - Visual Desktop" --text="~~ Auto Start Deactivated ~~\n\nVDesk will not start when you login." ;
    initiate ;
  fi
}

auto_start() {
  auto=$(zenity --list \
    --window-icon="/usr/share/pixmaps/vdesk.png" \
    --title="VDesk - Visual Desktop" \
    --text="~~ Auto Start Options ~~" \
    --width="220" \
    --column="" \
    "Activate" \
    "Deactivate")
  case $? in
    0)
      if [ ! -e "$HOME/.config/autostart/VDesk.desktop" ] ; then
        cat > "$HOME/.config/autostart/VDesk.desktop" <<FOO
[Desktop Entry]
Name=VDesk
Version=1
Type=Application
Exec="$VIDEO_DIR/.auto-start.sh"
Terminal=false
Icon=/usr/share/pixmaps/VDesk.png
Comment=Something to make your M$ friends jealous.
Categories=AudioVideo;Video;
X-GNOME-Autostart-enabled=false

FOO
        zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title="VDesk - Visual Desktop" --text="This is your first time using Auto Start.\nAn auto start file has been created for you." ;
      fi
      auto_start_exit ;
  ;;
    1)
      config_dialog
  ;;
    -1)
      zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title "Unexpected Error" --text "Something AwFuL Happened!"
      exit
  ;;
    5)
      zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title "VDesk Timeout" --text "Come Back When You're Ready!"
      exit
  ;;
  esac
}

#            End Auto Start Dialogs             #
#################################################

#################################################
#             Configuration Dialogs             #

reset_config() {
  reset=$(zenity --question \
    --window-icon="/usr/share/pixmaps/vdesk.png" \
    --title="VDesk - Visual Desktop" \
    --text="This will reset ALL of your Configuration Settings!\n\n\nAre you sure you want to reset you Configuration?")
  case $? in
    0)
      rm -rf $VIDEO_DIR/.config
      rm -rf ~/.config/autostart/VDesk.desktop
    ;;
    1)
      config_dialog
    ;;
  esac
}

s_opac() {
  ss_opac=$(grep -B 0  "ss_opac=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
  sopac=$(zenity --scale \
    --window-icon="/usr/share/pixmaps/vdesk.png" \
    --title="VDesk - Visual Desktop" \
    --text="Set Your Screen Saver Transparency" \
    --min-value=10 \
    --max-value=100 \
    --step=1 \
    --value="$ss_opac")
  case $? in
    0)
      sed -i -e "s|ss_opac=$ss_opac|ss_opac=$sopac|g" $VIDEO_DIR/.config
    ;;
    1)
      config_dialog
    ;;
  esac
}

v_opac() {
  vid_opac=$(grep -B 0  "vid_opac=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
  vopac=$(zenity --scale \
    --window-icon="/usr/share/pixmaps/vdesk.png" \
    --title="VDesk - Visual Desktop" \
    --text="Set Your Video Transparency" \
    --min-value=10 \
    --max-value=100 \
    --step=1 \
    --value="$vid_opac")
  case $? in
    0)
      sed -i -e "s|vid_opac=$vid_opac|vid_opac=$vopac|g" $VIDEO_DIR/.config
    ;;
    1)
      config_dialog
    ;;
  esac
}

mplayer_profile() {
  mprofile_state=$(grep -B 0  "mprofile_state=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
  profile_state=$(zenity --list \
    --window-icon="/usr/share/pixmaps/vdesk.png" \
    --title="VDesk - Visual Desktop" \
    --text="~~ Mplayer Profile ~~" \
    --width="220" \
    --column="" \
    "Activate" \
    "Deactivate")
  case $? in
    0)
      if [ "$profile_state" = "Activate" ] ; then
        mprofile=$(grep -B 0  "mprofile=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
        profile=$(zenity --entry --window-icon="/usr/share/pixmaps/vdesk.png" --title="VDesk - Visual Desktop" --text="Enter the name your Mplayer Profile\n\nDO NOT Leave Field Blank!" --entry-text="$mprofile" )
        case $? in
          0)
            sed -i -e "s|mprofile_state=$mprofile_state|mprofile_state=TRUE|g" $VIDEO_DIR/.config ;
            sed -i -e "s|mprofile=$mprofile|mprofile=$profile|g" $VIDEO_DIR/.config ;
          ;;
          1)
            config_dialog
          ;;
        esac
      elif [ "$profile_state" = "Deactivate" ] ; then
        sed -i -e "s|mprofile_state=$mprofile_state|mprofile_state=FALSE|g" $VIDEO_DIR/.config ;
      fi
      ;;
    1)
      config_dialog
    ;;
  esac
}

conf_exit() {
  if [ "$conf_sel" = "Video Directory" ] ; then
    dir_type=$"Video" ;
    vid_dir=$(grep -B 0  "vid_dir=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
    get_dir ;
    sed -i -e "s|vid_dir=$vid_dir|vid_dir=$dir|g" $VIDEO_DIR/.config ;
    config_dialog ;
  elif [ "$conf_sel" = "Screen Saver Directory" ] ; then
    dir_type=$"Screen Saver" ;
    ss_dir=$(grep -B 0  "ss_dir=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
    get_dir ;
    sed -i -e "s|ss_dir=$ss_dir|ss_dir=$dir|g" $VIDEO_DIR/.config ;
    config_dialog ;
  elif [ "$conf_sel" = "Video Transparency" ] ; then
    v_opac ;
    config_dialog ;
  elif [ "$conf_sel" = "Screen Saver Transparency" ] ; then
    s_opac ;
    config_dialog ;
  elif [ "$conf_sel" = "Mplayer Profile" ] ; then
    mplayer_profile ;
    config_dialog ;
  elif [ "$conf_sel" = "Default Volume" ] ; then
    set_vol ;
    sed -i -e "s|vol=$vol|vol=$vol_lev|g" $VIDEO_DIR/.config ;
    vol="$vol_lev" ;
    config_dialog ;
  elif [ "$conf_sel" = "Auto Start" ] ; then
    auto_start ;
  elif [ "$conf_sel" = "Reset to Defaults" ] ; then
    reset_config ;
  fi
}

config_dialog() {
  conf_sel=$(zenity --list \
    --window-icon="/usr/share/pixmaps/vdesk.png" \
    --title="VDesk - Visual Desktop" \
    --text="~~ Configuration Options ~~" \
    --height="280" \
    --width="225" \
    --column="" \
    "Video Directory" \
    "Screen Saver Directory" \
    "Video Transparency" \
    "Screen Saver Transparency" \
    "Mplayer Profile" \
    "Default Volume" \
    "Auto Start" \
    "Reset to Defaults")
  case $? in
    0)
      conf_exit
  ;;
    1)
      initiate
  ;;
    -1)
      zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title "Unexpected Error" --text "Something AwFuL Happened!"
      exit
  ;;
    5)
      zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title "VDesk Timeout" --text "Come Back When You're Ready!"
      exit
  ;;
  esac
}

#           End Configuration Dialogs           #
#################################################


#################################################
#        Create Default Configuration file      #

default_config() {
  if [ -f $VIDEO_DIR/.config ]; then
    vid_dir=$(grep -B 0  "vid_dir=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
    ss_dir=$(grep -B 0  "ss_dir=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
    vid_opac=$(grep -B 0  "vid_opac=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
    ss_opac=$(grep -B 0  "ss_opac=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
    vol=$(grep -B 0  "vol=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
    echo $vid_dir $ss_dir $vid_opac $ss_opac $vol ;
  else
    zenity --info --window-icon="/usr/share/pixmaps/vdesk.png" --title "VDesk - Visual Desktop" --text 'Welcome to VDesk - Visual Desktop!\n\nSince this is your first time using VDesk, a Default\nConfiguration file has been created for you. It is\nsuggested that you go to the Configuration Tab first\nso that you can select the directories where your\nVideos and Screen Savers are stored.\n\nThank you for using VDesk and Enjoy!' ;
    cat > $VIDEO_DIR/.config <<FOO
vid_dir=$HOME/Videos
ss_dir=/usr/lib/xscreensaver
vid_opac=100
ss_opac=100
mprofile_state=FALSE
mprofile=NULL
vol=100
auto_start_type=NULL
auto_start_file=NULL

FOO
  fi
}

#           End create default config           #
#################################################

#################################################
#        Initiate VDesk - Visual Desktop        #

init_exit() {
  if [ "$init" = "Play Video" ] ; then
    video ;
  elif [ "$init" = "Screen Saver" ] ; then
    screen_saver ;
  elif [ "$init" = "Stop" ] ; then
    stop ;
  elif [ "$init" = "Video Options" ] ; then
    video_options ;
  elif [ "$init" = "Configuration" ] ; then
    config_dialog ;
  fi
}

initiate() {
  init=$(zenity --list \
    --title="VDesk - Visual Desktop" \
    --window-icon="/usr/share/pixmaps/vdesk.png" \
    --text="~~ VDesk Control Center ~~" \
    --height="270" \
    --width="220" \
    --column="" \
    "Play Video" \
    "Screen Saver" \
    "Stop" \
    "Video Options" \
    "Configuration")
  case $? in
    0)
      init_exit
  ;;
    1)
      zenity --info --title "VDesk - Visual Desktop" --window-icon="/usr/share/pixmaps/vdesk.png" --timeout=1 --text "Thank you for using VDesk!"
      exit
  ;;
    -1)
      zenity --info --title "Unexpected Error" --window-icon="/usr/share/pixmaps/vdesk.png" --text "Something AwFuL Happened!"
      exit
  ;;
    5)
      zenity --info --title "VDesk Timeout" --window-icon="/usr/share/pixmaps/vdesk.png" --text "Come Back When You're Ready!"
      exit
  ;;
  esac
}

default_config
initiate

###########4############2############0###########

