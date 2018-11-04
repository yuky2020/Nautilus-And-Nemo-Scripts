#!/bin/bash

# Creator:	Inameiname
# Version:	1.0
# Last modified: 19 September 2011
#
# Will automatically search the given IP Address
#



##################################################
# Run through a proxy (Tor)			 #
##################################################

###### enable the proxy through Tor
    export http_proxy='http://localhost:8118';
    export https_proxy='http://localhost:8118';



###### required functions and shortcuts for use later on with the proxy
thisip=$(zenity --entry --text="Please provide the IP Address you would like to lookup: ")

country()
{
    wget -qO - www.ip2location.com/$thisip | grep --color=auto "<span id=\"dgLookup__ctl2_lblICountry\">" | sed 's/<[^>]*>//g; s/^[\t]*//; s/&quot;/"/g; s/</</g; s/>/>/g; s/&amp;/\&/g' ;
}

region()
{
    wget -qO - www.ip2location.com/$thisip | grep --color=auto "<span id=\"dgLookup__ctl2_lblIRegion\">" | sed 's/<[^>]*>//g; s/^[\t]*//; s/&quot;/"/g; s/</</g; s/>/>/g; s/&amp;/\&/g' ;
}

city()
{
    wget -qO - www.ip2location.com/$thisip | grep --color=auto "<span id=\"dgLookup__ctl2_lblICity\">" | sed 's/<[^>]*>//g; s/^[\t]*//; s/&quot;/"/g; s/</</g; s/>/>/g; s/&amp;/\&/g' ;
}

lat()
{
    wget -qO - www.ip2location.com/$thisip | grep --color=auto "<span id=\"dgLookup__ctl2_lblILatitude\">" | sed 's/<[^>]*>//g; s/^[\t]*//; s/&quot;/"/g; s/</</g; s/>/>/g; s/&amp;/\&/g' ;
}

lon()
{
    wget -qO - www.ip2location.com/$thisip | grep --color=auto "<span id=\"dgLookup__ctl2_lblILongitude\">" | sed 's/<[^>]*>//g; s/^[\t]*//; s/&quot;/"/g; s/</</g; s/>/>/g; s/&amp;/\&/g' ;
}



###### use the above required functions here so as to get info about the current IP you are using through the proxy
    notify-send -t 20000 -i /usr/share/icons/gnome/32x32/status/info.png "IP Address Lookup: $thisip" "$(echo -e "\nCITY=$(city)\nSTATE/PROVINCE=$(region)\nCOUNTRY=$(country)\nLATITUDE=$(lat)\nLONGITUDE=$(lon)")"



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

