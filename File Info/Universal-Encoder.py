#!/usr/bin/python
# -*- coding: utf-8 -*-

# Author: Peter Kmet <thebestdeal1@gmail.com>
#
# Copyright: 2010 Peter Kmet
# License: GPL-2+
#  This program is free software; you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the Free
#  Software Foundation; either version 2 of the License, or (at your option)
#  any later version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
# On Debian GNU/Linux systems, the full text of the GNU General Public License
# can be found in the file /usr/share/common-licenses/GPL-2.

import os
import pygtk
pygtk.require('2.0')
import gtk
import subprocess



class PyENC:
        def quit(self):
		gtk.main_quit()

        def on_close_clicked(self, widget, event):
                      self.quit()


        def term(self,widget,data):
		subprocess.Popen(os.path.expanduser("~")+"/.gnome2/nemo-scripts/.universal-encoder/encoder.sh", shell=True)
        def term2(self,widget,data):
		subprocess.Popen(os.path.expanduser("~")+"/.gnome2/nemo-scripts/.universal-encoder/decoderhex.sh", shell=True)
        def term3(self,widget,data):
		subprocess.Popen(os.path.expanduser("~")+"/.gnome2/nemo-scripts/.universal-encoder/decoderint.sh", shell=True)
        def term4(self,widget,data):
		subprocess.Popen(os.path.expanduser("~")+"/.gnome2/nemo-scripts/.universal-encoder/decoder.sh", shell=True)
        def term5(self,widget,data):
		subprocess.Popen(os.path.expanduser("~")+"/.gnome2/nemo-scripts/.universal-encoder/decoder16.sh", shell=True)
        def term6(self,widget,data):
		subprocess.Popen(os.path.expanduser("~")+"/.gnome2/nemo-scripts/.universal-encoder/decoder32.sh", shell=True)
        def term7(self,widget,data):
		subprocess.Popen(os.path.expanduser("~")+"/.gnome2/nemo-scripts/.universal-encoder/decoder64.sh", shell=True)


	def __init__(self):

		self.window_width = 700
		self.window_height = 500
		self.border_size = 5
		self.vgap = 30
		self.label_width = 50
		self.label_height = 50
		self.renderer_height = 50
		self.getWindow()


	def getWindow(self):
		self.win = gtk.Window()
                self.win.set_position(gtk.WIN_POS_CENTER)
		self.win.connect('delete-event', self.on_close_clicked)
                self.win.set_icon_from_file(os.path.expanduser("~")+"/.gnome2/nemo-scripts/.universal-encoder/icon48.png")
		self.win.set_title("Universal Encoder/Decoder")
                self.win.set_resizable(False)
		self.win.set_default_size(500, 500)
		self.fixed = gtk.Fixed();
		self.win.add(self.fixed);
                self.MessageText()
                self.SetCat()
                self.SetCat2()
                self.SetCat3()
                self.SetCat4()
                self.SetCat5()
                self.SetCat6()
                self.SetCat7()
                self.CloseButton()
		self.win.show_all()

	def CloseButton(self):
		width = 100
		height = self.label_height
		self.close_eventBox = gtk.Button()
		self.close_eventBox.set_size_request(width,25)
		self.fixed.put(self.close_eventBox, self.border_size + 200, self.border_size+self.renderer_height+self.vgap+350)
		self.closeLabel = gtk.Label()
		self.closeLabel.set_markup("<span font_weight='bold' color='#000000'>Close</span>")
		self.closeLabel.set_justify(gtk.JUSTIFY_CENTER)
		self.close_eventBox.connect("button-press-event", self.on_close_clicked)
		self.close_eventBox.add(self.closeLabel)

        def SetCat(self):
		width = 400
		self.setcategory_eventBox = gtk.Button()
		self.setcategory_eventBox.set_size_request(width,30)
		self.fixed.put(self.setcategory_eventBox,  self.border_size + 50, 70)
		self.setcategoryLabel = gtk.Label()
		self.setcategoryLabel.set_markup("<span font_weight='bold' color='#000000'>Ascii to Hex/Decimal/Binary/Base 16 32 64</span>")
		self.setcategoryLabel.set_justify(gtk.JUSTIFY_CENTER)
		self.setcategory_eventBox.connect("button-press-event", self.term)
		self.setcategory_eventBox.add(self.setcategoryLabel)

        def SetCat2(self):
		width = 400
		self.setcategory_eventBox = gtk.Button()
		self.setcategory_eventBox.set_size_request(width,30)
		self.fixed.put(self.setcategory_eventBox,  self.border_size + 50, 120)
		self.setcategoryLabel = gtk.Label()
		self.setcategoryLabel.set_markup("<span font_weight='bold' color='#000000'>Hex to Ascii/Decimal/Binary/Base 16 32 64</span>")
		self.setcategoryLabel.set_justify(gtk.JUSTIFY_CENTER)
		self.setcategory_eventBox.connect("button-press-event", self.term2)
		self.setcategory_eventBox.add(self.setcategoryLabel)

        def SetCat3(self):
		width = 400
		self.setcategory_eventBox = gtk.Button()
		self.setcategory_eventBox.set_size_request(width,30)
		self.fixed.put(self.setcategory_eventBox,  self.border_size + 50, 170)
		self.setcategoryLabel = gtk.Label()
		self.setcategoryLabel.set_markup("<span font_weight='bold' color='#000000'>Decimal to Ascii/Hex/Binary/Base 16 32 64</span>")
		self.setcategoryLabel.set_justify(gtk.JUSTIFY_CENTER)
		self.setcategory_eventBox.connect("button-press-event", self.term3)
		self.setcategory_eventBox.add(self.setcategoryLabel)

        def SetCat4(self):
		width = 400
		self.setcategory_eventBox = gtk.Button()
		self.setcategory_eventBox.set_size_request(width,30)
		self.fixed.put(self.setcategory_eventBox,  self.border_size + 50, 220)
		self.setcategoryLabel = gtk.Label()
		self.setcategoryLabel.set_markup("<span font_weight='bold' color='#000000'>Binary to Ascii/Decimal/Hex/Base 16 32 64</span>")
		self.setcategoryLabel.set_justify(gtk.JUSTIFY_CENTER)
		self.setcategory_eventBox.connect("button-press-event", self.term4)
		self.setcategory_eventBox.add(self.setcategoryLabel)

        def SetCat5(self):
		width = 400
		self.setcategory_eventBox = gtk.Button()
		self.setcategory_eventBox.set_size_request(width,30)
		self.fixed.put(self.setcategory_eventBox,  self.border_size + 50, 270)
		self.setcategoryLabel = gtk.Label()
		self.setcategoryLabel.set_markup("<span font_weight='bold' color='#000000'>Base16 to Ascii/Decimal/Binary/Hex/Base 32 64</span>")
		self.setcategoryLabel.set_justify(gtk.JUSTIFY_CENTER)
		self.setcategory_eventBox.connect("button-press-event", self.term5)
		self.setcategory_eventBox.add(self.setcategoryLabel)

        def SetCat6(self):
		width = 400
		self.setcategory_eventBox = gtk.Button()
		self.setcategory_eventBox.set_size_request(width,30)
		self.fixed.put(self.setcategory_eventBox,  self.border_size + 50, 320)
		self.setcategoryLabel = gtk.Label()
		self.setcategoryLabel.set_markup("<span font_weight='bold' color='#000000'>Base32 to Ascii/Decimal/Binary/Hex/Base 16 64</span>")
		self.setcategoryLabel.set_justify(gtk.JUSTIFY_CENTER)
		self.setcategory_eventBox.connect("button-press-event", self.term6)
		self.setcategory_eventBox.add(self.setcategoryLabel)

        def SetCat7(self):
		width = 400
		self.setcategory_eventBox = gtk.Button()
		self.setcategory_eventBox.set_size_request(width,30)
		self.fixed.put(self.setcategory_eventBox,  self.border_size + 50, 370)
		self.setcategoryLabel = gtk.Label()
		self.setcategoryLabel.set_markup("<span font_weight='bold' color='#000000'>Base64 to Ascii/Decimal/Binary/Hex/Base 16 32</span>")
		self.setcategoryLabel.set_justify(gtk.JUSTIFY_CENTER)
		self.setcategory_eventBox.connect("button-press-event", self.term7)
		self.setcategory_eventBox.add(self.setcategoryLabel)

        def MessageText(self):
		width = 500
		height = self.label_height
		self.message_eventBox = gtk.EventBox()
		self.message_eventBox.set_size_request(width,self.label_height)
		self.fixed.put(self.message_eventBox, self.border_size, self.border_size)
		self.messageLabel = gtk.Label()
		self.messageLabel.set_markup("<span font_weight='bold' color='#000000'>Select the required Encoder/Decoder to start</span>")
		self.messageLabel.set_justify(gtk.JUSTIFY_CENTER)
		self.message_eventBox.add(self.messageLabel)


if __name__ == "__main__":
	PyENC()
	gtk.main()
