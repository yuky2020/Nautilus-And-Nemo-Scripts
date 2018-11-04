#!/bin/bash

if [ $# == 2 ] ; then

sleep $1
nohup 2>/dev/null 1>/dev/null $2 &

else

echo "Usage: $0 delay command"

fi
exit
