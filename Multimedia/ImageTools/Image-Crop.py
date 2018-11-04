#!/usr/bin/env python
# -*- coding: utf-8 -*-

def errorDialog(txt):
    try:
        import Tkinter
        master = Tkinter.Tk()
        w = Tkinter.Message(master, text=txt)
        w.pack()
        Tkinter.mainloop()
    except ImportError:
        from os import system
        zenityNotInstalled = system("command -v zenity")
        if not zenityNotInstalled:
            system("zenity --info --text='" + txt + "'")
        else:
            system("xterm -hold -geometry 150x1 -bg red -T '" + txt + "' -e true")
    import sys
    sys.exit()

try:
    import pygtk
    pygtk.require('2.0') 
    import gtk
    import cairo
    import Image
except ImportError:
    errorDialog("This script needs gtk, pygtk 2.8 or higher pycairo and Python Image Library (PIL)")
except AssertionError:
    errorDialog("This script needs pygtk 2.8 or later")




class CropWidget(gtk.DrawingArea):
    def __init__(self,file):
        self.havep0 = False
        self.imgg = file
        gtk.DrawingArea.__init__(self)
        self.add_events(gtk.gdk.BUTTON_PRESS_MASK |
                gtk.gdk.BUTTON1_MOTION_MASK)
        self.connect("motion_notify_event",self.move)
        self.connect("button_press_event",self.clic)
        self.connect("expose_event", self.expose)
        
        pixbuf = self.pixbuf = gtk.gdk.pixbuf_new_from_file(self.imgg)
        self.iw = iw = pixbuf.get_width()
        self.ih = ih = pixbuf.get_height()
        
        w,h = iw,ih
        
        rat = float(iw)/ih
        if rat < 600/400 :
            if iw > 600:
                w = 600.0
                h = w/rat
        else:
            if ih > 400:
                h = 400.0
                w = rat*h
        self.wi,self.he = w,h
        
        self.set_size_request(int(w),int(h))
        
    def clic(self,widget,event):
        self.havep0 = True
        self.x1 = min(event.x,self.iw)
        self.y1 = min(event.y,self.ih)
        
    def move(self, widget,event):
        self.px = min(event.x,self.iw)
        self.py = min(event.y,self.ih)
        self.queue_draw()
        
    def expose(self, widget, event):
        self.context = widget.window.cairo_create()
        
        self.context.rectangle(event.area.x, event.area.y,
                               event.area.width, event.area.height)
        self.context.clip()
        
        self.draw(self.context)
        return False
    
    def draw(self, context):
        ctx = context
        rect = self.get_allocation()
        x = rect.x + rect.width 
        y = rect.y + rect.height

        pixbuf = self.pixbuf
        format = cairo.FORMAT_RGB24
        if pixbuf.get_has_alpha():
                format = cairo.FORMAT_ARGB32
        ctx.save()
        iw = pixbuf.get_width()
        ih = pixbuf.get_height()
        ctx.scale(float(self.wi)/iw,float(self.he)/ih)
        image = cairo.ImageSurface(format, iw, ih)
        image = ctx.set_source_pixbuf(pixbuf, 0, 0)
        
        ctx.paint()
        ctx.restore()
        
        if not self.havep0:
            return
        
        ctx.set_source_rgba(0,0,0,0.7)
        
        x1,x2,y1,y2 = self.x1,self.px,self.y1,self.py
        
        if ((y1 > y2) and (x1 < x2)) or ((y1 < y2) and (x1 > x2)):
            x1,y1,x2,y2 = x1,y2,x2,y1
        
        xx1,yy1,xx2,yy2 = 0,0,iw,ih
        
        ctx.move_to(xx1,yy1)
        
        for i in ((xx2,yy1),(xx2,y2),(x2,y2),(x2,y1),(x1,y1),(x1,y2),
                    (x2,y2),(xx2,y2),(xx2,yy2),(xx1,yy2),(xx1,yy1)):
            ctx.line_to(i[0],i[1])
            
        
        ctx.fill()



class cropWin():
    def askforfile(self,wtf=0):
        
        fc = gtk.FileChooserDialog("Select where to save the cropped image",
                self.window, gtk.FILE_CHOOSER_ACTION_SAVE,
                (gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL,gtk.STOCK_SAVE, gtk.RESPONSE_OK))
        res = fc.run()
        if res == gtk.RESPONSE_OK:
            self.fs_button.set_label(fc.get_filename())
        else:
            self.fs_button.set_label("Select")
            
        self.selectext()
        fc.destroy()
    def toggle_radio(self,radio):
        self.fs_button.set_sensitive(radio.get_active())
        
    def save(self,*wtf):
        i = self.cw
        if not i.havep0:
            errorDialog("Select an area of the image by clicking and dragging")
            return
        pixbuf = i.pixbuf
        iw,ih = pixbuf.get_width(),pixbuf.get_height()
        x1,x2,y1,y2 = (i.x1/i.wi)*iw,(i.px/i.wi)*iw,(i.y1/i.he)*ih,(i.py/i.he)*ih
        x1,x2,y1,y2 = int(x1),int(x2),int(y1),int(y2)
        im = Image.open(self.file)
        im = im.crop((min(x1,x2),min(y1,y1),max(x1,x2),max(y1,y2)))
        
        file = self.fs_button.get_label()
        if self.r1.get_active():
            file = self.file
        im.save(file)
        self.destroy()
        
    def fixfilename(self,wtf):
        if not wtf.get_active():
            return
        
        afn = self.fs_button.get_label()
        axt = afn.split(".")[-1].lower()
        nex = wtf.get_label().lower()
        
        if axt == nex:
            return

        if axt.count("/") > 0:
            self.fs_button.set_label(afn + "." + axt)
        else:
            if afn.count(".") == 0:
                self.fs_button.set_label(afn + "." + nex )
            else:
                self.fs_button.set_label(".".join(afn.split(".")[:-1])  + "." + nex )
                
    def selectext(self):
        afn = self.fs_button.get_label()
        axt = afn.split(".")[-1].lower()
        if axt in self.ext:
            self.rbs[self.ext.index(axt)].set_active(True)
        else:
            for rb in self.rbs:
                if rb.get_active():
                    self.fs_button.set_label(afn  + "." + rb.get_label() )
                    return
        
    def __init__(self,file):
        self.file = file
        w = self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        i = self.cw = CropWidget(file)
        mainvbox = gtk.VBox(False, 10)
        
        save_vbox = gtk.VBox(False,5)
        save_hbox = gtk.HBox(False,5)
        save_frame = gtk.Frame("Save")
        save_btn = gtk.Button("Keep")
        cancel_btn = gtk.Button("Cancel")
        cancel_btn.connect("clicked",self.destroy)
        
        save_hboxb = gtk.HBox(False,5)
        save_hboxb.pack_start(save_btn)
        save_hboxb.pack_start(cancel_btn)
        
        r1 = self.r1 = gtk.RadioButton(None,"Replace the original image")
        r2 = self.r2 = gtk.RadioButton(r1,"Save as ...")
        
        ext = self.ext = ["png","jpeg","bmp","gif","tiff"]
        self.rbs = []
        group = None
        format_vbox = gtk.VBox(False,5)
        for ex in ext:
            rf = gtk.RadioButton(group,ex)
            group = rf
            format_vbox.pack_start(rf)
            self.rbs.append(rf)
            rf.set_sensitive(False)
            rf.connect("toggled",self.fixfilename)
            

        format_frame = gtk.Frame("Format")
        format_frame.add(format_vbox)
        
        
        fs_button = self.fs_button = gtk.Button("Select")
        fs_button.connect("clicked",self.askforfile)
        
        r2.connect("toggled",lambda radio: ((fs_button.set_sensitive(radio.get_active()) or True) and [rb.set_sensitive(radio.get_active()) for rb in self.rbs] ))
        fs_button.set_sensitive(False)
            
        
        save_btn.connect("clicked",self.save)
        
        save_vbox.pack_start(r1)
        save_vbox.pack_start(save_hbox)
        save_hbox.pack_start(r2,False)
        save_hbox.pack_start(fs_button,False)
        save_frame.add(save_vbox)
        
        mainvbox.pack_start(gtk.Label("Click and drag to select the area to cut"),False)
        mainvbox.pack_start(i,False)
        mainvbox.pack_start(save_frame,False)
        mainvbox.pack_start(format_frame,False)
        mainvbox.pack_start(save_hboxb,False)
        
        
        w.add(mainvbox)
        
        
        w.set_resizable(True)
        w.connect("destroy", self.destroy)
        
        w.show_all()
        gtk.main()
        
    def destroy(self,*wtf):
        self.window.destroy()
        gtk.main_quit()
        

from sys import argv
if len(argv) >1:
    args = argv[1:] #firs argment is file name, so ignore it
    for arg in args:
        cropWin(arg)


