#!/bin/bash
# BY: Dart00

echo "# "

# =============================================================================================================
# Declear Critical Varables:
TPUT_BOLD="tput bold"
TPUT_CLEAR="tput sgr0"
TPUT_RED="tput setf 4"
TPUT_GREEN="tput setf 2"
TPUT_YELLOW="tput setf 6"

# =============================================================================================================
# Display Welcome:
echo -n "# "
$TPUT_GREEN
$TPUT_BOLD
echo "***********************************"
$TPUT_CLEAR
echo -n "# "
$TPUT_GREEN
$TPUT_BOLD
echo -n "* "
$TPUT_CLEAR
$TPUT_BOLD
echo -n "Welcome To the Win2-Downloader!"
$TPUT_GREEN
echo " *"
$TPUT_CLEAR
echo -n "# "
$TPUT_GREEN
$TPUT_BOLD
echo "***********************************"

$TPUT_CLEAR

echo "# "

# =============================================================================================================
# Declare Critical Functions:

function STATUSCHECK {

if ! [ "$?" = "0" ]; then
   STATUS="FAIL"
fi

		}

function DISPLAYSTATUS {
(( SPACE = (55 - `cat /tmp/status.tmp | wc -m`) ))
tput cuf $SPACE
$TPUT_BOLD
echo -n "[ "
if ! [[ `cat /etc/issue` =~ "PCLinuxOS" ]]; then
if [ "$WARN" = "YES" ]; then
   $TPUT_YELLOW
   echo -n "WARN"
   else
   if [ "$STATUS" = "FAIL" ] || [ "$FAIL" = "YES" ]; then
      $TPUT_RED
      echo -n "FAIL"
      ERRORS="YES"
   else
      $TPUT_GREEN
      echo -n " OK "
   fi
fi
$TPUT_CLEAR
$TPUT_BOLD
   echo " ]"
$TPUT_CLEAR
else
if [ "$WARN" = "YES" ]; then
   echo -n "WARN"
   else
   if [ "$STATUS" = "FAIL" ] || [ "$FAIL" = "YES" ]; then
      echo -n "FAIL"
      ERRORS="YES"
   else
      echo -n " OK "
   fi
fi
   echo " ]"
   $TPUT_CLEAR
fi

STATUS=""
SPACE=""
WARN=""
FAIL=""
		}

# =============================================================================================================
# Assign Langauge:

case "$LANG" in
  fr* )
echo -n "# DÃ©tection automatique du langage..."  | tee /tmp/status.tmp
	     ;;
  es* )
echo -n "# Autodetectando Idioma..."  | tee /tmp/status.tmp
	     ;;
  * ) 
echo -n "# Auto Detecting Language..."  | tee /tmp/status.tmp
           ;;
esac

case "$LANG" in
  fr* )
     WORD1="Initialisation des variables..."
     WORD2="Initialisation des fonctions..."
     WORD3="Script Annulé !"
     WORD4="Pressez [ ENTREE ] pour terminer..."
     WORD5="Script Annulé !"
     WORD6="Test de la connexion Internet..."
     WORD7="Choix de la version :"
     WORD8="Veuillez sélectionner une type de version :"
     WORD9="Versions disponibles :"
     WORD10="Versions finales"
     WORD11="Versions Bêtas"
     WORD12="Téléchargement de la liste des versions finales disponibles..."
     WORD13="Téléchargement de la liste des versions Bêtas disponibles..."
     WORD14="Tri de la liste des versions..."
     WORD15="Génération du menu dynamique..."
     WORD16="Versions Bêtas :"
     WORD17="Veuillez sélectionner :"
     WORD18="Choix :"
     WORD19="Version Beta :"
     WORD20="Téléchargement de la version finale sélectionnée..."
     WORD21="Téléchargement de la version Bêta sélectionnée..."
     WORD22="Operation terminée !"
	     ;;
  es* )
     WORD1="Inicializando Variables..."
     WORD2="Inicializando Funciones..."
     WORD3="¡Script Cancelado!"
     WORD4="Presiona [ ENTER ] para cerrar..."
     WORD5="¡Script Abortado!"
     WORD6="Probando conexion a Internet..."
     WORD7="Tipo de Lanzamiento:"
     WORD8="Elige el tipo de lanzamiento:"
     WORD9="Tipo de Lanzamiento:"
     WORD10="Lanzamiento Final"
     WORD11="Lanzamientos Beta"
     WORD12="Realiza la descarga basada en el Archivo Final Estable..."
     WORD13="Realiza la descarga basada en los Archivos Beta no estables..."
     WORD14="Construyendo la lista de clasificación..."
     WORD15="Generando el menú dinámico..."
     WORD16="Versiones Beta:"
     WORD17="Por favor elige la descarga:"
     WORD18="Elige:"
     WORD19="Version Beta:"
     WORD20="Descargando la versión Final mas reciente..."
     WORD21="Descargando la versión Beta seleccionada..."
     WORD22="¡Operación Completa!"
	     ;;
  * ) 
     WORD1="Initializing Variables..."
     WORD2="Initializing Functions..."
     WORD3="Script Canceled!"
     WORD4="Press [ ENTER ] To Close..."
     WORD5="Script Aborted!"
     WORD6="Testing Internet Connection..."
     WORD7="Release Type:"
     WORD8="Select Type of Release:"
     WORD9="Release Type:"
     WORD10="Final Releases"
     WORD11="Beta Releases"
     WORD12="Downloading Final Builds Inventory File..."
     WORD13="Downloading Beta Builds Inventory File..."
     WORD14="Sorting Builds List..."
     WORD15="Generating Dynamic Menu..."
     WORD16="Beta Versions:"
     WORD17="Please Select Download:"
     WORD18="Pick:"
     WORD19="Beta Version:"
     WORD20="Downlaoding Selected Final Build..."
     WORD21="Downlaoding Selected Beta Build..."
     WORD22="Operation Complete!"
           ;;
esac

DISPLAYSTATUS

# =============================================================================================================
# Declear Varables:
echo -n "# $WORD1" | tee /tmp/status.tmp
HEIGHT="550"
WIDTH="750"
URL="www.s2ii.fr.nf/wp-content/uploads/win2-7"
BETAURL="www.s2ii.fr.nf/wp-content/uploads/win2-7/Win2-7Beta"
TIMEOUT="5"
TRIES="1"

DISPLAYSTATUS

# =============================================================================================================
# Declear Functions:
echo -n "# $WORD2" | tee /tmp/status.tmp
function CHECKFORCANCEL { 
# Cancel and Clean-up:
if [ "$?" = "1" ]; then
   rm -f *.log
   echo -n "# "
   $TPUT_BOLD
   $TPUT_RED
   echo "$WORD3"
   $TPUT_CLEAR
   echo "# "
   echo "# $WORD4"
   read key
   exit
fi
                }

function QUITANDCLOSE {
   rm -f *.log
   echo -n "# "
   $TPUT_BOLD
   $TPUT_RED
   echo "$WORD5"
   $TPUT_CLEAR
   echo "# "
   echo "# $WORD4"
   read key
   exit
                }

DISPLAYSTATUS

# =============================================================================================================
# Change to PWD:
cd "`dirname \"$0\"`"

# =============================================================================================================
# Check Internet Connection:
echo -n "# $WORD6" | tee /tmp/status.tmp
if ! `ping -c 1 www.google.com > "/dev/null" 2>&1` ; then
   FAIL="YES"
   DISPLAYSTATUS
   QUITANDCLOSE
fi

DISPLAYSTATUS

# =============================================================================================================
# Pick Download Type:
RELEASE=$(zenity --list --title="$WORD7" --text="$WORD8" --radiolist  --column="$WORD18" --column="$WORD9" TRUE "$WORD10" FALSE "$WORD11" )

CHECKFORCANCEL

# =============================================================================================================
# Download Inventory File:
if [ "$RELEASE" = "$WORD10" ]; then
   echo -n "# $WORD12" | tee /tmp/status.tmp
   LIST="win2-7FinalInventory.ini" ; STATUSCHECK
else
   echo -n "# $WORD13" | tee /tmp/status.tmp
   LIST="win2-7BetaInventory.ini" ; STATUSCHECK
fi

if ! `wget -q --tries="$TRIES" --timeout="$TIMEOUT" $URL/$LIST -O /tmp/$LIST` ; then
   FAIL="YES"
   DISPLAYSTATUS
   QUITANDCLOSE
fi

DISPLAYSTATUS

# =============================================================================================================
# Sort Builds:

echo -n "# $WORD14" | tee /tmp/status.tmp
sort -r /tmp/$LIST > /tmp/Sorted_$LIST ; STATUSCHECK
mv /tmp/Sorted_$LIST /tmp/$LIST ; STATUSCHECK
DISPLAYSTATUS

# =============================================================================================================
# Generate Dynamic Menu List:

echo -n "# $WORD15" | tee /tmp/status.tmp
n=1 ; STATUSCHECK
f=0 ; STATUSCHECK
while read curline; do
export VERSION$n="$curline" ; STATUSCHECK
export FALSE$f="$curline" ; STATUSCHECK
let n=n+1 ; STATUSCHECK
let f=f+1 ; STATUSCHECK
done < /tmp/$LIST
rm -f /tmp/$LIST ; STATUSCHECK
DISPLAYSTATUS

# =============================================================================================================
# Display Builds:
DOWNLOADBUILD=$(zenity --list --title="$WORD16" --width="$WIDTH" --height="$HEIGHT" --text="$WORD17" --radiolist  --column="$WORD18" --column="$WORD19" true $VERSION1 $FALSE1 $VERSION2 $FALSE2 $VERSION3 $FALSE3 $VERSION4 $FALSE4 $VERSION5 $FALSE5 $VERSION6 $FALSE6 $VERSION7 $FALSE7 $VERSION8 $FALSE8 $VERSION9 $FALSE9 $VERSION10 $FALSE10 $VERSION11 $FALSE11 $VERSION12 $FALSE12 $VERSION13 $FALSE13 $VERSION14 $FALSE14 $VERSION15 )

CHECKFORCANCEL

# =============================================================================================================
# Download Selected Build:

if [ "$RELEASE" = "$WORD10" ]; then
   echo -n "# $WORD20" | tee /tmp/status.tmp
   if ! `wget -q --progress=bar:force $URL/$DOWNLOADBUILD` ; then
      FAIL="YES"
      DISPLAYSTATUS
      QUITANDCLOSE
   fi
else
   echo -n "# $WORD21" | tee /tmp/status.tmp
   if ! `wget -q --progress=bar:force $BETAURL/$DOWNLOADBUILD` ; then
      FAIL="YES"
      DISPLAYSTATUS
      QUITANDCLOSE
   fi
fi

DISPLAYSTATUS

rm -f *.log
echo -n "# "
$TPUT_GREEN
$TPUT_BOLD
echo "$WORD22"
$TPUT_CLEAR
echo "# "
echo "# $WORD4"

read key

exit

