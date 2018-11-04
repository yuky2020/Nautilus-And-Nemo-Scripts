#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Nautilus Script - Make Deb
# Distributed under the terms of GNU GPL version 3
import os, sys
import md5
import gtk

def trim(docstring):
    # stealed from http://www.python.org/dev/peps/pep-0257/
    if not docstring:
        return ''
    # Convert tabs to spaces (following the normal Python rules)
    # and split into a list of lines:
    lines = docstring.expandtabs().splitlines()
    # Determine minimum indentation (first line doesn't count):
    indent = sys.maxint
    for line in lines[1:]:
        stripped = line.lstrip()
        if stripped:
            indent = min(indent, len(line) - len(stripped))
    # Remove indentation (first line is special):
    trimmed = [lines[0].strip()]
    if indent < sys.maxint:
        for line in lines[1:]:
            trimmed.append(line[indent:].rstrip())
    # Strip off trailing and leading blank lines:
    while trimmed and not trimmed[-1]:
        trimmed.pop()
    while trimmed and not trimmed[0]:
        trimmed.pop(0)
    # Return a single string:
    return '\n'.join(trimmed)

current_dir = os.environ['NAUTILUS_SCRIPT_SELECTED_FILE_PATHS'].split("\n")[0]

rootdir = os.walk(current_dir)
md5filecontent = ''

debname = os.path.basename(current_dir)

control = {
    'Package': debname,
    'Version': '0.1',
    'Architecture': 'all',
    'Installed-Size': '39',
    'Depends': 'python',
    'Section': 'none',
    'Maintainer': 'anonimous',
    'Priority': 'extra',
    'Description': 'A short description',
    'DescriptionEx': '',
}

origcontrol = (
    'Package',
    'Version',
    'Architecture',
    'Installed-Size',
    'Depends',
    'Section',
    'Maintainer',
    'Priority',
    'Description',
    'DescriptionEx',
)

# cargamos los datos del archivo si existe
try:
    f = open(current_dir + "/DEBIAN/control","r")
    try:
        content = ''
        for line in f:
            content += line
    finally:
        f.close()
        lines = content.split("\n")
        for text in lines:
            if text != '' and text[0] != ' ':
                arr = text.split(":")
                control[arr[0]] = trim(arr[1])
            elif text[0] == ' ':
                control['DescriptionEx'] += text + "\n"
except:
    pass

# mostramos el dialogo
dialog = gtk.Dialog("Make Deb Package",
    None,
    gtk.DIALOG_MODAL | gtk.DIALOG_DESTROY_WITH_PARENT,
    (gtk.STOCK_CANCEL, gtk.RESPONSE_REJECT,
    gtk.STOCK_OK, gtk.RESPONSE_ACCEPT))
dialog.set_icon_from_file("/usr/share/icons/gnome/24x24/mimetypes/gnome-package.png")
box = gtk.Table(10, 2)

box.attach(gtk.Label("Package:"), 0, 1, 0, 1)
box.attach(gtk.Label("Version:"), 0, 1, 1, 2)
box.attach(gtk.Label("Architecture:"), 0, 1, 2, 3)
box.attach(gtk.Label("Maintainer:"), 0, 1, 3, 4)
box.attach(gtk.Label("Installed-Size:"), 0, 1, 4, 5)
box.attach(gtk.Label("Depends:"), 0, 1, 5, 6)
box.attach(gtk.Label("Section:"), 0, 1, 6, 7)
box.attach(gtk.Label("Priority:"), 0, 1, 7, 8)
box.attach(gtk.Label("Description:"), 0, 1, 8, 9)
box.attach(gtk.Label("Description extended:"), 0, 1, 9, 10)

entry_package = gtk.Entry()
entry_package.set_text(control['Package'])
box.attach(entry_package, 1, 2, 0, 1)

entry_version = gtk.Entry()
entry_version.set_text(control['Version'])
box.attach(entry_version, 1, 2, 1, 2)

entry_architecture = gtk.Entry()
entry_architecture.set_text(control['Architecture'])
box.attach(entry_architecture, 1, 2, 2, 3)

entry_maintainer = gtk.Entry()
entry_maintainer.set_text(control['Maintainer'])
box.attach(entry_maintainer, 1, 2, 3, 4)

entry_installed = gtk.Entry()
entry_installed.set_text(control['Installed-Size'])
box.attach(entry_installed, 1, 2, 4, 5)

entry_depends = gtk.Entry()
entry_depends.set_text(control['Depends'])
box.attach(entry_depends, 1, 2, 5, 6)

entry_section = gtk.Entry()
entry_section.set_text(control['Section'])
box.attach(entry_section, 1, 2, 6, 7)

entry_priority = gtk.Entry()
entry_priority.set_text(control['Priority'])
box.attach(entry_priority, 1, 2, 7, 8)

entry_description = gtk.Entry()
entry_description.set_text(control['Description'])
box.attach(entry_description, 1, 2, 8, 9)

entry_descriptionex = gtk.Entry()
entry_descriptionex.set_text(control['DescriptionEx'])
box.attach(entry_descriptionex, 1, 2, 9, 10)



# box.attach(gtk.Label("ex: my-package"), 2, 3, 0, 1)


dialog.vbox.pack_start(box)

dialog.show_all()
response = dialog.run()

if response == gtk.RESPONSE_ACCEPT:
    
    control['Package'] = entry_package.get_text()
    control['Version'] = entry_version.get_text()
    control['Architecture'] = entry_architecture.get_text()
    control['Maintainer'] = entry_maintainer.get_text()
    control['Installed-Size'] = entry_installed.get_text()
    control['Depends'] = entry_depends.get_text()
    control['Section'] = entry_section.get_text()
    control['Priority'] = entry_priority.get_text()
    control['Description'] = entry_description.get_text()
    control['DescriptionEx'] = entry_descriptionex.get_text()
    
    controlfilecontent = ''
    
    for i in origcontrol:
        if i != 'DescriptionEx':
            controlfilecontent += "%s: %s\n" % (i, control[i])
        else:
            controlfilecontent += "%s\n" % control[i]
    
    f = open(current_dir + "/DEBIAN/control","w")
    f.write(controlfilecontent)
    f.close()
    # el nombre nuevo del .deb
    debnewname = "%s_%s_%s" % (
        control['Package'], 
        control['Version'], 
        control['Architecture']
    )

else:
    exit(0)

try:
    os.mkdir(current_dir + "/DEBIAN")
except:
    pass


for res in rootdir:
    
    if res[0] != current_dir + '/DEBIAN' and res[0] != current_dir:
        
        #print res[0],res[1],res[2]
        for f in res[2]:
            filename = res[0] + '/' + f
            md5sum = md5.md5(filename).hexdigest()
            md5path = res[0].replace(current_dir + '/', '') + '/' + f
            md5filecontent += md5sum + '  ' + md5path + "\n"


f = open(current_dir + "/DEBIAN/md5sums","w")
f.write(md5filecontent)
f.close()


os.system('chmod 0775 -R "%s"' % (current_dir + '/DEBIAN'))


os.system('dpkg -b "%s" "%s.deb"' % (current_dir, debnewname))
os.system('zenity --info --text="%s done."' % debnewname)

# Copyright © 2008 Perberos All Rights Reserved.
