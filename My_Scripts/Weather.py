#!/usr/bin/python
# -*- coding: utf-8
# Weather-Notify
# See below for instructions to adapt for your city

import xml.parsers.expat
import urllib
from os import execvp

ignore_elements = [
	'guid',
	'geo:lat',
	'geo:long',
	'link',
	'title',
	'ttl',
	'rss',
	'channel',
	'lastBuildDate',
	'pubDate',
	'width',
	'height',
	'item']
in_element = ""

wdata = {}
ferr = 0
icon = '/usr/share/pixmaps/gnome-question.png'
save_image_filename = "/tmp/weather-notify-temp.gif"

def start_element(name, attrs):
	global in_element, wdata
	in_element += "." + name
	if name not in ignore_elements:
		if (in_element == ".rss.channel.yweather:location"):
			wdata['city'] = attrs['city']
		elif (in_element == ".rss.channel.yweather:units"):
			wdata['units'] = attrs
		elif (in_element == ".rss.channel.yweather:wind"):
			wdata['wind'] = attrs
		elif (in_element == ".rss.channel.yweather:atmosphere"):
			wdata['atmosphere'] = attrs
		elif (in_element == ".rss.channel.yweather:astronomy"):
			wdata['astronomy'] = attrs
		elif (in_element == ".rss.channel.item.yweather:condition"):
			wdata['condition'] = attrs
		else:
			#print 'Start element:', in_element, attrs
			pass

def end_element(name):
	global in_element
	in_element = in_element[:-(name.__len__() + 1)]
	if in_element not in ignore_elements:
		#print 'End element:', in_element + "." + name
		pass

def char_data(data):
	global wdata, ferr
	if in_element not in ignore_elements:
		if (in_element == ".rss.channel.item.description"):
			for line in data.split("\n"):
				if (line != ""):
					for attr in  line.split("\""):
						if attr.count("yimg.com") > 0:
							wdata['image_url'] = attr
		elif (in_element == ".rss.channel.title" and data == "Yahoo! Weather - Error"):
			ferr = 1
		elif (data != "\n" and data != " "):
			#print 'Character data:', repr(data)
			pass

p = xml.parsers.expat.ParserCreate()

p.StartElementHandler = start_element
p.EndElementHandler = end_element
p.CharacterDataHandler = char_data

# go to weather.yahoo.com
# enter your zip code in left search GO
# choose your town from drop down list
# it will refresh with your town
# look at the page source
# find a line like : href="http://weather.yahooapis.com/forecastrss?p=USNJ0107&amp;u=f">
# copy  after p= till &
# replace in next line in same place
# end with &u=c for Celsius &u=f for Fahrenheit
# currently set on Columbus, Ohio

urlfd1 = urllib.urlopen("http://xml.weather.yahoo.com/forecastrss?p=USOH0212&u=f")
p.Parse(urlfd1.read(), 1)

#p.Parse(xwyc, 1)

if (ferr == 1):
	title = "XML fetch error"
	message = "Unable to retrieve weather information"

else:
	title = wdata['city'] + ": " + wdata['condition']['temp'] + u'°' + wdata['units']['temperature'] + " (" + wdata['condition']['text'] + ")"
	message  = "<b>Windspeed:</b>\t" + wdata['wind']['speed'] + " " + wdata['units']['speed'] + "\n"
	message += "<b>Windchill:</b>\t" + wdata['wind']['chill'] + u'°' + wdata['units']['temperature'] + "\n"
	message += "<b>Sunrise:</b>\t\t" +"Sunset:</b>"+ "\t\n" + wdata['astronomy']['sunrise'] + "\t\t" + wdata['astronomy']['sunset'] + "\n"
	message += "<b>Humidity:</b>\t" + wdata['atmosphere']['humidity'] + "%\n"
	message += "<b>Pressure:</b>\t" + wdata['atmosphere']['pressure'] + " " + wdata['units']['pressure'] + "\n"
	message += "<b>Visibility:</b>\t" + wdata['atmosphere']['visibility'] + " " + wdata['units']['distance']
	urlfn, urlhdrs = urllib.urlretrieve(wdata['image_url'], save_image_filename)
	if not urlhdrs.type == "text/html":
		icon = save_image_filename
args = [
	'notify-send',
	'--icon='+icon,
	title,
	message]

execvp("notify-send", args)
