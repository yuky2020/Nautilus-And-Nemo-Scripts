#!/usr/bin/env python
# A Nautilus Script to generate an HTML Gallery.

import os
import sys
import shutil

index = 'index.html'
try: 
    target = sys.argv[1]
except:
    print 'Syntax: /%s <dir>' % (sys.argv[0])
    print '-----------------'
    print 'Does not work on Desktop - try the Desktop Folder in your personal Dir instead'
    sys.exit(1)
f = open('f.log', 'w')
f.write(str(sys.argv[:]))

def m(msg, types='warning'):
    if os.path.isfile('/usr/bin/zenity'):
        os.system('/usr/bin/zenity --%s --text="%s"' % (types, msg))
    elif os.path.isfile('/usr/bin/notify-send'):
        os.system('/usr/bin/notify-send %s' % (msg))
    else:
        # No Notification-System installed.
        f = open('nautilus-gallery-log.html', 'w')
        f.write("""
        <!DOCTYPE html>
            <html>
                <head>
                    <title>Logfile</title>
                </head>
                <body>
                    <h1>The following Errors have been reported:</h1>
                    <ul>
                    <li>%s.</li>
                    </ul>
                </body>
          </html>
       """ % (msg))
        f.close()


if not os.path.isdir(target):
    # check if zenity is installed.
    m('You can only use this on Dirs.')
    sys.exit(0)

os.chdir(target)
# Generate FileMap for Image-Files.
filemap = []
for file in os.listdir(target):
    if file.split(".")[-1] in ['png', 'jpg', 'jpeg', 'svg', 'gif','bmp', 'tga']:
        filemap.append(file)
        
dirid = '_1'
c = 1
while os.path.isdir('gallery'+dirid):
    c += 1
    dirid = '_'+str(c)
dirname = 'gallery'+dirid

os.mkdir(dirname)

f = open(os.path.join(dirname, index), 'w')
f.write("<h1>Welcome to my Gallery ! :)</h1><br /><ul>")

for file in filemap:
    shutil.copy(file, os.path.join(dirname, file))
    # copy images to folder.
    f.write('<li><a href="./view.html?image=%s">%s</a></li>\n' % (file,file))
    
f.write('</ul><br /><i>CSS Styles will be added in the future. :)</i>')

# Generate Image-View.

javascript = """
<html>
    <head>
        <title>Test Query Strings :)</title>
        <script type='text/javascript'>
        <!--
        function queryString(ji) {
            hu = window.location.search.substring(1);
            gy = hu.split(\"&\");
            for (i=0;i<gy.length;i++) {
                ft = gy[i].split(\"=\");
                if (ft[0] == ji) {
                    return ft[1];
                }
            }
        }
        function loadImage() { var image = queryString('image');
            e = document.getElementById('image').src = image;
        }
        function resizeImage(e) {
            if (e.style.width != 'auto') {
            e.style.width = 'auto';
            e.style.height = 'auto';
            }
            else {
            e.style.width = '300px';
            e.style.height = '300px';
            }
        } 
        //-->
        </script>
    </head>
    <body onload='loadImage();'>
    <a href='./index.html'>Back..</a>
    <center>
        <img src='' id='image' style='width:300px;height:300px;' onclick='resizeImage(this)'>
    <br /><small>Click to resize Image</small></center>
    </body>
</html>
""" 
f = open(os.path.join(dirname, 'view.html'), 'w')
f.write(javascript)
f.close()

m('Done. Look into your Folder and open index.html :)', 'info')
