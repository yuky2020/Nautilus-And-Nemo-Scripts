#!/bin/bash
# TITLE:        PDFextract v. 0.1 by MHC (http://askubuntu.com/users/81372/mhc)
#
# LICENSE:      GNU GPL v3 (http://www.gnu.org/licenses/gpl.html)
#
# DESCRIPTION:  PDFextract is a simple PDF extraction script based on Ghostscript which allows you to extract
#               a page range of your choice from a PDF document. In contrast to other scripts PDFextract preserves
#               _all_ attributes of your original PDF file and does not compress embedded images further
#               than they are. PDFextract comes with a simple GUI based on YAD, an advanced Zenity fork.
#               This script was inspired by Kurt Pfeifle's PDF extraction script
#               (http://www.linuxjournal.com/content/tech-tip-extract-pages-pdf)
#
# DEPENDENCIES: ghostscript,poppler-utils,yad,notify-send
#
# NOTES:        If you are running Ubuntu you can install YAD from the webupd8 PPA via
#               sudo add-apt-repository ppa:webupd8team/y-ppa-manager && sudo apt-get update && sudo apt-get install yad
#
# USAGE:        Move the script to your file manager's script directory and make it executable
#               ($HOME/.gnome2/nemo-scripts for Nautilus)


DOCUMENT="$1"

gsconverter(){
gs -dFirstPage=$1 -dLastPage=$2 -sOutputFile="${3%.pdf}_p${1}-p${2}.pdf" -dSAFER -dNOPAUSE -dBATCH -dPDFSETTING=/default -sDEVICE=pdfwrite -dCompressFonts=true -c \
".setpdfwrite << /EncodeColorImages true /DownsampleMonoImages false /SubsetFonts true /ASCII85EncodePages false /DefaultRenderingIntent /Default /ColorConversionStrategy \
/LeaveColorUnchanged /MonoImageDownsampleThreshold 1.5 /ColorACSImageDict << /VSamples [ 1 1 1 1 ] /HSamples [ 1 1 1 1 ] /QFactor 0.4 /Blend 1 >> /GrayACSImageDict \
<< /VSamples [ 1 1 1 1 ] /HSamples [ 1 1 1 1 ] /QFactor 0.4 /Blend 1 >> /PreserveOverprintSettings false /MonoImageResolution 300 /MonoImageFilter /FlateEncode \
/GrayImageResolution 300 /LockDistillerParams false /EncodeGrayImages true /MaxSubsetPCT 100 /GrayImageDict << /VSamples [ 1 1 1 1 ] /HSamples [ 1 1 1 1 ] /QFactor \
0.4 /Blend 1 >> /ColorImageFilter /FlateEncode /EmbedAllFonts true /UCRandBGInfo /Remove /AutoRotatePages /PageByPage /ColorImageResolution 300 /ColorImageDict << \
/VSamples [ 1 1 1 1 ] /HSamples [ 1 1 1 1 ] /QFactor 0.4 /Blend 1 >> /CompatibilityLevel 1.4 /EncodeMonoImages true /GrayImageDownsampleThreshold 1.5 \
/AutoFilterGrayImages false /GrayImageFilter /FlateEncode /DownsampleGrayImages false /AutoFilterColorImages false /DownsampleColorImages false /CompressPages true \
/ColorImageDownsampleThreshold 1.5 /PreserveHalftoneInfo false >> setdistillerparams" -f "$3"
}

settingsdialog(){
PAGECOUNT=$(pdfinfo "$DOCUMENT" | grep Pages | sed 's/[^0-9]*//') #determine page count

SETTINGS=($(yad --window-icon application-pdf --image application-pdf --width 300 --form --separator=" " --title="PDFextract" --text \
    "Please choose the page range" --field="Start:NUM" 1[!1..$PAGECOUNT[!1]] --field="End:NUM" $PAGECOUNT[!1..$PAGECOUNT[!1]] \
    --button="gtk-ok:0" --button="gtk-cancel:1"))

RET=$? #Save return value

STARTPAGE=$(printf %.0f ${SETTINGS[0]}) #round numbers and store array in variables
STOPPAGE=$(printf %.0f ${SETTINGS[1]})
}

runjob(){

settingsdialog

#Analyze return value
if [[ $RET = 0 ]] #Did the user click on OK? if so
  then
      if [ $STARTPAGE -gt $STOPPAGE ] # check for errors in the input
        then #there are errors
            yad --image dialog-warning --title "PDFExtract Warning" --button="Try again:0" --text "<b>   Start page higher than stop page.   </b>"
            runjob $DOCUMENT # let the user correct the input
        else #if there are no errors
            gsconverter $STARTPAGE $STOPPAGE "$DOCUMENT" #extract pages
            RET=$? #store return value
            if [ $RET = 0 ] #check for errors and notify the user
              then
                  notify-send -i application-pdf "PDFextract" "Pages $STARTPAGE to $STOPPAGE succesfully extracted."
              else
                  notify-send -i application-pdf "PDFextract" "There was an error. Please check the CLI output."
            fi
      fi
  else #if not
      exit 1 #exit script
fi
}

runjob $DOCUMENT
