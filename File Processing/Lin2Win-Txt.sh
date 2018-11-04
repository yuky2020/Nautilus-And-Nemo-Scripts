#!/bin/bash
(while [ $# -gt 0 ]; do
 sed -e 's/$/\r/' "$1" > "$1".txt
shift
done)

