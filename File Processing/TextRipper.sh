#!/bin/sh
# Author : dave@meyer.LA
# Date   : 10/12/2010
#
# TextRipper 2.0 (aka T-Rip)
# An OCR, Optical Character Recognition, gui application or cli script
# Uses the Tesseract engine by default.
# Optionally supports the Ocrad engine for multi-column text.
# These recognition engines have a very high character recognition success rate compared to other OCR's, including proprietary software.
# New: multi-page and multiple file selection support!
# Enhanced XSANE output and TIFF compatibility. 
# Handles nearly any format out there!
# This script will convert any image of text into editable and indexable text. (for a full list of compatible file formats see the first filter below)
#
# REM: The better/cleaner/higher contrasted/higher resolution your image or scan is the better the results
# 
# Dependencies: libtiff-dev (or -devel)(installed FIRST), tesseract-2.04 (latest stable-version), your chosen language data for Tesseract (2.00 and up) *1,
# ImageMagick, ghostscript, Zenity, and OpenOffice or other text editor *2
# This version of tesseract can be downloaded from here: http://code.google.com/p/tesseract-ocr/downloads/list
# Warning: This script will not work with the latest beta version (tesseract 3.00 pre-release) due to database structure modifications. 
# 
# Optional dependencies: ocrad ->an alternate recognition engine 
# If inital results are unsatisfactory, maybe this engine will do better. Most importantly, it supports basic page format recognition. *3
# The latest version of ocrad can be downloaded off the GNU mirror list here: http://www.gnu.org/software/ocrad/
# 
# Also: Make sure to select Unicode UTF-8 in OpenOffice's pop-up window (or text editor of your choice). 
# 
#
#
# *1 	Install Tesseract after libtiff-dev. Then extract all the language databases you need into the "wherever_you_installed/tesseract-2.04/tessdata" directory.
# 		This is done automatically if you extract the language databases from WITHIN the "tesseract-2.04" directory (and allow overwriting).
# 		This script allows the use of multiple language databases. Default is English and French. For adding others see comments below.
#		You NEED at least one language database or tesseract will not work.
# *2 	Simply change the occurance of "soffice -writer" below to a text editor of your choice, ie: gedit, KWrite, etc 
# 		Some systems call on OpenOffice Writer differently. If unsure, check the properties tab of your Writer launcher.
# 		Ie: On customized versions of OOo (such as the ones provided by Linux Mandrake or Gentoo), you start Writer with: oowriter 
# *3	If you install ocrad also, TextRipper will recognize this and prompt you to choose between the two offering better recognition or page format support
#
# Troubleshooting:
#		If this script ends saying your text editor can't open "OCR output-editable text.txt", 
#		or if run off the cli: Unable to load unicharset file /usr/local/share/tessdata/eng.unicharset 
#		do (as superuser):
#		echo /usr/local/share /usr/share | xargs -n 1 cp -R wherever_you_installed/tesseract-2.04/tessdata 
#			Explanation: 	Tesseract may call on the tessdata directory from the /share directory of your filesystem, 
#							so you need to make your language databases available from there.
#


# Some preliminiaries
IFS=

#trap to ensure we stay clean
clean_up(){
cd "$DN_FILE"
rm -f *converted_from_pdf*
rm -f *converted_for_ocr*
rm -f *converted_for_tes*
rm -f pdfinfo_out
unset DN_FILE
unset MC_YES
}

trap 'clean_up' EXIT INT TERM QUIT SIGINT SIGQUIT SIGTERM

# Set variables
NUM_SEL=$#								# This is to workaround $# being reset to zero
ALL_FILES=$@
DN_FILE="$( cd "$( dirname "$1" )" && pwd )"	# Highly portable current dir variable definition
export DN_FILE
i=1

# First we make sure something's selected.
if [ $# -eq 0 ]; then
	zenity --warning --title="Error" --text="TextRipper won't work if you don't select at least one file...\n\n
	CLI fans do './TextRipper FileToRip'"
	exit
fi

# Ocrad installed?
OCRAD_YES=`ls /usr/local/bin /usr/bin /$HOME/bin | grep ocrad`
if [ $OCRAD_YES = ocrad ]; then
	# Prompt for multi-column or block text
	MC_YES=$(zenity --list --title="Format definition" --text="Is the text in multiple columns?" --radiolist --column "" --column "" TRUE No FALSE Yes) 
	EXIT1=$?
	if [ $EXIT1 -ne 0 ] ; then
		exit
	fi
export MC_YES
fi

# Prompt for which language database to use
# To add other languages apphend this list then continue reading below
if [ $MC_YES = No ]; then
USE_LANG=$(zenity --list --title="Language selection" --text="Please select the language of the text in the image(s): \n\n
To add languages, open script in an editor and read the comments." --radiolist --column "" --column "" TRUE English FALSE French)
	EXIT2=$?
	if [ $EXIT2 -ne 0 ] ; then
		exit
	fi
fi

(while [ $# -ge 1 ] ; do
echo "10"

# Set variables to be affected by shift
FILE=$1									# This is for portability
BN_FILE="$( basename "$FILE" )"				# Highly portable $1 variable definition
CONV_TIF="${BN_FILE} (converted_for_tes).tif"
CONV_PGM="${BN_FILE} (converted_for_ocr).pgm"
OCRd_FILE="${BN_FILE} (editable and indexable)"

#zero-pad "$i" (001 002 etc) for multiple file selection and to prevent any possible overwrite)
i=$(printf %03d $i)

# Test if the file is an image
# IS_IMAGE=`file -bi "$FILE_NAME" | grep -c image`
# May not work if the file is on the desktop, so we do it differently.
IS_IMAGE=`echo "$1" | grep -i -c -E  [.]pbm\|[.]pgm\|[.]ppm\|[.]pnm\|[.]jpg\|[.]gif\|[.]png\|[.]jpeg\|[.]bmp\|[.]tiff\|[.]tif\|[.]xcf\|[.]pct\|[.]pict\|[.]pdf\|[.]art\|[.]arw\|[.]avi\|[.]avs\|[.]cal\|[.]cgm\|[.]cin\|[.]cmy\|[.]cr2\|[.]crw\|[.]cur\|[.]dcm\|[.]dcr\|[.]dcx\|[.]dib\|[.]djv\|[.]dng\|[.]dot\|[.]dpx\|[.]emf\|[.]epd\|[.]epi\|[.]eps\|[.]eps2\|[.]eps3\|[.]epsf\|[.]epsi\|[.]ept\|[.]exr\|[.]fax\|[.]fig\|[.]fits\|[.]fpx\|[.]gpl\|[.]gra\|[.]hpg\|[.]hrz\|[.]htm\|[.]html\|[.]ico\|[.]inf\|[.]inli\|[.]jbig\|[.]jng\|[.]jp2\|[.]jpc\|[.]mat\|[.]matt\|iff\|[.]mon\|[.]mng\|[.]m2v\|[.]mpe\|[.]mpc\|[.]mpr\|[.]mrw\|[.]msl\|[.]mtv\|[.]mvg\|[.]nef\|[.]orf\|[.]otb\|[.]pal\|[.]pam\|[.]pcd\|[.]pcl\|[.]pcx\|[.]pdb\|[.]pef\|[.]pfa\|[.]pfb\|[.]pfm\|[.]pico\|[.]pix\|[.]ps2\|[.]ps3\|[.]psd\|[.]ptif\|[.]pwp\|[.]rad\|[.]raf\|[.]rgb\|[.]rla\|[.]rle\|[.]sct\|[.]sfw\|[.]sgi\|[.]sht\|[.]sid\|[.]sun\|[.]svg\|[.]tga\|[.]tim\|[.]ttf\|[.]uil\|[.]uyv\|[.]vica\|[.]viff\|[.]vif\|[.]wbm\|[.]wmf\|[.]wpg\|[.]xbm\|[.]xpm\|[.]xwd\|[.]ycb\|[.]yuv\|[.]x3f\|[.]p7`
  case $IS_IMAGE in
	0)
		zenity --warning --title="Incompatible file format" --text="This file doesn't seem to be an image. If it is, open it in GIMP then save as -> select the .pnm extension -> and try TextRipper on this new file. \n\n
CLI fans do 'convert WeirdFile.??? NewFileToRip.pgm'"
		exit
                ;;
	1)
		# Test if the file is an image of the tiff class format.
 		IS_PNM=`echo "$1" | grep -i -c -E [.]tiff\|[.]tif`
		if [ $IS_PNM -eq 0 ] ; then
echo "20"
			# Since the file is not a .tiff image, convert it using ImageMagick
			convert "$DN_FILE"/"$BN_FILE" "$DN_FILE"/"$CONV_TIF"
echo "40"
		fi		

		# Since the file is a .tiff image, ensure tesseract compatibility with ImageMagick
		IS_TIF=`echo "$1" | grep -i -c -E [.]tiff\|[.]tif`
		if [ $IS_TIF -eq 1 ] ; then
echo "20"			
			convert "$DN_FILE"/"$BN_FILE" -alpha off -type truecolor -type bilevel +compress "$DN_FILE"/"$CONV_TIF" 
echo "40"
		fi

		# Test if the file is a pdf document.
 		IS_PDF=`echo "$1" | grep -i -c -E [.]pdf`

		if [ $IS_PDF -eq 1 ] ; then
echo "20"

			# Test if encrypted
			pdfinfo "$BN_FILE" > "$DN_FILE"/pdfinfo_out

			if test -s "$DN_FILE"/pdfinfo_out ; then 
				echo "pdf is not pw locked" # it is not encrypted
			else # it is encrypted so hint on PDFcrack
				zenity --error --title "${BN_FILE} is password locked" --text "Visit http://pdfcrack.sourceforge.net/index.html"
				exit
			fi

				# grep total number of pages
				TOT_PAGES=`pdfinfo "$DN_FILE"/"$BN_FILE" | awk '/Pages/ {print $2}'`

				if [ "$TOT_PAGES" -ne 1 ] ; then
					# Prompt for which pages to extract
					START_PAGE=$(zenity --entry --title="Page range" --text="From page?                                                  " --entry-text=1)
					EXIT3=$?
					if [ $EXIT3 -ne 0 ] ; then
						exit
					fi
					END_PAGE=$(zenity --entry --title="Page range" --text="To page?                                                  " --entry-text=$TOT_PAGES)
					EXIT4=$?
					if [ $EXIT4 -ne 0 ] ; then
						exit
					fi
					# Convert to ppm
					pdftoppm "$DN_FILE"/"$BN_FILE" -f $START_PAGE -l $END_PAGE -gray -r 600 "$DN_FILE"/"${BN_FILE} (converted_from_pdf)"
echo "40"
					cd "$DN_FILE"
					convert *converted_from_pdf* "$CONV_TIF"
echo "50"
				fi

				if [ "$TOT_PAGES" -eq 1 ] ; then
					# Convert to ppm
					pdftoppm "$DN_FILE"/"$BN_FILE" -gray -r 600 "$DN_FILE"/"${BN_FILE} (converted_from_pdf)"
echo "40"
					cd "$DN_FILE"
					convert *converted_from_pdf* "$CONV_TIF"
echo "50"
				fi
		
		fi
				# OCR operation
				if [ $MC_YES = No ] ; then
					# Convert pgm's to tif (w/o the +adjoin option results in one tif file)			
echo "70"
						case $USE_LANG in
	        					English)
								# The following works on the Desktop too! 
								tesseract "$DN_FILE"/"$CONV_TIF" "$DN_FILE"/"${OCRd_FILE} $i" -l eng 
								;;
							French)
								# The following works on the Desktop too! 
								tesseract "$DN_FILE"/"$CONV_TIF" "$DN_FILE"/"${OCRd_FILE} $i" -l fra 
								;;
							# Uncomment to add other language(s). Replace variables "Other_Language" and "Other_Language_ID".			
							# Other_Language)
								# # The following works on the Desktop too! 
								# tesseract "$DN_FILE"/"$CONV_TIF" "$DN_FILE"/"${OCRd_FILE} $i" -l Other_Language_ID 
								# ;;
						esac
echo "80"
				fi

				if [ $MC_YES = Yes ] ; then
					cd "$DN_FILE"
					convert "$CONV_TIF" "$CONV_PGM"
echo "70"
					for PGMs in *converted_from_pdf* ; do
					ocrad -a -l --format=utf8 "$DN_FILE"/"$PGMs" -o "$DN_FILE"/"${OCRd_FILE} $i.txt" #results in one file
					done
					ocrad -a -l --format=utf8 "$DN_FILE"/"$CONV_PGM" -o "$DN_FILE"/"${OCRd_FILE} $i.txt"
echo "80"
				fi		

		;;
	*)
		zenity --warning --title="Corrupted file" --text="Open the file in GIMP then save as -> select the .pnm extension -> and try TextRipper on this new file. \n
Otherwise rescan the page \n\n
CLI fans do 'convert WeirdFile.??? NewFileToRip.pgm'"		
		exit
                ;;
  esac

# Increment "$i" for the next file
let i++

# And continue with the next file ...
  shift
done

echo "100"

if [ $NUM_SEL -eq 1 ] ; then
	# Open the newly created output file (change "soffice -writer" to text editor of your choice)
	soffice -writer "$DN_FILE"/"${OCRd_FILE} 001.txt"
fi
echo "101" #close progress bar

) | zenity --progress --title="Rippin Text" --text="TextRipper is processing... ${ALL_FILES} \n\n
If the result is one output file, TextRipper will open it for you in OpenOffice Writer.\n
Otherwise all txt output files (editable and indexable) will be in the original file's directory." --auto-close
EXIT5=$?
if [ $EXIT5 -ne 0 ] ; then
	break
	wait & clean_up
	kill -9 pid$$
fi
clean_up
echo "TextRipper successfully processed ${ALL_FILES}"
