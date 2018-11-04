#!/usr/bin/python
# coding: utf-8
import os
import sys

colorred = "\033[01;31m%s\033[00m"

try: 
	video = sys.argv[1] 
	if not os.path.isfile(video): raise IndexError	   
except IndexError:
	print colorred % "The file isn't specified, exiting."
	os._exit(1)

from subprocess import Popen, PIPE, call

cheker = "ps aux|grep '%s'" % os.path.basename(__file__)
chkapp = Popen(cheker, shell=True, bufsize=200, stdout=PIPE).stdout.read()
if chkapp.count('python') > 1:
	print colorred % "One script is already started, exiting."
	os._exit(1)
	
#################################################################################
import re
import gtk
import Image, ImageDraw, ImageFont, ImageFilter, ImageStat

from pango import AttrList, AttrFallback, SCALE, FontDescription
from datetime import timedelta
from random import randint

try: 
	import cPickle as pickle
	from cPickle import UnpicklingError
except ImportError: 
	import pickle
	from pickle import UnpicklingError

try:
	import pynotify
	from pynotify import Notification as Noti
	pynotify.init('MakeScreenlist')
	SHOWNOTYF = True
except ImportError: SHOWNOTYF = False

##################################################################################
TMPDIR = "/tmp/shots"
APPDIR = "%s/.gnome2/nemo-scripts/.make-screenlist" % os.getenv('HOME')
VDINFO = "mplayer '%s' -ao null -vo null -frames 1 -identify 2>&1"
MPSHOT = "mplayer -ss '%s' -noautosub -frames 1 -ao null -zoom -xy %s -vo png:outdir='%s' '%s' >/dev/null 2>&1"           

def GetSans():
	GREP = "fc-match -v 'Sans'|grep -e 'file: [^^]*\.[tT][tT][fF]' -e 'family: ' -e '\sstyle: '|sed 's+\t++'"

	p = Popen(GREP, shell=True, bufsize=200, stdout=PIPE)

	if p.wait() == 0:
		reads = p.stdout.read()
		lines = reads.split('\n')
		try:
			fontname = lines[2].split('"')[1]
			fonstyle = lines[1].split('"')[1]
			fonfamle = lines[0].split('"')[1]
			sans = ("%s, %s" % (fonfamle, fonstyle), fontname)
		except IndexError: sans = ("", "")
	else: sans = ("", "")
	return sans

try:
	setfile = open('%s/settings' % APPDIR)
	S = pickle.load(setfile)
	setfile.close()

	SMALXSIZ = S[0]
	SHOTCOLS = S[1]
	SHOTROWS = S[2]
	FONTSIZE = S[3]
	FONTNAME = S[4]
	FONTLABEL = S[5]
	FONTCOLOR = S[6]
	MAINCOLOR = S[7]
	RUNPROGRM = S[8]
	DIRFORSAV = S[9]
	SAVETOVID = S[10]
	PRINTTIME = S[11]

except (IOError, KeyError, EOFError, IndexError, UnpicklingError):

	SMALXSIZ = 200
	SHOTCOLS = 5
	SHOTROWS = 4
	FONTSIZE = 16
	FONTCOLOR = "#CACACA"
	MAINCOLOR = "#551940"	
	RUNPROGRM = ""

	FONTLABEL, FONTNAME = GetSans()
	DIRFORSAV = os.path.dirname(video)
	SAVETOVID = True
	PRINTTIME = False

  
filename = os.path.basename(video)
videodirname = os.path.dirname(video)

LISTSTYLS = {}
FILESLIST = []
SAV = []

#################################################################################
def FontsParser():
	GREPER = "fc-list -v|grep %s %s %s|sed 's+\t++'"
	FIL = "-e 'file: [^^]*\.[tT][tT][fF]'"
	FML = "-e 'family'"
	STL = "-e 'style'"

	p = Popen(GREPER % (FIL, FML, STL), shell=True, bufsize=200, stdout=PIPE)
	##########################################################################
	if p.wait() == 0:
		reads = p.stdout.read()
		lines = reads.split('\n')
		if not lines[-1]: lines.pop(-1)
		lines.reverse()

		names = []	
		poper = lambda: lines.pop(0).split(':')
		spliter = lambda d: d[1].split('"')[1]
		remover = lambda n: poper()[1].split('(s)')[n].split('"')[1]

		while lines:
			fnd = []
			pre = poper()
			if pre[0] == "file":
				fnd.append(spliter(pre))
				pre2 = poper()
				if spliter(pre2) == "en":
					fnd.append(spliter(poper()))
				else:
					pre3 = pre2[1].split('(s)')
					for p in pre3:
						if "en" in p:
							n = pre3.index(p)				 
							fnd.append(remover(n))
							break

				pre4 = poper()
				if spliter(pre4) == "en":
					fnd.append(spliter(poper()))
				else:
					pre5 = pre4[1].split('(s)')
					for p in pre5:
						if "en" in p:
							n = pre5.index(p)				 
							fnd.append(remover(n))
							break
			if fnd:
				try: 
					names.append((fnd[2], fnd[1], len(FILESLIST)))
					FILESLIST.append(fnd[0])
				except IndexError: pass
		
		stls = []
		prev = False
		sortednams = sorted(names)
		for nam in sortednams:
			curr, fam, fil = nam
			if curr != prev:				
				if stls:
					currfont = prev
					curstyle = stls[:]
					del stls[:]
				else:
					currfont = curr
					curstyle = (fam, fil)					
				LISTSTYLS[currfont] = curstyle										
			if fam not in [st[0] for st in stls]: 
				stls.append((fam, fil))
			prev = curr

		endfont, endstyl, endfile = sortednams[-1]
		LISTSTYLS[endfont] = [(endstyl, endfile)]


################################################################################# 
class MakeShot(object):
	def __init__(self):
		P = Popen(VDINFO % video, shell=True, bufsize=200, stdout=PIPE)
		self.videoinfo = P.stdout.read()
		self.videotime = None
		self.shotfont = None
		self.alshots = None
		self.picmode = 0
		self.picsize = 0
		self.dubsize = 0


	def GdkColorToRGB(self, color):
		C = lambda col: int((col/65535.0)*256)
		try: 
			return (C(color.red), C(color.green), C(color.blue))
		except AttributeError:
			g = gtk.gdk.Color(color)
			return (C(g.red), C(g.green), C(g.blue))


	def HumanFormat(self, size):
		for x in ('bytes','KB','MB','GB','TB'):
			if size < 1024.0:
				return "%3.1f%s" % (size, x)
			size /= 1024.0


	def CheckOffset(self, fntsz):
		f = self.shotfont
		c = f.font.getsize("E")[0]
		a = fntsz
		while a:
			curof = a - 1
			field = Image.new("RGB", (c[0], fntsz), (0,0,0)) 
			drawf = ImageDraw.Draw(field)
			drawf.text((0, -curof), "E", "#ffffff", font=f)
			white = ImageStat.Stat(field).sum
			if white[0]:
				e = fntsz - a
				break
			a = curof
		return e


	def PrintTime(self, shotim, savpic, offset):
		text = str(timedelta(seconds=shotim)).split('.')[0]
		textfield = Image.new("RGBA", self.dubsize, (0,0,0,0)) 
		shade = ImageDraw.Draw(textfield)
		shade.text(offset, text, "#000000", font=self.shotfont)
		textfield = textfield.filter(ImageFilter.BLUR)
		draw = ImageDraw.Draw(textfield)
		draw.text(offset, text, "#ffffff", font=self.shotfont)
		res = textfield.resize(self.picsize, Image.ANTIALIAS)
		fin = Image.composite(res, Image.open(savpic), res)
		fin.save(savpic)

	   
	def GetShots(self):
		ids = dict(re.findall('ID_(.*)=(.*)', self.videoinfo))	
		self.videotime = int(float(ids['LENGTH']))
		mparg = lambda q: (q, SMALXSIZ, TMPDIR, video)
		total = SHOTCOLS*SHOTROWS
		inter = int(self.videotime/total)
		tmpic = '%s/00000001.png' % TMPDIR
		ofset, shotfntsiz, halfin = (0, 24, inter/2)

		allshots = []
		position = randint(-halfin, halfin)

		for n in range(total):
			pos = position if n else randint((inter/10), halfin)

			if call(MPSHOT % mparg(pos), shell=True) == 0:
				IM = Image.open(tmpic)
				ST = ImageStat.Stat(IM).sum
				if not allshots:
					self.picsize = IM.size
					self.picmode = IM.mode

				if ST[0] != ST[1] and ST[2]: shotim = pos
				else: 
					nuo = pos-(halfin/2) if pos > inter else pos+(halfin/2)
					if call(MPSHOT % mparg(nuo), shell=True) == 0: shotim = nuo

				savpic = '%s/%04d.png' % (TMPDIR, n)
				os.rename(tmpic, savpic)
				allshots.append(savpic)

				if PRINTTIME: 
					if not ofset: 
						xsize, ysize = self.picsize
						ratio = 3 if float(xsize)/float(ysize) > 1.5 else 4
						ft = max(shotfntsiz, ysize/ratio)					
						try: 
							d = ysize*2
							self.dubsize = (xsize*2, d)
							self.shotfont = ImageFont.truetype(FONTNAME, ft)
							ofset = (ft/4, d-(ft*1.20)+self.CheckOffset(ft))
						except (IOError, NameError):
							print colorred % "Not chosen ttf font! Load default PIL font."
							self.dubsize = self.picsize
							ofset = (4, ysize-12)

					self.PrintTime(shotim, savpic, ofset)

			position += inter if n != (total-2) else halfin

		self.alshots = allshots


	def Make(self, savename):
		self.GetShots()
		fontcolor = self.GdkColorToRGB(FONTCOLOR)
		maincolor = self.GdkColorToRGB(MAINCOLOR)

		SZY = int(SMALXSIZ/float(self.picsize[0])*float(self.picsize[1]))
		IMS = [Image.open(fn) for fn in self.alshots]
		WFS = int(FONTSIZE*0.6)
		MSZ = 10

		sizex = SHOTCOLS*SMALXSIZ+(MSZ*2)+((SHOTCOLS-1)*MSZ)
		sizey = SHOTROWS*SZY+(MSZ*2)+((SHOTROWS-1)*MSZ)
	 
		try:
			rspc = MSZ*2
			fnsz = FONTSIZE*2
			self.shotfont = ImageFont.truetype(FONTNAME, fnsz)
			tbsz = MSZ+(FONTSIZE*3)+(WFS*2)-self.CheckOffset(fnsz)
			textbar = Image.new("RGBA", (sizex*2, tbsz*2), maincolor) 
		except (IOError, NameError):
			fnsz, tbsz, rspc = 8, 66, 14
			self.shotfont = ImageFont.load_default()      
			textbar = Image.new("RGBA", (sizex, tbsz), maincolor)
			if not PRINTTIME: 
				print colorred % "Not chosen ttf font! Load default PIL font."

		
		draw = ImageDraw.Draw(textbar)	   
		fullpic = Image.new('RGB', (sizex, sizey+tbsz-MSZ), maincolor)
  	   
		D = str(timedelta(seconds=self.videotime)).split(':')
		H = ' %s hr.' % D[0] if D[0] != '0' else ''
		F = self.HumanFormat(os.path.getsize(video))
		
		unictext = unicode("FILE: %s" % filename, 'utf-8') 
		vdformat = re.findall('VIDEO\:.*', self.videoinfo)[0]
		duration = ('DURATION:%s %s min. %s sec.  FILE SIZE: %s' % (H,D[1],D[2],F))
		
		Y = MSZ
		for field in (unictext, vdformat, duration):
			draw.text((rspc, Y), field, fontcolor, font=self.shotfont)
			Y += fnsz+WFS
	
		barresiz = textbar.resize((sizex, tbsz), Image.ANTIALIAS)
		fullpic.paste(barresiz, (0, 0))

		shadowbg = Image.new(self.picmode, (SMALXSIZ+MSZ, SZY+MSZ), maincolor)
		shadowbg.paste((10, 10, 10), [7, 8, 7+SMALXSIZ, 8+SZY])

		for n in range(3): shadowbg = shadowbg.filter(ImageFilter.BLUR)
	   
		for row in range(SHOTROWS):
			for col in range(SHOTCOLS):
				LEF = MSZ+col*(SMALXSIZ+MSZ)
				RIT = LEF+SMALXSIZ
				UPP = (SZY+MSZ)*row+tbsz
				LWR = UPP+SZY
		                   
				IMGBOX = (LEF, UPP, RIT, LWR)
				SHDBOX = (LEF-(MSZ/2), UPP-(MSZ/2))
			
				try: img = IMS.pop(0)
				except: break

				fullpic.paste(shadowbg, SHDBOX)
				fullpic.paste(img, IMGBOX)
		        
		fullpic.save(savename)
		for pic in self.alshots: os.remove(pic)
		os.rmdir(TMPDIR)


#################################################################################
def CreateAll(saveddir):
	savepath = os.path.join(saveddir, filename)
	savename = "%s.png" % savepath
	savenumb = 1

	while os.path.exists(savename):
		savename = ("%s-%s.png" % (savepath, savenumb))
		savenumb += 1

	Shot = MakeShot()
	Shot.Make(savename)

	if RUNPROGRM: call("%s '%s' &" % (RUNPROGRM, savename), shell=True)
	if SHOWNOTYF: 
		mess = Noti('Screenlist saved in', savename, 'dialog-information')
		mess.show()


#################################################################################
class FntSelDial(gtk.Builder):   
	def __init__(self, mainobject):
		super(FntSelDial, self).__init__()
		self.add_from_file('%s/FontSelect.ui' % APPDIR)
		self.dialog1.connect("destroy", self.closewin)
		self.connect_signals(self) 

		self.liststore1 = gtk.ListStore(str)
		self.treeview1 = gtk.TreeView(self.liststore1)
		renderer1 = gtk.CellRendererText()
		colFamily = gtk.TreeViewColumn("Family", renderer1, text=0)
		colFamily.set_sizing(gtk.TREE_VIEW_COLUMN_FIXED) 
		self.treeview1.append_column(colFamily)
		self.scrolledwindow1.add(self.treeview1)
		self.treeview1.connect("cursor_changed", self.fontclicked)

		self.liststore2 = gtk.ListStore(str, int)
		self.treeview2 = gtk.TreeView(self.liststore2)
		renderer2 = gtk.CellRendererText()
		colStyle = gtk.TreeViewColumn("Style", renderer2, text=0)
		colStyle.set_sizing(gtk.TREE_VIEW_COLUMN_FIXED) 
		self.treeview2.append_column(colStyle)
		renderer2b = gtk.CellRendererText()
		colFile = gtk.TreeViewColumn("File", renderer2b, text=1)
		colFile.set_sizing(gtk.TREE_VIEW_COLUMN_FIXED) 
		colFile.set_visible(False) 
		self.treeview2.append_column(colFile)
		self.scrolledwindow2.add(self.treeview2)
		self.treeview2.connect("cursor_changed", self.styleclicked)

		self.liststore3 = gtk.ListStore(int)
		self.treeview3 = gtk.TreeView(self.liststore3)
		renderer3 = gtk.CellRendererText()
		colSize = gtk.TreeViewColumn("Size", renderer3, text=0)
		colSize.set_sizing(gtk.TREE_VIEW_COLUMN_FIXED) 
		self.treeview3.append_column(colSize)
		self.scrolledwindow3.add(self.treeview3)
		self.treeview3.connect("cursor_changed", self.sizeclicked)

		for tre in (self.treeview1, self.treeview2, self.treeview3):
			tre.set_headers_visible(False)
			tre.set_fixed_height_mode(True)

		self.dialog1.show_all()
		try: self.currname, self.currstyle = FONTLABEL.split(', ')
		except ValueError: self.currname, self.currstyle = None, None

		self.sizelist = (6, 7, 8, 9, 10, 11, 12, 13, 14,
						 15, 16, 17, 18, 20, 22, 24, 26, 
						 28, 32, 36, 40, 48, 56, 64, 72)

		for num in self.sizelist:
			self.liststore3.append([num])
			if num == FONTSIZE: 
				cur = self.sizelist.index(num)
				self.treeview3.set_cursor_on_cell(cur)
				self.treeview3.scroll_to_cell(cur)
		
		self.fontssett()
		atl = AttrList()
		atl.insert(AttrFallback(False, 0, -1))
		self.entry2.get_layout().set_attributes(atl)
		self.adjustment1.set_value(FONTSIZE)
		self.responbutt = mainobject


	def __getattr__(self, attr):
		obj = self.get_object(attr)
		if not obj:
			raise AttributeError('object %s has no attribute %s' % (self,attr))
		setattr(self, attr, obj)
		return obj


	def fontssett(self):
		curs = 0
		for k in sorted(LISTSTYLS):
			self.liststore1.append([k])
			if k == self.currname:
				self.treeview1.set_cursor(curs)
			curs += 1


	def button2_clicked(self, widget):
		fontsel = self.treeview1.get_selection()
		fmodel, fitem = fontsel.get_selected_rows()
		stylsel = self.treeview2.get_selection()
		smodel, sitem = stylsel.get_selected_rows()
		font = fmodel[fitem[0][0]][0]
		styl = smodel[sitem[0][0]][0]
		path = FILESLIST[smodel[sitem[0][0]][1]]
		size = self.spinbutton1.get_value_as_int()
		full = '%s, %s' % (font, styl)
		self.responbutt(full, size)

		global FONTLABEL
		FONTLABEL = full
		global FONTNAME
		FONTNAME = path
		global FONTSIZE
		FONTSIZE = size
		self.dialog1.destroy()


	def checkstyle(self, style):
		if style == 'BoldOblique':
			style = 'Bold Oblique'
		if style == 'BoldItalic':
			style = 'Bold Italic'
		return style


	def fontprevmodify(self, fontname=None):
		alloc = self.entry2.get_allocation()
		if alloc.width > 1 and alloc.height > 1 :
			self.entry2.set_size_request(alloc.width, alloc.height)

		size = self.spinbutton1.get_value_as_int()*SCALE
		if fontname:
			fontdesc = FontDescription(fontname)
		else:
			fontsel = self.treeview1.get_selection()
			fmodel, fitem = fontsel.get_selected_rows()
			stylsel = self.treeview2.get_selection()
			smodel, sitem = stylsel.get_selected_rows()
			if not fitem or not sitem: return
			font = fmodel[fitem[0][0]][0]
			styl = self.checkstyle(smodel[sitem[0][0]][0])
			fullname = '%s, %s' % (font, styl)
			fontdesc = FontDescription(fullname)

		fontdesc.set_size(size)
		self.entry2.modify_font(fontdesc)


	def fontclicked(self, widget):
		select = self.treeview1.get_selection()
		model, item = select.get_selected_rows()
		if not item: return
		fontname = model[item[0][0]][0]
		self.liststore2.clear()
		allstyle = LISTSTYLS[fontname]
		curs = 0
		nocu = 1
		for a, b in allstyle:
			self.liststore2.append([a, b])
			if a == self.currstyle:
				self.treeview2.set_cursor_on_cell(curs)
				fntstyle = self.checkstyle(self.currstyle)
				nocu = 0
			curs += 1
		if nocu: 
			self.treeview2.set_cursor_on_cell(0)
			fntstyle = self.checkstyle(allstyle[0][0])
		fullname = '%s, %s' % (fontname, fntstyle)
		self.fontprevmodify(fullname)


	def styleclicked(self, widget):
		self.fontprevmodify()


	def sizeclicked(self, widget):
		select = self.treeview3.get_selection()
		model, item = select.get_selected_rows()
		if not item: return
		fontsize = model[item[0][0]][0]
		self.adjustment1.set_value(fontsize)
		self.fontprevmodify()


	def spinbutton1_value_changed(self, widget):
		sze = widget.get_value_as_int()
		if sze in self.sizelist:
			curnum = self.sizelist.index(sze)
			self.treeview3.set_cursor_on_cell(curnum)
			self.treeview3.scroll_to_cell(curnum)
		self.fontprevmodify()


	def button1_clicked(self, widget):
		self.dialog1.destroy()


	def closewin(self, widget):
		self.dialog1.destroy()


#################################################################################    	
class MakeScreenlist(gtk.Builder):   
	def __init__(self):
		super(MakeScreenlist, self).__init__()
		self.add_from_file('%s/MakeScreenlist.ui' % APPDIR)
		self.window1.connect("destroy", self.closewin)
		self.connect_signals(self) 
		self.window1.show_all()
		self.adjustment1.set_value(SHOTCOLS)
		self.adjustment2.set_value(SHOTROWS)
		self.adjustment3.set_value(SMALXSIZ)
		self.checkbutton2.set_active(PRINTTIME)
		if SAVETOVID: 
			self.checkbutton1.set_active(True)
			self.filechoosbut.set_current_folder(videodirname)
		else:
			self.filechoosbut.set_current_folder(DIRFORSAV)

		try: self.colorbutton1.set_color(gtk.gdk.Color(MAINCOLOR))
		except (TypeError, ValueError): pass
		try: self.colorbutton2.set_color(gtk.gdk.Color(FONTCOLOR))
		except (TypeError, ValueError): pass
		self.fontdial = False
		self.entry1.set_text(RUNPROGRM)
		self.fontbutsetlab(FONTLABEL, FONTSIZE)


	def __getattr__(self, attr):
		obj = self.get_object(attr)
		if not obj:
			raise AttributeError('object %s has no attribute %s' % (self,attr))
		setattr(self, attr, obj)
		return obj


	def fontbutsetlab(self, label=None, size=None):
		self.mainfontlabel.set_label(label)
		self.fontsizelabel.set_label(str(size))


	def button1pres(self, widget):
		global SHOTCOLS
		SHOTCOLS = self.spinbutton1.get_value_as_int()
		global SHOTROWS
		SHOTROWS = self.spinbutton2.get_value_as_int()
		global SMALXSIZ
		SMALXSIZ = self.spinbutton3.get_value_as_int()
		global RUNPROGRM
		RUNPROGRM = self.entry1.get_text()

		if self.fontdial: self.fontdial.dialog1.destroy()
		self.window1.destroy()
		CreateAll(SAV[0])

		if self.checkbutton1.get_active() == False:
			global DIRFORSAV
			DIRFORSAV = SAV[0]
 
		variables = (SMALXSIZ, SHOTCOLS, SHOTROWS, 
					 FONTSIZE, FONTNAME, FONTLABEL,
					 str(FONTCOLOR), str(MAINCOLOR),
					 RUNPROGRM, DIRFORSAV, SAVETOVID, PRINTTIME)

		setfile = ('%s/settings' % APPDIR)
		dumpset = open(setfile, 'w')
		pickle.dump(variables, dumpset)
		dumpset.close()	
		gtk.main_quit()
		os._exit(0)


	def filechoosbut_set(self, widget):
		del SAV[:]
		SAV.append(widget.get_filename())


	def folder_changed(self, widget):
		del SAV[:]
		SAV.append(widget.get_current_folder())


	def colorbutton1_set(self, widget):
		global MAINCOLOR
		MAINCOLOR = widget.get_color()


	def colorbutton2_set(self, widget):
		global FONTCOLOR
		FONTCOLOR = widget.get_color()


	def checkbutton1_toggled(self, widget):
		global DIRFORSAV
		if widget.get_active() == False:
			DIRFORSAV = SAV[0]
		else:	
			del SAV[:]
			SAV.append(videodirname)			
			DIRFORSAV = videodirname
			self.filechoosbut.set_current_folder(videodirname)

		global SAVETOVID
		SAVETOVID = widget.get_active()


	def checkbutton2_toggled(self, widget):
		global PRINTTIME
		PRINTTIME = True if widget.get_active() else False


	def fontbuttonpress(self, widget):
		if not FILESLIST: FontsParser()
		self.fontdial = FntSelDial(self.fontbutsetlab)


	def button2pres(self, widget):
		self.window1.destroy()
		gtk.main_quit()


	def closewin(self, widget):
		self.window1.destroy()
		gtk.main_quit()      
		
		
#################################################################################
if __name__ == "__main__":
	MakeScreenlist()
	gtk.main()

