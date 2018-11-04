#!/usr/bin/env python
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# File name: gnome-wallpaper-slideshow.py
# Author: Stewart Gateley <birbeck@gmail.com>, Copyright (c) 2010
#
# gnome-wallpaper-slideshow is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# gnome-wallpaper-slideshow is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with gnome-wallpaper-slideshow. If not, see http://www.gnu.org/licenses/.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

import os
import gtk, gobject
import gconf
import libxml2
import sys, getopt

class GTK_Main:
    
    def __init__(self):
        self.conf_dir_path = os.path.expanduser("~/.gnome-wallpaper-slideshow/")
        self.conf_file_path = os.path.join(self.conf_dir_path, "gnome-wallpaper-slideshow.config")
        self.xml_file_path = os.path.join(self.conf_dir_path, "gnome-wallpaper-slideshow.xml")

        # Create GTK Window
        self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        self.window.set_title("Gnome Wallpaper Slideshow")
        self.window.set_resizable(False)
        self.window.connect("destroy", gtk.main_quit)
       
        # Create window objects
        vbox = gtk.VBox()

        label = gtk.Label("Folder:")
        label.set_alignment(0.0, 0.5)
        self.folder_entry = gtk.Entry()
        button = gtk.Button("Select...")
        button.connect("clicked", self.button_clicked)
        hbox = gtk.HBox()
        hbox.pack_start(label, True)
        hbox.pack_start(self.folder_entry, False)
        hbox.pack_start(button, False)
        vbox.pack_start(hbox, False)
        
        label = gtk.Label("Picture duration:")
        label.set_alignment(0.0, 0.5)
        adj = gtk.Adjustment(5.0, 1.0, 60.0, 1.0, 1.0, 0.0)
        self.pdur_spinner = gtk.SpinButton(adj)
        self.pdur_combo = gtk.combo_box_new_text()
        self.pdur_combo.append_text("hr")
        self.pdur_combo.append_text("min")
        self.pdur_combo.append_text("sec")
        self.pdur_combo.set_active(1)
        hbox = gtk.HBox()
        hbox.pack_start(label, True)
        hbox.pack_start(self.pdur_spinner, False)
        hbox.pack_start(self.pdur_combo, False)
        vbox.pack_start(hbox, False)
        
        label = gtk.Label("Transition duration:")
        label.set_alignment(0.0, 0.5)
        adj = gtk.Adjustment(5.0, 0.0, 60.0, 1.0, 1.0, 0.0)
        self.tdur_spinner = gtk.SpinButton(adj)
        self.tdur_combo = gtk.combo_box_new_text()
        self.tdur_combo.append_text("hr")
        self.tdur_combo.append_text("min")
        self.tdur_combo.append_text("sec")
        self.tdur_combo.set_active(2)
        hbox = gtk.HBox()
        hbox.pack_start(label, True)
        hbox.pack_start(self.tdur_spinner, False)
        hbox.pack_start(self.tdur_combo, False)
        vbox.pack_start(hbox, False)
        
        self.cancel_button = gtk.Button(stock=gtk.STOCK_CLOSE)
        self.cancel_button.connect("clicked", gtk.main_quit)
        self.ok_button = gtk.Button(stock=gtk.STOCK_OK)
        self.ok_button.set_sensitive(False)
        self.ok_button.connect("clicked", self.ok_button_clicked)
        hbox = gtk.HBox()
        hbox.pack_end(self.ok_button, False)
        hbox.pack_end(self.cancel_button, False)
        vbox.pack_end(hbox, False, False, 10)
        
        # Read settings
        try:
            settings = {}
            conf_file = open(self.conf_file_path, "r")
            for line in conf_file.readlines():
                (key, var) = line.strip().split(" ")
                settings[key] = var
    
            if settings['Folder']:
                self.folder_entry.set_text(settings['Folder'])
                self.files = []
                accepted = ('.jpg', '.jpeg', '.gif', '.png')
                for file in os.listdir(settings['Folder']):
                    if os.path.splitext(file)[1].lower() in accepted:
                        self.files.append(os.path.join(settings['Folder'], file))
                if len(self.files):
                    self.ok_button.set_sensitive(True)
    
            picture_duration = float(settings['PictureDuration'])
            if picture_duration % 3600 == 0:
                self.pdur_spinner.set_value(picture_duration / 3600)
                self.pdur_combo.set_active(0)
            elif picture_duration % 60 == 0:
                self.pdur_spinner.set_value(picture_duration / 60)
                self.pdur_combo.set_active(1)
            else:
                self.pdur_spinner.set_value(picture_duration)
                self.pdur_combo.set_active(2)
    
            transition_duration = float(settings['TransitionDuration'])
            if  transition_duration % 3600 == 0:
                self.tdur_spinner.set_value(transition_duration / 3600)
                self.tdur_combo.set_active(0)
            elif transition_duration % 60 == 0:
                self.tdur_spinner.set_value(transition_duration / 60)
                self.tdur_combo.set_active(1)
            else:
                self.tdur_spinner.set_value(transition_duration)
                self.tdur_combo.set_active(2)
        except IOError:
            pass
        except RuntimeError as strerror:
            print "Failed to parse config file: strerror"

        # Show entire window
        self.window.add(vbox)
        self.window.show_all()
        
    def button_clicked(self, button):
        dialog = gtk.FileChooserDialog("Open..", None, gtk.FILE_CHOOSER_ACTION_SELECT_FOLDER,
                                       (gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL,
                                        gtk.STOCK_OK, gtk.RESPONSE_OK))
        dialog.set_default_response(gtk.RESPONSE_OK)
        if self.folder_entry.get_text():
            dialog.set_filename(self.folder_entry.get_text() + "/*")
        else:
            dialog.set_filename(os.path.expanduser("~/Pictures/*"))
        response = dialog.run()
        filename = dialog.get_filename()
        dialog.destroy()

        if response == gtk.RESPONSE_OK:
            self.folder_entry.set_text(filename)
            self.files = []
            accepted = ('.jpg', '.jpeg', '.gif', '.png')
            for file in os.listdir(filename):
                if os.path.splitext(file)[1].lower() in accepted:
                    self.files.append(os.path.join(filename, file))
            
            if len(self.files):
                self.ok_button.set_sensitive(True)
            else:
                self.ok_button.set_sensitive(False)
                dialog = gtk.MessageDialog(parent = None, flags = gtk.DIALOG_DESTROY_WITH_PARENT,
                    type = gtk.MESSAGE_ERROR, buttons = gtk.BUTTONS_OK,
                    message_format = "Folder contains no images")
                dialog.set_title('Error')
                dialog.connect('response', lambda dialog, response: dialog.destroy())
                dialog.run()
        
    def ok_button_clicked(self, button):
        self.files = sorted(self.files)
        nfiles = len(self.files)
        if nfiles <= 0:
            return False
        
        # Read settings
        folder = self.folder_entry.get_text()

        picture_duration = float(self.pdur_spinner.get_text())
        if self.pdur_combo.get_active_text() == "min":
            picture_duration = picture_duration * 60
        elif self.pdur_combo.get_active_text() == "hr":
            picture_duration = picture_duration * 60 * 60
        
        transition_duration = float(self.tdur_spinner.get_text())
        if self.tdur_combo.get_active_text() == "min":
            transition_duration = transition_duration * 60
        elif self.tdur_combo.get_active_text() == "hr":
            transition_duration = transition_duration * 60 * 60
         
        # Save settings
        if not os.path.exists(self.conf_dir_path):
            os.mkdir(self.conf_dir_path, 0755)

        settings = "Folder %s\nPictureDuration %d\nTransitionDuration %d\n" % (
            folder, picture_duration, transition_duration)
        conf_file = open(self.conf_file_path, "w")
        conf_file.write(settings)
        conf_file.close()

        # Create wallpaper xml
        doc = libxml2.parseDoc("""<background><starttime><year>2010</year><month>01</month><day>01</day><hour>00</hour><minute>00</minute><second>00</second></starttime></background>""")
        root = doc.getRootElement()
        
        for i in range(0, nfiles):
            static = root.newChild(None, "static", None)
            static.addChild(static.newChild(None, "duration", str(picture_duration)))
            static.addChild(static.newChild(None, "file", self.files[i]))
            root.addChild(static)

            if transition_duration <= 0: continue

            transition = root.newChild(None, "transition", None)
            transition.addChild(transition.newProp("type", "overlay"))
            transition.addChild(transition.newChild(None, "duration", str(transition_duration)))
            transition.addChild(transition.newChild(None, "from", self.files[i]))
            if i < nfiles-1:
                transition.addChild(transition.newChild(None, "to", self.files[i+1]))
            else:
                transition.addChild(transition.newChild(None, "to", self.files[0]))
            root.addChild(transition)
            
        # Write XML file
        try:
            doc.saveFormatFileEnc(self.xml_file_path, "utf-8", 1)
        except IOError as (errno, strerror):
            dialog = gtk.MessageDialog(parent = None, flags = gtk.DIALOG_DESTROY_WITH_PARENT,
                type = gtk.MESSAGE_ERROR, buttons = gtk.BUTTONS_OK,
                message_format = strerror)
            dialog.set_title('Error')
            dialog.connect('response', lambda dialog, response: dialog.destroy())
            dialog.run()
            return False
        
        # Parse gnome backgrounds.xml file
        backgrounds_file = os.path.expanduser("~/.gnome2/backgrounds.xml")
        doc = libxml2.parseFile(backgrounds_file)
        root = doc.getRootElement()
        
        # Look for existing wallpaper entry
        ctxt = doc.xpathNewContext()
        res = ctxt.xpathEval("/wallpapers/wallpaper[filename=\""+self.xml_file_path+"\"]")
        
        # If no entry exists, add one
        if len(res) == 0:
            wallpaper = root.newChild(None, "wallpaper", None)
            wallpaper.addChild(wallpaper.newProp("deleted", "false"))
            wallpaper.addChild(wallpaper.newChild(None, "name", "gnome-wallpaper-slideshow"))
            wallpaper.addChild(wallpaper.newChild(None, "filename", self.xml_file_path))
            wallpaper.addChild(wallpaper.newChild(None, "options", "stretched"))
            wallpaper.addChild(wallpaper.newChild(None, "shade_type", "solid"))
            wallpaper.addChild(wallpaper.newChild(None, "pcolor", "#2c2c00001e1e"))
            wallpaper.addChild(wallpaper.newChild(None, "scolor", "#2c2c00001e1e"))
            root.addChild(wallpaper)

            try:
                doc.saveFormatFileEnc(backgrounds_file, "utf-8", 1)
            except IOError as (errno, strerror):
                    dialog = gtk.MessageDialog(parent = None, flags = gtk.DIALOG_DESTROY_WITH_PARENT,
                        type = gtk.MESSAGE_ERROR, buttons = gtk.BUTTONS_OK,
                        message_format = strerror)
                    dialog.set_title('Error')
                    dialog.connect('response', lambda dialog, response: dialog.destroy())
                    dialog.run()
                    return False
        
        # Set xml file as current background
        conf_client = gconf.client_get_default()
        conf_client.add_dir("/desktop/gnome/background", gconf.CLIENT_PRELOAD_NONE)
        conf_client.set_string("/desktop/gnome/background/picture_filename", self.xml_file_path)
        conf_client.set_string("/desktop/gnome/background/picture_options", "stretched")

        # Exit gtk main loop
        gtk.main_quit()

def main(argv):
    # Set default durations
    picture_duration = 300.0
    transition_duration = 5.0

    # Parse the command line arguments
    try:
        opts, args = getopt.getopt(argv, "hp:t:", ["help", "picture-duration=", "transition-duration="])
        for opt, arg in opts:
            if opt in ("-h", "--help"):
                usage()
                sys.exit(0)
            elif opt in ("-p", "--picture-duration"):
                if arg.isdigit():
                    picture_duration = float(arg)
                else:
                    usage()
                    sys.exit(1)
            elif opt in ("-t", "--transition-duration"):
                if arg.isdigit():
                    transition_duration = float(arg)
                else:
                    usage()
                    sys.exit(1)
    except getopt.GetoptError:
        usage()
        sys.exit(2)

    # Make sure folder exists before continuing
    folder = "".join(args)
    if not os.path.isdir(folder):
        print "Folder '" + folder + "' does not exist."
        sys.exit(1)

    # Search for valid files
    files = []
    accepted = ('.jpg', '.jpeg', '.gif', '.png')
    for file in os.listdir(folder):
        if os.path.splitext(file)[1].lower() in accepted:
            files.append(os.path.join(folder, file))
    files = sorted(files)
    
    # Exit if no images found
    nfiles = len(files)
    if nfiles < 1:
        print "Folder '" + folder + "' contains no images."
        sys.exit(1)

    # Create wallpaper xml
    doc = libxml2.parseDoc("""<background><starttime><year>2010</year><month>01</month><day>01</day><hour>00</hour><minute>00</minute><second>00</second></starttime></background>""")
    root = doc.getRootElement()
    
    for i in range(0, nfiles):
        static = root.newChild(None, "static", None)
        static.addChild(static.newChild(None, "duration", str(picture_duration)))
        static.addChild(static.newChild(None, "file", files[i]))
        root.addChild(static)

        if transition_duration <= 0: continue

        transition = root.newChild(None, "transition", None)
        transition.addChild(transition.newProp("type", "overlay"))
        transition.addChild(transition.newChild(None, "duration", str(transition_duration)))
        transition.addChild(transition.newChild(None, "from", files[i]))
        if i < nfiles-1:
            transition.addChild(transition.newChild(None, "to", files[i+1]))
        else:
            transition.addChild(transition.newChild(None, "to", files[0]))
        root.addChild(transition)
        
    # Write XML file
    if not os.path.exists(os.path.expanduser("~/.gnome-wallpaper-slideshow")):
        os.mkdir(os.path.expanduser("~/.gnome-wallpaper-slideshow"), 0755)
    xml_file_path = os.path.expanduser("~/.gnome-wallpaper-slideshow/gnome-wallpaper-slideshow.xml")
    try:
        doc.saveFormatFileEnc(xml_file_path, "utf-8", 1)
    except IOError:
        print "Failed to write file."
        sys.exit(2)
    
    # Parse gnome backgrounds.xml file
    backgrounds_file = os.path.expanduser("~/.gnome2/backgrounds.xml")
    doc = libxml2.parseFile(backgrounds_file)
    root = doc.getRootElement()
    
    # Look for existing wallpaper entry
    ctxt = doc.xpathNewContext()
    res = ctxt.xpathEval("/wallpapers/wallpaper[filename=\""+xml_file_path+"\"]")
    
    # If no entry exists, add one
    if len(res) == 0:
        wallpaper = root.newChild(None, "wallpaper", None)
        wallpaper.addChild(wallpaper.newProp("deleted", "false"))
        wallpaper.addChild(wallpaper.newChild(None, "name", "gnome-wallpaper-slideshow"))
        wallpaper.addChild(wallpaper.newChild(None, "filename", xml_file_path))
        wallpaper.addChild(wallpaper.newChild(None, "options", "stretched"))
        wallpaper.addChild(wallpaper.newChild(None, "shade_type", "solid"))
        wallpaper.addChild(wallpaper.newChild(None, "pcolor", "#2c2c00001e1e"))
        wallpaper.addChild(wallpaper.newChild(None, "scolor", "#2c2c00001e1e"))
        root.addChild(wallpaper)

        try:
            doc.saveFormatFileEnc(backgrounds_file, "utf-8", 1)
        except IOError:
            print "Failed to write file."
            sys.exit(2)
    
    # Set xml file as current background
    conf_client = gconf.client_get_default()
    conf_client.add_dir("/desktop/gnome/background", gconf.CLIENT_PRELOAD_NONE)
    conf_client.set_string("/desktop/gnome/background/picture_filename", xml_file_path)
    conf_client.set_string("/desktop/gnome/background/picture_options", "stretched")

def usage():
    print "Usage: gnome-wallpaper-slideshow [OPTION]... FOLDER"
    print "Set images in FOLDER as Gnome wallpaper slideshow"
    print ""
    print "-h, --help                           display this help and exit"
    print "-p, --picture-duration=SECONDS       duration to display each picture"
    print "-t, --transition-duration=SECONDS    duration to display each transition"
    print ""
    print "By default, pictures will be displayed alphabetically for 300 seconds (5 minutes) with a 5 second transition."

if __name__ == "__main__":
    if (len(sys.argv) > 1):
        main(sys.argv[1:])
    else:
        GTK_Main()
        gtk.gdk.threads_init()
        gtk.main()