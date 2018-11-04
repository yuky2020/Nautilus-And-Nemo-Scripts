#!/bin/bash

if [ "$#" -ne "1" ]; then
	echo "Usage: $0 archive name"
	exit 0
else
FILE=$1
extension=`echo "${FILE##*.}"`


  case $extension in 

 gz)
     if [ -f /bin/tar ]; then 
  echo -e "Extension is $extension ...\nProceed with extraction in `pwd`"
  tar -xzvf $1
     else
    echo -e "Tar extractor not instaled on your system...\nProcced with installation..."
 sudo apt-get install tar
   fi
  
;;

 rar)

     if [ -f /usr/bin/unrar ]; then 
  echo -e "Extension is $extension ...\nProceed with extraction in `pwd`"
  unrar x $1
     else
    echo -e "Unrar extractor not instaled on your system...\nProcced with installation..."
 sudo apt-get install unrar
   fi
;;

  zip)

     if [ -f /usr/bin/unzip ]; then 
  echo -e "Extension is $extension ...\nProceed with extraction in `pwd`"
  unzip $1
     else
    echo -e "Unzip extractor not instaled on your system...\nProcced with installation..."
 sudo apt-get install unzip
   fi
;;

 bz2)

    if [ -f /bin/tar ]; then 
  echo -e "Extension is $extension ...\nProceed with extraction in `pwd`"
  tar xfjv $1
     else
    echo -e "tar extractor not instaled on your system...\nProcced with installation..."
 sudo apt-get install tar
   fi
;;                          

 7z)
    if [ -f /usr/bin/7zr ]; then 
  echo -e "Extension is $extension ...\nProceed with extraction in `pwd`"
  7zr x $1
     else
    echo -e "7zr extractor not instaled on your system...\nProcced with installation..."
 sudo apt-get install p7zip-full p7zip-rar
   fi
;;


 xz)
      if [ -f /usr/bin/xz ]; then 
  echo -e "Extension is $extension ...\nProceed with extraction in `pwd`"
  tar xvfJ $1
     else
    echo -e "7zr extractor not instaled on your system...\nProcced with installation..."
 sudo apt-get install tar
   fi
;;

 lzma)
      if [ -f /usr/bin/lzma ]; then 
  echo -e "Extension is $extension ...\nProceed with extraction in `pwd`"
  tar --lzma -xvf $1
     else
    echo -e "7zr extractor not instaled on your system...\nProcced with installation..."
 sudo apt-get install lzma
   fi
;;

 exe)
      if [ -f /usr/bin/7z ]; then 
  echo -e "Extension is $extension ...\nProceed with extraction in `pwd`"
  7z e $1
     else
    echo -e "7z extractor not instaled on your system...\nProcced with installation..."
 sudo apt-get install p7zip-full p7zip-rar
   fi
;;


 jar)
      if [ -f /usr/bin/unzip ]; then 
  echo -e "Extension is $extension ...\nProceed with extraction in `pwd`"
  unzip $1
     else
    echo -e "Unzip extractor not instaled on your system...\nProcced with installation..."
 sudo apt-get install unzip
   fi
;;

 tar)
      if [ -f /bin/tar ]; then 
  echo -e "Extension is $extension ...\nProceed with extraction in `pwd`"
  tar -xf $1
     else
    echo -e "Unzip extractor not instaled on your system...\nProcced with installation..."
 sudo apt-get install tar
   fi
;;

  *)
	echo "Unknown extension $extension "
;;
esac
	










fi


