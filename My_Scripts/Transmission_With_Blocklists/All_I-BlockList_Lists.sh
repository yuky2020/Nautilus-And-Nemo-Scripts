#!/bin/bash

# Creator:	Inameiname
# Version:	1.2
# Last modified: 24 October 2011
#
# Automatically downloads and 'installs' all I-Blocklist
# lists prior to running Transmission (currently, there
# are 82 separate lists)
#
# Homepage:	http://www.iblocklist.com/lists.php

notify-send -t 20000 -i /usr/share/icons/gnome/32x32/status/info.png "Please wait while blocklists for Transmission BitTorrent Client are downloading..."

BLOCKLISTDIR="$HOME/.config/transmission/blocklists"
BASEURL="http://list.iblocklist.com/?list="
ENDURL="&fileformat=p2p&archiveformat=gz"
FILES=( bt_level1 bt_level2 bt_level3 bt_edu bt_rangetest bt_bogon bt_ads bt_spyware bt_proxy bt_templist bt_microsoft bt_spider bt_hijacked bt_dshield ficutxiwawokxlcyoeye ghlzqtqxnzctvvajwwag bcoepfyewziejvcqyhqo cslpybexmxyuacbyuvib pwqnlynprfgtjbgqoizj jhaoawihmfxgnvmaqffp mtxmiireqmjzazcsoiem ijfqtofzixtwayqovmxn ecqbsykllnadihkdirsh jcjfaxgyyshvdbceroxf lljggjrpmefcwqknpalp pfefqteoxlfzopecdtyw tbnuqfclfkemqivekikv ewqglwibdgjttwttrinl sh_drop tzmtqbbsgbtfxainogvm ynkdjqsjyfmilsgbogqf zfucwtjkfwkalytktyiw cr_bogon dufcxgnbjsdwmwctgfuj logmein steam xfire blizzard ubisoft nintendo activision soe ccp lindenlab electronicarts squareenix ncsoft punkbuster joost aevzidimyvwybzkletsg nzldzlpkgrcncdomnttb aphcqvpxuqgrkgufjruj tor aol comcast cablevision verizon att cox roadrunner charter qwest embarq suddenlink au br ca cn de es eu fr gb it jp kr mx nl ru se tw us )

if [ ! -d $BLOCKLISTDIR ];then
    mkdir -p $BLOCKLISTDIR
else
    /bin/rm -fv -R $BLOCKLISTDIR
    mkdir -p $BLOCKLISTDIR
fi

for i in "${FILES[@]}"
  do
    # wget -c $BASEURL"$i"$ENDURL -O $BLOCKLISTDIR/$i.gz
    curl -L --retry 10 $BASEURL"$i"$ENDURL -o $BLOCKLISTDIR/$i.gz 	# seems to generate less download failures than wget
    gunzip -f $BLOCKLISTDIR/$i.gz
    mv $BLOCKLISTDIR/$i $BLOCKLISTDIR/$i.txt
done

if [ ! $(find "$BLOCKLISTDIR" -type f -name "*.gz") ];then
    notify-send -t 10000 -i /usr/share/icons/gnome/32x32/status/info.png "The blocklists have finished downloading. Transmission will open momentarily..."
    transmission-gtk
    /bin/rm -fv -R $BLOCKLISTDIR/*.txt
    exit
else
    notify-send -t 10000 -i /usr/share/icons/gnome/32x32/status/info.png "The blocklists have failed to completely download. Please try again." & /bin/rm -fv -R $BLOCKLISTDIR
    exit
fi
