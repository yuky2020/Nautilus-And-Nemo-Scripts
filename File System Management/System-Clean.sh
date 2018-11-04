#!/bin/bash
"""
Type: Nautilus Script
Title: Nettoyer
Version: 1.5
Info: supprime les traces de multiples applications et du système.
      delete a lot of junk files from system and softwares (nettoyer = to clean).
Author: © Copyright (C) 2011, Airelle - http://rlwpx.free.fr/WPFF/nautilus.htm
Original language: french
Translations: 
- to english: Airelle - http://rlwpx.free.fr/WPFF/nautilus.htm
License: GNU General Public License, version 3 or later - http://www.gnu.org/licenses/gpl.html
Usage : copier ce fichier dans le répertoire des scripts Nautilus de votre dossier personnel (~/.gnome2/nemo-scripts/)
        et vérifier que le script est exécutable (x). Le paquet zenity doit être installé.
        copy this file to the Nautilus-scripts directory of your home (~/.gnome2/nemo-scripts/)
        and be sure that the script is executable (x). Package zenity must be installed.
Note :  Le paquet sqlite3 doit être installé pour compacter les fichiers de base SQL.
        The sqlite3 package must be installed to compact the SQL database files.
"""

# Messages
case $LANG in
 en* )
  msg_titre="Nettoyer (Clean)"
  msg_info="These junk files will be deleted:\n\n- root: backups, logs, temporary files and Aptitude cache\n\n- all users: Adobe Reader, akregator, aMSN, aMule, Audacious, Azureus, Beagle, Chrome, Chromium, Compiz, d4x, Easytag, eLinks, eMesene, Epiphany, Evolution, Exaile, Filezilla, Firefox, Flash, Gedit, Gftp, Gimp, Gl-117, Gnome, Google Earth, Gpodder, Gwenview, Hippo Opensim, Java, KDE, Konqueror, Liferea, Links2, luckyBackup, Midnight Commander, Miro, Nautilus, Nexuiz, Office, Opera, Pidgin, Real Player, Recoll, Rhythmbox, Screenlets, Seamonkey, Secondlife, Skype, Swift Weasel, Synaptic, Thunderbird, Transmission, Tremulous, Vim, VLC, Wine, Xchat, Xine and Yum.\n\nIt will be a good idea to execute \"Sauver\" before...\n\nClose this box to cancel the cleaning.\nEnter to clean."
  msg_info2="Cleaning done."
 ;;
 * )
  msg_titre="Nettoyer"
  msg_info="Suppression des traces :\n\n- root : Fichiers de sauvegardes, journaux, fichiers temporaires et cache d'Aptitude\n\n- tout utilisateur : Adobe Reader, akregator, aMSN, aMule, Audacious, Azureus, Beagle, Chrome, Chromium, Compiz, d4x, Easytag, eLinks, eMesene, Epiphany, Evolution, Exaile, Filezilla, Firefox, Flash, Gedit, Gftp, Gimp, Gl-117, Gnome, Google Earth, Gpodder, Gwenview, Hippo Opensim, Java, KDE, Konqueror, Liferea, Links2, luckyBackup, Midnight Commander, Miro, Nautilus, Nexuiz, Office, Opera, Pidgin, Real Player, Recoll, Rhythmbox, Screenlets, Seamonkey, Secondlife, Skype, Swift Weasel, Synaptic, Thunderbird, Transmission, Tremulous, Vim, VLC, Wine, Xchat, Xine et Yum.\n\nUne bonne idée serait d'exécuter \"Sauver\" avant...\n\nFermez cette fenêtre pour annuler le nettoyage.\nTapez Entrée pour lancer le nettoyage."
  msg_info2="Nettoyage effectué."
 ;;
esac

# ----------------------------------------------- Go!
zenity --info --title="${msg_titre}" --text="${msg_info}"
if [ $? -eq 1 ];then exit; fi;

# ###################### ONLY ROOT ####################### #

# ----------------------------------------------- Aptitude
# obsolete
apt-get autoclean
apt-get autoremove
apt-get clean
# cache
find /var/cache/apt -type f -exec rm -f {} \;

# ----------------------------------------------- Backups
'''
# ATTENTION !!!
# Ces sauvegardes pourraient servir !
# These files could be useful!!!
rm -rf /var/backups/
'''

# ----------------------------------------------- Junks
# ATTENTION !!!
# Ne pas nettoyer /tmp/ (il le sera automatiquement au redémarrage)
# Do not clean /tmp/ (it is automatically done after reboot)
find /var/log -path /var/log/clamav -prune -o -exec rm -f {} \;
rm -rf /var/tmp/

# ####################### ALL USERS ###################### #

# ----------------------------------------------- General
# bash
rm ~/.bash_history
# Restaure une sauvegarde (qui doit évidemment avoir été créée)
# Ce serait une bonne idée d'en créer une propre regroupant les commandes qui vous sont utiles...
# Restores a backup (which must obviously have been created)
# It would be a good idea to create such a file with the most useful commands you need...
cp ~/Documents/.bash_history ~

# backups
rm ~/.config/menus/*.menu.undo-*
'''
# ATTENTION !!!
# Ces sauvegardes pourraient servir !
# These files could be useful!
find ~ -type f -regex ".*\.\([bB][aA][kK]\|[Oo][Ll][Dd]\)" -exec rm {} \;
find ~ -type f -regex ".*~" -exec rm {} \;
'''

# caches
rm -rf ~/.cache/
rm -rf ~/.kde/cache-*/
find ~ -type f -regex ".*\.\([Tt][Mm][Pp]\)" -exec rm {} \;
rm -rf ~/.kde/tmp-localhost.localdomain/

# streams
rm ~/.goutputstream-*

# mount points
rm ~/.local/share/gvfs-metadata/*.log
rm ~/.local/share/gvfs-metadata/uuid*

# recently used
rm ~/.recently-used.xbel

# thumbnails
find ~ -type f -name ".DS_Store" -exec rm {} \;
find ~ -type f -name "Thumbs.db" -exec rm {} \;
rm -rf ~/.thumbnails/

# trash
rm -rf ~/.local/share/Trash/

# X
rm ~/.xsession-errors
rm ~/.xsession-errors.old

# ----------------------------------------------- Adobe Reader
# cache
rm -rf ~/.adobe/Acrobat/*/Cache/
# recently used
rm ~/.adobe/Acrobat/*/Preferences/reader_prefs

# ----------------------------------------------- akregator
# cookies
rm ~/.kde/share/apps/kcookiejar/cookies

# ----------------------------------------------- aMSN
# cache
rm -rf ~/.amsn/*/*/cache/
rm -rf ~/.amsn/*/voiceclips/
rm -rf ~/.amsn/*/webcam/
# logs
rm -rf ~/.amsn/*/logs/

# ----------------------------------------------- aMule
# logs
rm ~/.aMule/logfile
rm ~/.aMule/logfile.bak
# cache
rm -rf ~/.aMule/Temp/

# ----------------------------------------------- Audacious
# cache
rm -rf ~/.cache/audacious/thumbs/
# logs
rm ~/.config/audacious/log
# recently used
rm ~/.config/audacious/playlist.xspf

# ----------------------------------------------- Azureus
# backup files
rm ~/.azureus/active/*.bak
# cache
rm ~/.azureus/ipfilter.cache
rm -rf ~/.azureus/tmp/
# logs
rm ~/.azureus/logs/
rm ~/.azureus/*.log

# ----------------------------------------------- Beagle
# cache
rm -rf ~/.beagle/TextCache/
# history
rm -rf ~/.beagle/Indexes/
# logs
rm -rf ~/.beagle/Log/

# ----------------------------------------------- Chrome
# cache
rm -rf ~/.cache/google-chrome/
rm ~/.config/google-chrome/Default/Preferences/dns_prefetching.json
rm ~/.config/google-chrome/Local\ State/HostReferralList.json
rm ~/.config/google-chrome/Local\ State/StartupDNSPrefetchList.json
# cookies
rm ~/.config/google-chrome/Default/Cookies
rm ~/.config/google-chrome/Default/Extension\ Cookies
rm ~/.config/google-chrome/Default/databases/Databases.db
rm ~/.config/google-chrome/Default/Local\ Storage/http*localstorage
rm -rf ~/.config/google-chrome/Default/databases/http*/
# history
rm ~/.config/google-chrome/Default/*History*
rm ~/.config/google-chrome/Default/Thumbnails*
rm ~/.config/google-chrome/Default/Top\ Sites
rm ~/.config/google-chrome/Default/Visited\ Links
rm ~/.config/google-chrome/Default/Web\ Data/chrome.autofill
rm ~/.config/google-chrome/Default/Web\ Data/chrome.keywords
rm -rf ~/.config/google-chrome/Default/Favicons/
rm -rf ~/.config/google-chrome/Default/History/
rm ~/.config/google-chrome/Default/Current\ Session
rm ~/.config/google-chrome/Default/Current\ Tabs
rm ~/.config/google-chrome/Default/Last\ Session
rm ~/.config/google-chrome/Default/Last\ Tabs
# defragmentation
for f in ~/.config/google-chrome/Default/*.db; do sqlite3 $f 'VACUUM;'; done
for f in ~/.config/google-chrome/Default/*.sqlite; do sqlite3 $f 'VACUUM;'; done

# ----------------------------------------------- Chromium
# cache
rm -rf ~/.cache/chromium/
rm ~/.config/chromium/Local\ State/HostReferralList.json
rm ~/.config/chromium/Local\ State/StartupDNSPrefetchList.json
# cookies
rm ~/.config/chromium/Default/Cookies
rm ~/.config/chromium/Default/Extension\ Cookies
rm ~/.config/chromium/Default/databases/Databases.db
rm ~/.config/chromium/Default/Local\ Storage/*localstorage
rm -rf ~/.config/chromium/Default/databases/http*/
# history
rm ~/.config/chromium/Default/Bookmarks.bak
rm -rf ~/.config/chromium/Default/Favicons/
rm -rf ~/.config/chromium/Default/*History*/
rm ~/.config/chromium/Default/*History*
rm ~/.config/chromium/Default/*-journal
rm ~/.config/chromium/Default/Thumbnails*
rm ~/.config/chromium/Default/Top\ Sites
rm ~/.config/chromium/Default/Visited\ Links
rm ~/.config/chromium/Default/Web\ Data/chrome.autofill
rm ~/.config/chromium/Default/Web\ Data/chrome.keywords
rm ~/.config/chromium/Default/Current\ Session
rm ~/.config/chromium/Default/Current\ Tabs
rm ~/.config/chromium/Default/Last\ Session
rm ~/.config/chromium/Default/Last\ Tabs
# defragmentation
for f in ~/.config/chromium/Default/*.db; do sqlite3 $f 'VACUUM;'; done
for f in ~/.config/chromium/Default/*.sqlite; do sqlite3 $f 'VACUUM;'; done

# ----------------------------------------------- d4x
# cookies
rm ~/.ntrc_*/cookies.txt
# history
rm ~/.ntrc_*/history*

# ----------------------------------------------- Compiz
rm -rf ~/.compiz/session/
rm -rf ~/.config/compiz/

# ----------------------------------------------- Easytag
# logs
rm ~/.easytag/easytag.log

# ----------------------------------------------- eLinks
# cookies
rm ~/.elinks/cookies
# history
rm ~/.elinks/*hist

# ----------------------------------------------- eMesene
# cache
rm -rf ~/.config/emesene*/*/cache/
# logs
rm -rf ~/.config/emesene*/*/logs/
rm ~/.config/emesene*/*/log*

# ----------------------------------------------- Epiphany
# cache
rm ~/.gnome2/epiphany/ephy-favicon-cache.xml
rm -rf ~/.gnome2/epiphany/mozilla/epiphany/Cache/
rm -rf ~/.gnome2/epiphany/favicon_cache/
# cookies
rm ~/.gnome2/epiphany/mozilla/epiphany/cookies*
# history
rm ~/.gnome2/epiphany/ephy-history.xml
# defragmentation
for f in ~/.gnome2/epiphany/mozilla/epiphany/*.sqlite; do sqlite3 $f 'VACUUM;'; done
'''
# usernames & passwords
# ATTENTION !!!
# Vos identifiants et mots de passe seront irrécupérables !
# They will be securely deleted!
shred -n 7 -u -v -z ~/.gnome2/epiphany/mozilla/epiphany/signons3.txt
'''

# ----------------------------------------------- Evolution
# cache
rm -rf ~/.evolution/cache/

# ----------------------------------------------- Exaile
# cache
rm -rf ~/.exaile/cache/
rm -rf ~/.exaile/covers/
# downloads
rm -rf ~/.exaile/podcasts/
# logs
rm ~/.exaile/exaile.log

# ----------------------------------------------- Firefox
# cache
rm -rf ~/.mozilla/firefox/*.default/Cache/
rm -rf ~/.mozilla/firefox/*.default/mozilla-media-cache/
rm -rf ~/.mozilla/firefox/*.default/OfflineCache/
rm -rf ~/.mozilla/firefox/*.default/startupCache/
rm -rf ~/.mozilla/extensions
# cookies
rm ~/.mozilla/firefox/*.default/cookies.*
rm ~/.mozilla/firefox/*.default/webappsstore.sqlite
# history
rm -rf ~/.mozilla/firefox/*.default/bookmarkbackups/
rm ~/.mozilla/firefox/*.default/adblockplus/patterns-backup*
rm ~/.mozilla/firefox/*.default/reminderfox/*.bak*
rm -rf ~/.mozilla/firefox/*.default/minidumps/
rm -rf ~/.mozilla/firefox/Crash\ Reports/
rm ~/.mozilla/firefox/*.default/downloads.sqlite
rm ~/.mozilla/firefox/*.default/formhistory.sqlite
rm ~/.mozilla/firefox/*.default/history.dat
rm ~/.mozilla/firefox/*.default/sessionstore.*
# defragmentation
for f in ~/.mozilla/firefox/*.default/*.db; do sqlite3 $f 'VACUUM;'; done
for f in ~/.mozilla/firefox/*.default/*.sqlite; do sqlite3 $f 'VACUUM;'; done
'''
# usernames & passwords
# ATTENTION !!!
# Vos identifiants et mots de passe seront irrécupérables !
# They will be securely deleted!
shred -n 7 -u -v -z ~/.mozilla/firefox/*.default/signons.sqlite
'''

# ----------------------------------------------- Filezilla
# recently used
rm ~/.filezilla/recentservers.xml

# ----------------------------------------------- Flash
# cache
rm -rf ~/.adobe/Flash_Player/AssetCache/
rm -rf ~/.macromedia/Flash_Player/

# ----------------------------------------------- Gedit
# recently used
rm ~/.cache/gedit/gedit-metadata.xml
rm ~/.gnome2/gedit-metadata.xml

# ----------------------------------------------- Gftp
# logs
rm ~/.gftp/gftp.log
# cache
rm -rf ~/.gftp/cache/

# ----------------------------------------------- Gimp
# cache
rm -rf ~/.gimp-*/tmp/

# ----------------------------------------------- Gl-117
# logs
rm ~/.gl-117/logfile.txt

# ----------------------------------------------- Gnome
# history
rm ~/.gconf/apps/gnome-settings/gnome-panel/%gconf.xml
rm ~/.gconf/apps/gnome-settings/gnome-search-tool/%gconf.xml

# ----------------------------------------------- Google Earth
# cache
rm ~/.googleearth/Cache/dbCache.*
rm -rf ~/.googleearth/Temp/

# ----------------------------------------------- Gpodder
# cache
rm -rf ~/.config/gpodder/cache/
# defragmentation
for f in ~/.config/gpodder/*.sqlite; do sqlite3 $f 'VACUUM;'; done

# ----------------------------------------------- Gwenview
# recently used
rm ~/.kde*/share/apps/gwenview/recent*/*rc

# ----------------------------------------------- Hippo Opensim Viewer
# cache
rm -rf ~/.hippo_opensim_viewer/cache/
# logs
rm -rf ~/.hippo_opensim_viewer/logs/

# ----------------------------------------------- Java
# cache
rm -rf ~/.icedteaplugin/cache/
rm -rf ~/.java/deployment/cache/

# ----------------------------------------------- KDE
# cache
rm -rf ~/.kde/cache-*/
rm -rf ~/.kde/tmp-*/
# recently used
rm ~/.kde*/share/apps/RecentDocuments/*.desktop

# ----------------------------------------------- Konqueror
# cookies
rm ~/.kde/share/apps/kcookiejar/cookies
# history
rm ~/.kde/share/apps/konqueror/closeditems_saved
rm ~/.kde/share/apps/konqueror/konq_history
rm ~/.kde/share/config/konq_history
rm -rf ~/.kde/share/apps/konqueror/autosave/

# ----------------------------------------------- Liferea
# cache
rm -rf ~/.liferea_*/cache/
rm -rf ~/.liferea_*/mozilla/liferea/Cache/
# cookies
rm ~/.liferea_*/mozilla/liferea/cookies.sqlite
# defragmentation
for f in ~/.liferea_*/*.db; do sqlite3 $f 'VACUUM;'; done
for f in ~/.liferea_*/mozilla/liferea/*.sqlite; do sqlite3 $f 'VACUUM;'; done

# ----------------------------------------------- Links2
# history
rm ~/.links2/links.his

# ----------------------------------------------- luckyBackup
# logs
rm -rf ~/.luckyBackup/logs/
rm -rf ~/.luckyBackup/snaps/

# ----------------------------------------------- Midnight Commander
# history
rm ~/.mc/filepos
rm ~/.mc/history

# ----------------------------------------------- Miro
# cache
rm -rf ~/.miro/icon-cache/
rm -rf ~/.miro/mozilla/Cache/
# logs
rm ~/.miro/miro-*log*

# ----------------------------------------------- Nautilus
# history
'''
# ATTENTION !!!
# La personnalisation des dossiers sera effacée !
# Custom folders will be reset!
rm ~/.nautilus/saved-session-??????
rm ~/.nautilus/metafiles/*/*.xml
'''

# ----------------------------------------------- Nexuiz
# cache
rm -rf ~/.nexuiz/data/dlcache/

# ----------------------------------------------- Office
# cache
rm -rf ~/.libreoffice/*/*/*/cache/
rm -rf ~/.openoffice.org/*/*/*/cache/
# history
rm ~/.libreoffice/*/*/registry/data/org/openoffice/Office/Common.xcu
rm ~/.openoffice.org/*/*/registry/data/org/openoffice/Office/Common.xcu

# ----------------------------------------------- Opera
# cache
rm -rf ~/.opera/*cache*/
rm -rf ~/.opera/icons/
rm -rf ~/.opera/temporary_downloads/
rm -rf ~/.opera/thumbnails/
# cookies
rm ~/.opera/cookies4.dat
rm -rf ~/.opera/pstorage/
# history
rm ~/.opera/download.dat
rm ~/.opera/global.dat
rm ~/.opera/*history*
rm ~/.opera/vlink4.dat
rm ~/.opera/vps/????/md.dat
rm -rf ~/.opera/sessions/

# ----------------------------------------------- Pidgin
# cache
rm -rf ~/.purple/icons/
# logs
rm -rf ~/.purple/logs/

# ----------------------------------------------- Real Player
# cookies
rm ~/.config/real/rpcookies.txt

# ----------------------------------------------- Recoll
# history
rm -rf ~/.recoll/xapiandb/

# ----------------------------------------------- Rhythmbox
# cache
rm -rf ~/.gnome2/rhythmbox/jamendo/
rm -rf ~/.gnome2/rhythmbox/magnatune/

# ----------------------------------------------- Screenlets
# logs
rm ~/.config/Screenlets/*.log

# ----------------------------------------------- Seamonkey
# cache
rm -rf ~/.mozilla/default/Cache/
rm -rf ~/.mozilla/seamonkey/*/Cache/
# logs
rm ~/.mozilla/*/*.slt/chatzilla/logs/*log
# cookies
rm ~/.mozilla/*/*.slt/cookies.txt
rm ~/.mozilla/seamonkey/*.default/cookies.sqlite
# history
rm ~/.mozilla/seamonkey/*.default/downloads.sqlite
rm ~/.mozilla/seamonkey/*.default/urlbarhistory.sqlite
rm ~/.mozilla/*/*.slt/history.dat
# defragmentation
for f in ~/.mozilla/seamonkey/*.default/*.db; do sqlite3 $f 'VACUUM;'; done
for f in ~/.mozilla/seamonkey/*.default/*.sqlite; do sqlite3 $f 'VACUUM;'; done

# ----------------------------------------------- Secondlife
# cache
rm -rf ~/.secondlife/cache/
# logs
rm -rf ~/.secondlife/logs/

# ----------------------------------------------- Skype
# logs
rm ~/.Skype/*/chatmsg[0-9]*.dbb
rm ~/.Skype/*/chatsync/*/*.dat

# ----------------------------------------------- Swift Weasel
# cache
rm -rf ~/.sw35/swiftweasel/*/Cache/

# ----------------------------------------------- Synaptic
# logs
rm -rf ~/.synaptic/log/

# ----------------------------------------------- Thunderbird	
# cache
rm -rf ~/.thunderbird/default/*.slt/Cache/
rm -rf ~/.thunderbird/*.default/Cache/
rm -rf ~/.thunderbird/Profiles/*.default/Cache/
# cookies
rm ~/.thunderbird/default/*.slt/cookies.sqlite
rm ~/.thunderbird/*.default/cookies.sqlite
rm ~/.thunderbird/Profiles/*.default/cookies.sqlite
# usernames and passwords
rm ~/.mozilla-thunderbird/*.default/signons.txt
rm ~/.thunderbird/*.default/signons.sqlite
rm ~/.thunderbird/*.default/signons.txt
rm ~/.thunderbird/default/*.slt/signons3.txt
rm ~/.thunderbird/default/*.slt/signons.sqlite
rm ~/.thunderbird/default/*.slt/signons.txt
rm ~/.thunderbird/Profiles/*.default/signons.sqlite
# defragmentation
for f in ~/.thunderbird/default/*.slt/*.sqlite; do sqlite3 $f 'VACUUM;'; done
for f in ~/.thunderbird/*.default/*.sqlite; do sqlite3 $f 'VACUUM;'; done
for f in ~/.thunderbird/Profiles/*.default/*.sqlite; do sqlite3 $f 'VACUUM;'; done

# ----------------------------------------------- Transmission
# cache
rm -rf ~/.config/transmission/blocklists/
rm -rf ~/.config/transmission/resume/

# ----------------------------------------------- Tremulous
# cache
rm ~/.tremulous/servercache.dat

# ----------------------------------------------- Vim
# history
rm ~/.viminfo

# ----------------------------------------------- VLC
# cache
rm -rf ~/.cache/vlc/

# ----------------------------------------------- Wine
# cache
rm -rf ~/.wine/drive_c/winetrickstmp/
rm -rf ~/.winetrickscache/

# ----------------------------------------------- Xchat
# logs
rm -rf ~/.xchat2/scrollback/
rm ~/.xchat2/logs/*log
rm ~/.xchat2/xchatlogs/*log

# ----------------------------------------------- Xine
# cache
rm ~/.xine/catalog.cache

# ----------------------------------------------- Yum
# defragmentation
for f in /var/cache/yum/*/*.sqlite; do sqlite3 $f 'VACUUM;'; done

# ----------------------------------------------- That's all folks!
zenity --info --title="${msg_titre}" --text="${msg_info2}"

# EOF
