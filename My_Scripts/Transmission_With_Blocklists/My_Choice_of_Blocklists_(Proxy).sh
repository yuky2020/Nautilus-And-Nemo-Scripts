#!/bin/bash

# Creator:	Inameiname
# Version:	1.2
# Last modified: 24 October 2011
#
# Automatically downloads and 'installs' my choice of
# I-Blocklist lists prior to running Transmission
# (currently, there are 82 separate lists to choose from)
#
# Homepage:	http://www.iblocklist.com/lists.php



##################################################
# Run through a proxy (Tor)			 #
##################################################

###### enable the proxy through Tor
    export http_proxy='http://localhost:8118';
    export https_proxy='http://localhost:8118';



###### required functions for use later on with the proxy
myip()
{
    lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print $4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' ;
}

country()
{
    wget -qO - www.ip2location.com/$(myip) | grep --color=auto "<span id=\"dgLookup__ctl2_lblICountry\">" | sed 's/<[^>]*>//g; s/^[\t]*//; s/&quot;/"/g; s/</</g; s/>/>/g; s/&amp;/\&/g' ;
}

region()
{
    wget -qO - www.ip2location.com/$(myip) | grep --color=auto "<span id=\"dgLookup__ctl2_lblIRegion\">" | sed 's/<[^>]*>//g; s/^[\t]*//; s/&quot;/"/g; s/</</g; s/>/>/g; s/&amp;/\&/g' ;
}

city()
{
    wget -qO - www.ip2location.com/$(myip) | grep --color=auto "<span id=\"dgLookup__ctl2_lblICity\">" | sed 's/<[^>]*>//g; s/^[\t]*//; s/&quot;/"/g; s/</</g; s/>/>/g; s/&amp;/\&/g' ;
}

lat()
{
    wget -qO - www.ip2location.com/$(myip) | grep --color=auto "<span id=\"dgLookup__ctl2_lblILatitude\">" | sed 's/<[^>]*>//g; s/^[\t]*//; s/&quot;/"/g; s/</</g; s/>/>/g; s/&amp;/\&/g' ;
}

lon()
{
    wget -qO - www.ip2location.com/$(myip) | grep --color=auto "<span id=\"dgLookup__ctl2_lblILongitude\">" | sed 's/<[^>]*>//g; s/^[\t]*//; s/&quot;/"/g; s/</</g; s/>/>/g; s/&amp;/\&/g' ;
}



###### use the above required functions here so as to get info about the current IP you are using through the proxy
    notify-send -t 20000 -i /usr/share/icons/gnome/32x32/status/info.png "IP Address Lookup: $(myip)" "$(echo -e "\nCITY=$(city)\nSTATE/PROVINCE=$(region)\nCOUNTRY=$(country)\nLATITUDE=$(lat)\nLONGITUDE=$(lon)")"



##################################################
# Downloading/installation of the latest 	 #
# blocklists					 #
##################################################

notify-send -t 20000 -i /usr/share/icons/gnome/32x32/status/info.png "Please wait while blocklists for Transmission BitTorrent Client are downloading..."

BLOCKLISTDIR="$HOME/.config/transmission/blocklists"
BASEURL="http://list.iblocklist.com/?list="
ENDURL="&fileformat=p2p&archiveformat=gz"
FILES=( bt_level1 bt_level2 bt_level3 us bt_dshield jcjfaxgyyshvdbceroxf ijfqtofzixtwayqovmxn bt_templist dufcxgnbjsdwmwctgfuj )

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
else
    notify-send -t 10000 -i /usr/share/icons/gnome/32x32/status/info.png "The blocklists have failed to completely download. Please try again." & /bin/rm -fv -R $BLOCKLISTDIR
fi



##################################################
# Shutting down the proxy			 #
##################################################

###### quit running through a proxy (Tor)
    export http_proxy='http://localhost:8118';
    export https_proxy='http://localhost:8118';



##################################################
# Finished					 #
##################################################

exit
