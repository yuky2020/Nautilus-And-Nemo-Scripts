#!/usr/bin/env python

BACKGROUND_DIRS = ['/usr/share/backgrounds', '~/Pictures/Backgrounds']
EXTENSIONS = ['jpeg', 'jpg', 'bmp', 'png', 'svg']

import os, glob, random, itertools, gconf

files = list(itertools.chain(*[[os.path.join(dirpath, name)
                                for name in filenames]
                               for dirpath, dirnames, filenames in
                               itertools.chain(*[os.walk(os.path.expanduser(d))
                                                 for d in BACKGROUND_DIRS])]))
gconf.client_get_default().set_string(
    '/desktop/gnome/background/picture_filename',
    random.choice(files))
