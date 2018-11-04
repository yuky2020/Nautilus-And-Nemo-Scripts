#!/bin/bash
#sample script to start a program, permit it to run for a predefined amount of wallclock time, then kill it.  Specify time in seconds
#
progID=$(zenity --entry --text="What is the desired program you would like to run?")
$progID &
mypid=`eval ps ax|grep "$progID"|grep -iv "grep"| awk '{print $1}'`
echo "mypid $mypid"
mins=0
secs=0
killmins=$(zenity --entry --text="How long would you like it to run? (in seconds)")
startsecs=`eval date +%-S `
starthours=`eval date +%-H`
startmins=`eval date +%-M`

#echo "startsecs=$startsecs starthours=$starthours startmins=$startmins"

while [ $secs -lt $killmins ]; do
    cursecs=`eval date +%-S `
    curhours=`eval date +%-H`
    curmins=`eval date +%-M`
    echo "Aval..."
    secs=$(( (curhours-starthours)*3600 + (curmins-startmins)*60 - startsecs + cursecs ))
    echo "Secs: $secs"
    sleep 1
done
kill "$mypid"
if [ $? -eq 0 ]; then
    echo "Process $mypid was killed"
fi
