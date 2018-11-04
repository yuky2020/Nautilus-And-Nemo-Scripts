#!/bin/bash
iconv -f WINDOWS-1251 -t UTF-8 $1 > ./utf8_$1
