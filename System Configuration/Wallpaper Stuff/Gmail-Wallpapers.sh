#!/bin/bash

case $1 in
	1050x600)
	res=1050x600 ;;
	1280x800)
	res=1280x800 ;;
	1440x900)
	res=1440x900 ;;
	1680x1050)
	res=1680x1050 ;;
	1920x1200)
	res=1920x1200 ;;
	*)
	echo Error!
	echo
	echo Usage:
	echo ./Gmail-Wallpapers.sh RESOLUTION
	echo where RESOLUTION can be:
	echo 1050x600
	echo 1280x800
	echo 1440x900
	echo 1680x1050
	echo 1920x1200
	exit
esac

mkdir -p gmail-wallpapers
cd gmail-wallpapers

#beach theme:
mkdir -p beach
cd beach
wget http://www.gstatic.com/ui/v1/icons/mail/themes/beach2/bg_mon_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/beach2/bg_tue_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/beach2/bg_wed_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/beach2/bg_thu_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/beach2/bg_fri_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/beach2/bg_sat_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/beach2/bg_sun_$res.jpg
cd -

#ocean theme:
wget http://www.gstatic.com/ui/v1/icons/mail/themes/phantasea/bg_morning_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/phantasea/bg_afternoon_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/phantasea/bg_evening_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/phantasea/bg_night_$res.jpg

#planets theme (some are missing)
wget http://www.gstatic.com/ui/v1/icons/mail/themes/planets/bg_mars_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/planets/bg_venus_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/planets/bg_mercury_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/planets/bg_jupiter_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/planets/bg_saturn_$res.jpg

#mountains theme:
mkdir -p mountains
cd mountains
wget http://www.gstatic.com/ui/v1/icons/mail/themes/mountains/bg_mon_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/mountains/bg_tue_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/mountains/bg_wed_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/mountains/bg_thu_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/mountains/bg_fri_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/mountains/bg_sat_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/mountains/bg_sun_$res.jpg
cd -

#other, static themes:
wget http://www.gstatic.com/ui/v1/icons/mail/themes/wood/bg_$res.jpg
mv bg_$res.jpg bg5_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_$res.jpg
mv bg4_$res.jpg bg4_1_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/desk/bg2_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/turf/bg3_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/treetops/bg4_$res.jpg
wget http://www.gstatic.com/ui/v1/icons/mail/themes/graffiti/bg_$res.jpg

echo done

