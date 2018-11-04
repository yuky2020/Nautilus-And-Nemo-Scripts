#!/usr/bin/python

import os
import pygtk
pygtk.require('2.0')
import gtk
import gtkmozembed

homedir = os.path.expanduser('~')

try:
    from win32com.shell import shellcon, shell
    homedir = shell.SHGetFolderPath(0, shellcon.CSIDL_APPDATA, 0, 0)

except ImportError:
    homedir = os.path.expanduser("~/.gnome2/nemo-scripts/.hex_to_ascii/view.html")


class ColorChart:



	def __init__(self):

                self.moz = gtkmozembed.MozEmbed()
		box = gtk.VBox(False,0)

		win = gtk.Window()

		win.add(box)
		hbox = gtk.HBox(False,0)




                box.pack_start(hbox,False,False)
                hbox.show()
		box.pack_start(self.moz,True,True,0)


                self.moz.show()
		self.moz.load_url(homedir)
                self.moz.set_size_request(700,280)

		title=self.moz.get_title()
		win.set_title("HEX to ASCII")


		win.show_all()




if __name__ == "__main__":
	ColorChart()
	gtk.main()
