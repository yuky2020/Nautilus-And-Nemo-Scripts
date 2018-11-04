#!/usr/bin/python


# This application is released under the GNU General Public License 
# v3 (or, at your option, any later version). You can find the full 
# text of the license under http://www.gnu.org/licenses/gpl.txt. 
# By using, editing and/or distributing this software you agree to 
# the terms and conditions of this license. 
# Thank you for using free software!

# Author: Whise aka Helder Fraga <helderfraga@gmail.com>, 2010 

#Usage - Run the script with root to patch root themes or normaly for user installed themes
#Run <sudo> python -u theme_bg_patcher.py

import os,sys

global filelist
    
filelist = []

def walk(dir):

	for file in [file for file in os.listdir(dir) if not file in [".",".."]]:
		nfile = os.path.join(dir,file)
		if os.path.isfile(nfile):
			if nfile.endswith('gtkrc'):
				style = None
				fh = open(nfile)
			


				# fix to patch only the panel code, other parts have bg_pixmap[NORMAL] to
				for line in fh.readlines():
					if line.startswith('widget "*PanelApplet*"'):
						style = line[line.find('style "')+6:].replace('\n','')
						if style.endswith(' '): style == style[:len(style)-1]
						#print style
				
				fh.close()
				if style != None:
					fh = open(nfile)
					fhh = fh.read()					
					panel_code1 = fhh[fhh.find('\nstyle ' + style):]
					panel_code_original = panel_code1[:panel_code1.find('}')]
					panel_code_patched = panel_code_original.replace('bg_pixmap[NORMAL]','#bg_pixmap[NORMAL]')
					#print panel_code_original
					a = fhh.replace(panel_code_original,panel_code_patched)
					fi = open(nfile,'w')
					fi.write(a)
					fi.close()
					print '* Patched - ' + nfile
					fh.close()
		elif os.path.isdir(nfile):
			walk(nfile)


if os.geteuid()==0:
	# we run as root, install system-wide
	walk('/usr/share/themes/')
else:
	walk(os.environ['HOME'] + '/.themes/')
	


