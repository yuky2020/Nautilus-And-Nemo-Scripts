#!/usr/bin/python
# tinypic uploader :: 4.0
# gnome-look.org :: magicmarkers :: 2010-05-18
import sys,re
from subprocess import Popen as sub, PIPE
from os import path,getenv,listdir
cli = getenv('NAUTILUS_SCRIPT_WINDOW_GEOMETRY') is None
if cli : selected = sys.argv[1:]
else :
	zenity = sub('zenity --title="Uploading to tinypic.com" --text-info --width=500 --height=300',shell=True,stdin=PIPE)
	sys.stdout,sys.stderr = zenity.stdin,zenity.stdin
	selected = getenv('NAUTILUS_SCRIPT_SELECTED_FILE_PATHS','').splitlines()
if not selected : print "-- nothing selected --", sys.exit(1)
types = ['image/jpeg','image/gif','image/png','image/x-ms-bmp','image/x-pcx','image/tiff','image/vnd.adobe.photoshop']
form = [re.compile('form action="http://s(.)'),re.compile('id="uid" value="([^"]+)'),re.compile('name="upk" value="([^"]+)')]
resultDetails = re.compile('name="pic" value="([^"]+)')
def filesfirst(list) : return sorted([f for f in list if path.isfile(f)]) + sorted([d for d in list if path.isdir(d)])
def upload(file) :
	if path.isdir(file) :
		print '--- %s ---'%file
		for each in filesfirst([path.join(file,unsorted) for unsorted in listdir(file)]) : upload(each)
		return
	if sub('file -b --mime-type %s'%re.escape(file),shell=True,stdout=PIPE).stdout.read().strip() not in types : return
	tinypicSource = sub('curl -s tinypic.com',shell=True,stdout=PIPE).stdout.read()
	try : formValues = [field.search(tinypicSource).group(1) for field in form]
	except : print '-- form error --', sys.exit(2)
	try : result = resultDetails.search(sub('curl -s -L -F UPLOAD_IDENTIFIER="%s" -F upk="%s" -F domain_lang="en" -F action="upload" -F MAX_FILE_SIZE="500000000" -F shareopt="true" -F the_file=@%s -F file_type="image" -F dimension="1600" "http://s%s.tinypic.com/upload.php" -H "Expect:" -e "http://tinypic.com"'%(formValues[1],formValues[2],re.escape(file),formValues[0]),shell=True,stdout=PIPE).stdout.read()).group(1)
	except : print '-- upload error --', sys.exit(3)
	if cli : print 'http://s%s.tinypic.com/%s\t%s'%(formValues[0],result,file)
	else : print 'http://s%s.tinypic.com/%s'%(formValues[0],result)
for each in filesfirst(selected) : upload(each)
print '-- done --'
