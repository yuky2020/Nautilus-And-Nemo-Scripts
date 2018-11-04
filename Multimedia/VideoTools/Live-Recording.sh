#!/bin/bash

trap 'pkill -ALRM cat;echo;exit' SIGINT 

while getopts "t:b:v:p:hS" options; do
  case $options in
    t ) time=$OPTARG;;
    b ) bps=$OPTARG;;
    v ) dev=$OPTARG;;
    h ) help=1;;
    S ) shtdwn=1;;
    ? ) echo $usage
        exit 1;;
  esac
done

shift $(($OPTIND - 1))
fname=$1

if  [ $# -eq 0 ] || [ $help ]
then
  printf "Usage: [options] filename

  Optional Arguments:
     -h help
     -t (time) recording time h:mm
     -b (mbps) megabits per secound 
     -v (n) video device index
     -S shutdown and poweroff when finished\n\n"
  exit
fi

if [ $dev ] 
then 
  index=$dev
else
  index=0  # DEFAULT
fi

if [ $bps ]
then
    if [ $bps -gt 13 ]
    then
       bitrate=13500000
       echo 'MAX BITRATE SET'
    else
       bitrate=$(($bps*1000000))
    fi
    v4l2-ctl --device=/dev/video$index --set-ctrl=video_bitrate=$bitrate
    sleep .2
    v4l2-ctl --device=/dev/video$index -l
    sleep .2
fi

# EXECUTABLE STATEMENT
cat /dev/video$index > $fname &

if [ $time ]
then
  mins=${time:2}
  hours=${time:0:1}
  mins=$((mins+$hours*60))
  echo $mins
  echo
# NOTE SUDOERS FILE MUST BE ADJUSTED FOR THIS TO WORK
  if [ $shtdwn ]
  then
    sudo shutdown -P +$(($mins+10)) & 
    sleep 1 # GIVE TIME FOR SHUTDOWN NOTICE
  fi

  printf "\nDone    time left      avg bps           est size          cur size\n"  
  for ((t=1; t <= $mins ; t++))
  do
    sleep 1m
    size=`du -b $fname`
    size=`expr match "$size" '\([0-9]*\)'`    
    printf "(%3d%s) %3d%s     %9d bps        ~%4d MB     %9d MB\r" "$((100*t/$mins))" "%" "$(($mins-t))" " mins" "$((8*size/(t*60)))" "$(($mins*size/(t*1024*1024)))" "$((size/(1024*1024)))"
  done                           # A construct borrowed from 'ksh93'.
  pkill -ALRM cat

fi
echo
