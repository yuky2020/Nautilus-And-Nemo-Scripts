#!/usr/bin/python

#requires the following:
#sudo apt-get install curl
#curl http://apt.wxwidgets.org/key.asc | apt-key add -
#sudo apt-get update
#sudo apt-get install python-wxgtk2.8 python-wxtools wx2.8-i18n
#sudo apt-get install python-gdata

import wx
import os
import sys

def pinger():
	f = os.popen('ping -c 1 google.com')
	y = ''
	for x in f.readlines():
		y += x
	a = y.find('--- google.com ping statistics ---')
	return a
#a = pinger()
"""abc = wx.ShowMessageDialog(None,-1,'No Internet connectoin found!. Will now exit','Error')
		abc.ShowModal()
		abc.Destroy()
		self.Destroy()
		return False"""


#uplist = ['115.com','2shared','4shared','Badongo','Data.hu','DepositFiles','divShare','dl.free.fr','Humyo','Mediafire*','Megaupload','Netload.in','Rapidshare*','Sendspace','Uploading.com','Usershare','x7.to','ZShare']
uplist = ['Megaupload','2shared','Mediafire*','ZShare']
uplist2 =['megaupload','2shared','mediafire','zshare']
class FinalFrame(wx.Frame):
	def __init__(self):
		pass
	mupl = ''
	tshl = ''
	medl = ''
	zshl = ''
	def add(self,typ,string):
		if typ == 0:
			self.mupl += string + '\n\n'
		elif typ == 1:
			self.tshl += string + '\n\n'
		elif typ == 2:
			self.medl += string + '\n\n'
		elif typ == 3:
			self.zshl += string + '\n\n'
	def doit(self):
		self.display(self.mupl,self.tshl,self.medl,self.zshl)
		self.Show()
	def display(self,megaupload_links,tshared_links,mediafire_links,zshare_links):
		wx.Frame.__init__(self,None,-1,'Upload Complete!',size=(600,550))
		self.panel = wx.Panel(self)
		wx.StaticText(self.panel,-1,'Your Upload has completed :) Here are your links:',pos = (30,30))
		wx.StaticText(self.panel,-1,'Megaupload links:',pos=(30,80))
		mupld_link_box = wx.TextCtrl(self.panel,-1,megaupload_links,size=(540,80),pos=(30,100),style=wx.TE_MULTILINE | wx.TE_READONLY)
		wx.StaticText(self.panel,-1,'2shared links:',pos=(30,190))
		tshrd_link_box = wx.TextCtrl(self.panel,-1,tshared_links,size=(540,80),pos=(30,210),style=wx.TE_MULTILINE | wx.TE_READONLY)
		wx.StaticText(self.panel,-1,'Mediafire links:',pos=(30,300))
		mfire_link_box = wx.TextCtrl(self.panel,-1,mediafire_links,size=(540,80),pos=(30,320),style=wx.TE_MULTILINE | wx.TE_READONLY)
		wx.StaticText(self.panel,-1,'ZShare Links:',pos=(30,410))
		zshre_link_box = wx.TextCtrl(self.panel,-1,zshare_links,size=(540,80),pos=(30,430),style=wx.TE_MULTILINE | wx.TE_READONLY)

class MyFrame(wx.Frame):
	fframe = FinalFrame()
	def __init__(self):
		self.param = ''
		self.check=0
		self.args = sys.argv[1:]
		if len(self.args)==0:
			self.check=1
		wx.Frame.__init__(self,None,-1,'Pshare',size=(600,330))
		self.panel = wx.Panel(self)
		wx.StaticText(self.panel,-1,'Welcome to the Plowshare Uploader GUI.\n\nThis app lets you upload any file to any of the supported file-sharing sites. To proceed, please select one (or more) of the uploading sites:',pos = (30,30), size = (540,70))

		wx.StaticText(self.panel,-1,'Available Sites to upload:',pos = (30,160))

		self.choice_box = wx.ListBox(self.panel,-1,(30,120),(540,100),uplist, wx.LB_EXTENDED | wx.LB_HSCROLL)

		wx.StaticText(self.panel,-1,'*Upload to these sites may NOT work at the moment; developers are trying to fix the issues',pos=(30,225),size=(540,50))



		if self.check==1:
			self.button_browse_files = wx.Button(self.panel,-1,'Browse for files',pos=(420,270),size=(150,30))
			self.button_upload = wx.Button(self.panel,-1,'Start Upload',pos=(30,270),size=(150,30))
			self.button_login_mupload = wx.Button(self.panel,-1,'Login to Megaupload Account',pos=(190,270),size = (220,30))
			self.Bind(wx.EVT_BUTTON,self.browsefiles,self.button_browse_files)
		else:
			self.button_upload = wx.Button(self.panel,-1,'Start Upload',pos=(30,270),size=(265,30))
			self.button_login_mupload = wx.Button(self.panel,-1,'Login to Megaupload Account',pos=(305,270),size = (265,30))
		self.Bind(wx.EVT_BUTTON,self.upload,self.button_upload)
		self.Bind(wx.EVT_BUTTON,self.login_mega,self.button_login_mupload)
	def upload(self,evt):
		temp1 = len(self.args)
		temp2 = len(self.choice_box.GetSelections())
		if temp1==0:
			nofile_dlg = wx.MessageDialog(None,'No files Chosen!\nChoose atleast 1 file','Error',wx.OK | wx.ICON_ERROR)
			nofile_dlg.ShowModal()
			nofile_dlg.Destroy()
			return
		if temp2==0:
			nofile_dlg = wx.MessageDialog(None,'No Upload sites Chosen!\nChoose atleast 1 Upload Site','Error',wx.OK | wx.ICON_ERROR)
			nofile_dlg.ShowModal()
			nofile_dlg.Destroy()
			return
		self.udlg = wx.ProgressDialog('Processing Request','Wait while we upload your file(s)',maximum=60)
		self.udlg.Update(1)
		y = 0
		temp2 = 30/temp1
		val = 'bash ~/.plowshare/src/upload.sh '
		for x in self.args:
			val += '\"' + x + '\" '
			y += temp2
			self.udlg.Update(y)
		y = 30
		self.linkss = []
		#print val
		temp3 = self.choice_box.GetSelections()
		#print temp3
		for x in temp3:
			temp4 = val
			if uplist2[x] == 'megaupload':
				temp4 += self.param
			temp4 += uplist2[x]
			#print temp4
			file1=os.popen(temp4)
			file1_lines = file1.readlines()
			if len(file1_lines)==0:
				err_dlg = wx.MessageDialog(None,'Upload Failed! Possible Reasons:\n1. No Internet connection\n2. Upload error (choose different upload\nsite in this case)','Error',wx.OK | wx.ICON_ERROR)
				err_dlg.ShowModal()
				err_dlg.Destroy()
				self.udlg.Update(60)
				self.udlg.Destroy()
				return;
			for x2 in file1_lines:
				ind = x2.find('(http:')
				if ind != -1:
					x2 = 'Link\n====================\n' + x2[0:ind] + '\n\nDelete_link\n====================\n' + x2[ind+1:]
				self.fframe.add(x,x2)
			y += temp2
			self.udlg.Update(y)
		self.fframe.doit()
		self.udlg.Update(60)
		self.udlg.Destroy()
		##
		self.panel.Destroy()
		self.Destroy()

	def login_mega(self,evt):
		self.username = ''
		self.password = ''
		ubox = wx.TextEntryDialog(None,"Please Enter Username","UserName",'username')
		if ubox.ShowModal()==wx.ID_OK:
			self.username = ubox.GetValue()
			ubox.Destroy()
			ubox = wx.TextEntryDialog(None,'Please Enter Password','Password','********',wx.TE_PASSWORD | wx.OK | wx.CANCEL)
			if ubox.ShowModal()==wx.ID_OK:
				self.password = ubox.GetValue()
				self.param = ' -a ' + self.username + ':' + self.password + ' '
				#print '\n\n' + self.param + '\n\n'
		ubox.Destroy()
	def browsefiles(self,evt):
		filed = wx.FileDialog(None,"Choose a file",style=wx.FD_MULTIPLE)
		filed.ShowModal()
		a = filed.GetPaths()
#		print a
		if len(a) > 0:
			self.args = a
#		print len(self.args)
		filed.Destroy()
class MyApp(wx.App):
	def OnInit(self):
		frame = MyFrame()
		frame.Show()
		return True
if __name__=='__main__':
	app = MyApp(redirect=True)
	app.MainLoop()
