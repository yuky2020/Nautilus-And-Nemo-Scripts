#!/bin/bash

echo $1
echo $2
if [ -z "$1" ]; then
echo "no option selected"
exit
fi

if [ "$1" != "s" ] && [ "$1" != "a" ]; then
echo "wrong option selected"
exit
fi

if [ -z "$2" ]; then
echo "no destionation selected"
exit
fi

if [ ! -d "$2" ]; then
echo "selected destination is not a directory"
exit
fi

menuitem=$1
dest=$2

picdir="/home/$USER/Pictures"
musicdir="/home/$USER/Music"
docdir="/home/$USER/Documents"
videodir="/home/$USER/Videos"
archdir="/home/$USER/Archives"
progdir="/home/$USER/Scripts"

if [ "$1" = "s" ]; then
cd $dest
if [ ! -d "$videodir" ]; then
mkdir $videodir
fi
if [ ! -d "$musicdir" ]; then
mkdir $musicdir
fi
if [ ! -d "$picdir" ]; then
mkdir $picdir
fi
if [ ! -d "$progdir" ]; then
mkdir $progdir
fi
if [ ! -d "$archdir" ]; then
mkdir $archdir
fi
if [ ! -d "$docdir" ]; then
mkdir $docdir
fi

#fixing files with blanks
find . -name "* *"|while read file
do
target=`echo "$file"|tr -s ' ' '_'`
mv "$file" "$target"
done

#start moving / if filename in output directory exist, append filename and add timestamp into name
for i in $dest/*; do
if [ -f $i ]; then

case $i in
*.flv|*.swf|*.fla|*.rmvb|*.rm|*.flr|*.mkv|*.mov|*.mpeg|*.mpg|*.mpe|*.mp4|*.ogm|*.ogg|*.wmv|*.avi)
for FILES in $( ls -l | grep -v ^d ); do
q=$(date '+%Y-%m-%d_%H:%M_')
if [ -e $videodir/$FILES ]; then
mv $FILES $q$FILES
mv $q$FILES $videodir
else
mv $i $videodir
fi
done
;;
*.aiff|*.au|*.cdda|*.iff-8svx|*.iff-16sv|*.raw|*.wav|*.flac|*.la|*.pac|*.m4a|*.ape|*.optimfrog|*.rka|*.shn|*.tta|*.wv|*.wma|*.mp2|*.mp3|*.speex|*.vorbis|*.gsm|*.wma|*.m4a|*.mp4|*.m4p|*.aac|*.mpc|*.vqf|*.ra|*.rm|*.ots|*.swa|*.vox|*.voc|*.dwd|*.smp|*.swa|*.cust|*.mid|*.mus|*.sib|*.gym|*.vgm|*.psf|*.nsf|*.mod|*.ptb|*.s3m|*.xm|*.it|*.mt2|*.mng|*.psf|*.rmj|*.spc|*.niff|*.musicxml|*.ym|*.jam|*.ram|*.aup|*.cel|*.cpr|*.npr|*.cwp|*.drm|*.omf|*.ses|*.stf|*.syn)
for FILES in $( ls -l | grep -v ^d ); do
q=$(date '+%Y-%m-%d_%H:%M_')
if [ -e $musicdir/$FILES ]; then
mv $FILES $q$FILES
mv $q$FILES $musicdir
else
mv $i $musicdir
fi
done
;;
*.jpeg|*.gif|*.png|*.act|*.art|*.bmp|*.blpjpeg|*.cit|*.cpt|*.cut|*.dib|*.djvu|*.egt|*.exif|*.gif|*.icns|*.ico|*.iff|*.jng|*.jpg|*.jp2|*.lbm|*.max|*.miff|*.mng|*.msp|*.nitf|*.ota|*.pbm|*.pc1|*.pc2|*.pc3|*.pcf|*.pcx|*.awg|*.ai|*.eps|*.cgm|*.cdr|*.cmx|*.dxf|*.egt|*.svg|*.wmf|*.emf|*.art|*.xar)
for FILES in $( ls -l | grep -v ^d ); do
q=$(date '+%Y-%m-%d_%H:%M_')
if [ -e $picdir/$FILES ]; then
mv $FILES $q$FILES
mv $q$FILES $picdir
else
mv $i $picdir
fi
done
;;
*.as|*.asl|*.asp|*.au3|*.bat|*.bas|*.bb|*.bh|*.bmax|*.cmd|*.egg|*.egt|*.hta|*.ici|*.itcl|*.js|*.jsfl|*.lua|*.m|*.mrc|*.ncf|*.nut|*.php|*.pl|*.pm|*.ps1|*.ps1xml|*.psc1|*.psd1|*.psm1|*.py|*.pyc|*.pyo|*.rb|*.scpt|*.sh|*.tcl|*.vbs|*.c|*.cls|*.cob|*.cbl|*.cpp|*.cc|*.cxx|*.cs|*.d|*.e|*.efs|*.frm|*.frx|*.ged|*.gm6|*.gmd|*.gmk|*.gml|*.h|*.hpp|*.hxx|*.inc|*.java|*.l|*.m|*.m4|*.ml|*.n|*.pas|*.pp|*.p|*.php|*.php3|*.php4|*.php5|*.phps|*.phtml|*.html|*.pas|*.resx|*.y|*.pas)
for FILES in $( ls -l | grep -v ^d ); do
q=$(date '+%Y-%m-%d_%H:%M_')
if [ -e $progdir/$FILES ]; then
mv $FILES $q$FILES
mv $q$FILES $progdir
else
mv $i $progdir
fi
done
;;
*.q|*.7z|*.ace|*.alz|*.at3|*.bke|*.arc|*.dds|*.arj|*.big|*.bkf|*.bz2|*.cab|*.cpt|*.sea|*.daa|*.deb|*.dmg|*.eea|*.egt|*.ecab|*.ezip|*.ess|*.gho|*.ghs|*.gz|*.jar|*.lbr|*.lqr|*.lzh|*.lzo|*.lzma|*.lzx|*.bin|*.pak|*.par|*.par2|*.pk4|*.rar|*.sit|*.sitx|*.tar|*.tar.gz|*.xz|*.tgz|*.tb|*.tib|*.uha|*.vsa|*.z|*.zoo|*.zip|*.q|*.iso|*.img|*.adf|*.adz|*.dms|*.dsk|*.d64)
for FILES in $( ls -l | grep -v ^d ); do
q=$(date '+%Y-%m-%d_%H:%M_')
if [ -e $archdir/$FILES ]; then
mv $FILES $q$FILES
mv $q$FILES $archdir
else
mv $i $archdir
fi
done
;;
*.123|*.aws|*.gnumeric|*.numbers|*.ods|*.ots|*.opw|*.slk|*.stc|*.sxc|*.tab|*.vc|*.wk1|*.wk2|*.wk3|*.wk4|*.wks|*.wq1|*.xlk|*.xls|*.xlsb|*.xlsm|*.xlsx|*.xlr|*.xlt|*.xltm|*.xlw|*.abw|*.ans|*.asc|*.aww|*.csv|*.cwk|*.doc|*.docx|*.dot|*.dotx|*.egt|*.ftm|*.ftx|*.hwp|*.lwp|*.mcw|*.nb|*.nbp|*.abf|*.afm|*.bdf|*.bmf|*.fon|*.mgf|*.otf|*.pcf|*.snf|*.tfm|*.ttf|*.key|*.keynote|*.snf|*.nb|*.nbp|*.odt|*.ott|*.pages|*.pap|*.radix-64|*.rtf|*.sdw|*.stw|*.sxw|*.tex|*.info|*.troff|*.txt|*.uoml|*.wpd|*.wps|*.wpt|*.wrd|*.wrf|*.wri|*.odp|*.otp|*.pps|*.ppt|*.prz|*.shf|*.sti|*.sxi|*.watch|*.sti|*.sti|*.pdf)
for FILES in $( ls -l | grep -v ^d ); do
q=$(date '+%Y-%m-%d_%H:%M_')
if [ -e $docdir/$FILES ]; then
mv $FILES $q$FILES
mv $q$FILES $docdir
else
mv $i $docdir
fi
done
;;
*.desktop)
mv $i $dest
;;
*)
mv $i $docdir
;;
esac
fi
done
fi
if [ "$1" = "a" ]; then
cd $dest
if [ ! -d "$videodir" ]; then
mkdir $videodir
fi
if [ ! -d "$musicdir" ]; then
mkdir $musicdir
fi
if [ ! -d "$picdir" ]; then
mkdir $picdir
fi
if [ ! -d "$progdir" ]; then
mkdir $progdir
fi
if [ ! -d "$archdir" ]; then
mkdir $archdir
fi
if [ ! -d "$docdir" ]; then
mkdir $docdir
fi

#fixing files with blanks
find . -name "* *"|while read file
do
target=`echo "$file"|tr -s ' ' '_'`
mv "$file" "$target"
done

#start moving / if filename in output directory exist, append filename and add timestamp into name
for i in $dest/*; do
if [ -f $i ]; then

case $i in
*.flv|*.swf|*.fla|*.rmvb|*.rm|*.flr|*.mkv|*.mov|*.mpeg|*.mpg|*.mpe|*.mp4|*.ogm|*.ogg|*.wmv|*.avi)
for EXTENSIONS in ${i##*.}; do
if [ -d $videodir/$EXTENSIONS ]; then
echo "$EXTENSIONS found in $videodir, not created"
else
mkdir -p $videodir/$EXTENSIONS
fi

for FILES in $( ls -l | grep -v ^d ); do
EXTENSION=${FILES##*.}
q=$(date '+%Y-%m-%d_%H:%M_')
if [ -e $videodir/$EXTENSION/$FILES ]; then
mv $FILES $q$FILES
mv $q$FILES $videodir/$EXTENSION/$q$FILES
else
mv $FILES $videodir/$EXTENSION/$FILES
fi
done
done
;;
*.aiff|*.au|*.cdda|*.iff-8svx|*.iff-16sv|*.raw|*.wav|*.flac|*.la|*.pac|*.m4a|*.ape|*.optimfrog|*.rka|*.shn|*.tta|*.wv|*.wma|*.mp2|*.mp3|*.speex|*.vorbis|*.gsm|*.wma|*.m4a|*.mp4|*.m4p|*.aac|*.mpc|*.vqf|*.ra|*.rm|*.ots|*.swa|*.vox|*.voc|*.dwd|*.smp|*.swa|*.cust|*.mid|*.mus|*.sib|*.gym|*.vgm|*.psf|*.nsf|*.mod|*.ptb|*.s3m|*.xm|*.it|*.mt2|*.mng|*.psf|*.rmj|*.spc|*.niff|*.musicxml|*.ym|*.jam|*.ram|*.aup|*.cel|*.cpr|*.npr|*.cwp|*.drm|*.omf|*.ses|*.stf|*.syn)
for EXTENSIONS in ${i##*.}; do
if [ -d $musicdir/$EXTENSIONS ]; then
echo "$EXTENSIONS found in $musicdir, not created"
else
mkdir -p $musicdir/$EXTENSIONS
fi

for FILES in $( ls -l | grep -v ^d ); do
EXTENSION=${FILES##*.}
q=$(date '+%Y-%m-%d_%H:%M_')
if [ -e $musicdir/$EXTENSION/$FILES ]; then
mv $FILES $q$FILES
mv $q$FILES $musicdir/$EXTENSION/$q$FILES
else
mv $FILES $musicdir/$EXTENSION/$FILES
fi
done
done
;;
*.jpeg|*.gif|*.png|*.act|*.art|*.bmp|*.blpjpeg|*.cit|*.cpt|*.cut|*.dib|*.djvu|*.egt|*.exif|*.gif|*.icns|*.ico|*.iff|*.jng|*.jpg|*.jp2|*.lbm|*.max|*.miff|*.mng|*.msp|*.nitf|*.ota|*.pbm|*.pc1|*.pc2|*.pc3|*.pcf|*.pcx|*.awg|*.ai|*.eps|*.cgm|*.cdr|*.cmx|*.dxf|*.egt|*.svg|*.wmf|*.emf|*.art|*.xar)
for EXTENSIONS in ${i##*.}; do
if [ -d $picdir/$EXTENSIONS ]; then
echo "$EXTENSIONS found in $picdir, not created"
else
mkdir -p $picdir/$EXTENSIONS
fi

for FILES in $( ls -l | grep -v ^d ); do
EXTENSION=${FILES##*.}
q=$(date '+%Y-%m-%d_%H:%M_')
if [ -e $picdir/$EXTENSION/$FILES ]; then
mv $FILES $q$FILES
mv $q$FILES $picdir/$EXTENSION/$q$FILES
else
mv $FILES $picdir/$EXTENSION/$FILES
fi
done
done
;;
*.as|*.asl|*.asp|*.au3|*.bat|*.bas|*.bb|*.bh|*.bmax|*.cmd|*.egg|*.egt|*.hta|*.ici|*.itcl|*.js|*.jsfl|*.lua|*.m|*.mrc|*.ncf|*.nut|*.php|*.pl|*.pm|*.ps1|*.ps1xml|*.psc1|*.psd1|*.psm1|*.py|*.pyc|*.pyo|*.rb|*.scpt|*.sh|*.tcl|*.vbs|*.c|*.cls|*.cob|*.cbl|*.cpp|*.cc|*.cxx|*.cs|*.d|*.e|*.efs|*.frm|*.frx|*.ged|*.gm6|*.gmd|*.gmk|*.gml|*.h|*.hpp|*.hxx|*.inc|*.java|*.l|*.m|*.m4|*.ml|*.n|*.pas|*.pp|*.p|*.php|*.php3|*.php4|*.php5|*.phps|*.phtml|*.html|*.pas|*.resx|*.y|*.pas)
for EXTENSIONS in ${i##*.}; do
if [ -d $progdir/$EXTENSIONS ]; then
echo "$EXTENSIONS found in $progdir, not created"
else
mkdir -p $progdir/$EXTENSIONS
fi

for FILES in $( ls -l | grep -v ^d ); do
EXTENSION=${FILES##*.}
q=$(date '+%Y-%m-%d_%H:%M_')
if [ -e $progdir/$EXTENSION/$FILES ]; then
mv $FILES $q$FILES
mv $q$FILES $progdir/$EXTENSION/$q$FILES
else
mv $FILES $progdir/$EXTENSION/$FILES
fi
done
done
;;
*.q|*.7z|*.ace|*.alz|*.at3|*.bke|*.arc|*.dds|*.arj|*.big|*.bkf|*.bz2|*.cab|*.cpt|*.sea|*.daa|*.deb|*.dmg|*.eea|*.egt|*.ecab|*.ezip|*.ess|*.gho|*.ghs|*.gz|*.jar|*.lbr|*.lqr|*.lzh|*.lzo|*.lzma|*.lzx|*.bin|*.pak|*.par|*.par2|*.pk4|*.rar|*.sit|*.sitx|*.tar|*.tar.gz|*.xz|*.tgz|*.tb|*.tib|*.uha|*.vsa|*.z|*.zoo|*.zip|*.q|*.iso|*.img|*.adf|*.adz|*.dms|*.dsk|*.d64)
for EXTENSIONS in ${i##*.}; do
if [ -d $archdir/$EXTENSIONS ]; then
echo "$EXTENSIONS found in $archdir, not created"
else
mkdir -p $archdir/$EXTENSIONS
fi

for FILES in $( ls -l | grep -v ^d ); do
EXTENSION=${FILES##*.}
q=$(date '+%Y-%m-%d_%H:%M_')
if [ -e $archdir/$EXTENSION/$FILES ]; then
mv $FILES $q$FILES
mv $q$FILES $archdir/$EXTENSION/$q$FILES
else
mv $FILES $archdir/$EXTENSION/$FILES
fi
done
done
;;
*.123|*.aws|*.gnumeric|*.numbers|*.ods|*.ots|*.opw|*.slk|*.stc|*.sxc|*.tab|*.vc|*.wk1|*.wk2|*.wk3|*.wk4|*.wks|*.wq1|*.xlk|*.xls|*.xlsb|*.xlsm|*.xlsx|*.xlr|*.xlt|*.xltm|*.xlw|*.abw|*.ans|*.asc|*.aww|*.csv|*.cwk|*.doc|*.docx|*.dot|*.dotx|*.egt|*.ftm|*.ftx|*.hwp|*.lwp|*.mcw|*.nb|*.nbp|*.abf|*.afm|*.bdf|*.bmf|*.fon|*.mgf|*.otf|*.pcf|*.snf|*.tfm|*.ttf|*.key|*.keynote|*.snf|*.nb|*.nbp|*.odt|*.ott|*.pages|*.pap|*.radix-64|*.rtf|*.sdw|*.stw|*.sxw|*.tex|*.info|*.troff|*.txt|*.uoml|*.wpd|*.wps|*.wpt|*.wrd|*.wrf|*.wri|*.odp|*.otp|*.pps|*.ppt|*.prz|*.shf|*.sti|*.sxi|*.watch|*.sti|*.sti|*.pdf)
for EXTENSIONS in ${i##*.}; do
if [ -d $docdir/$EXTENSIONS ]; then
echo "$EXTENSIONS found in $docdir, not created"
else
mkdir -p $docdir/$EXTENSIONS
fi

for FILES in $( ls -l | grep -v ^d ); do
EXTENSION=${FILES##*.}
q=$(date '+%Y-%m-%d_%H:%M_')
if [ -e $docdir/$EXTENSION/$FILES ]; then
mv $FILES $q$FILES
mv $q$FILES $docdir/$EXTENSION/$q$FILES
else
mv $FILES $docdir/$EXTENSION/$FILES
fi
done
done
;;
*.desktop)
mv $i $dest
;;
*)
mv $i $docdir
;;
esac
fi
done
fi
