#!/usr/bin/perl
# Copyright (c) Laszlo Simon.
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or ( at your option) any later version.
#             
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#                            
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA)

# CONFIGURATION
$explonation = 'true';        # true | false
$explonation_place = 'south'; # east|north|west|south|norteast|...

# INIT
if (`xdpyinfo | grep dimensions` =~ /(\d+)x(\d+)\s+pixels/)
{
  ($width, $height) = ($1,$2);
}
else
{
  die("Can not determine screen resolution. Maybe 'xdpyinfo' not installed.\n");
}
  
$explonation_width = int($width * 2 / 3);
$explonation_height = int($width / 10);

$date = sprintf("%02d",0+int(rand(8)))
        .sprintf("%02d",1+int(rand(12)))
        .sprintf("%02d",1+int(rand(28)));

if (system("wget --version"))
{
  die("'wget' should be installed.\n")
}

system("wget -O /tmp/apxxxxxx.html 'http://antwrp.gsfc.nasa.gov/apod/ap$date.html'");

# Get image

open HTML, "/tmp/apxxxxxx.html";
$content = join('',(<HTML>));
close HTML;

$content =~ /\<a\s+href\=\"((?:\w+\/)*)(\w+)(\.\w+)\"\s*\>\s*\n*\s*\<img/ims;

$path = $1;
$img = $2;
$ext = $3;

`mkdir -p ~/Pictures/Backgrounds`;
print ">>>>http://antwrp.gsfc.nasa.gov/$path$img$ext\n";
system("wget -O ~/Pictures/Backgrounds/$img$ext 'http://antwrp.gsfc.nasa.gov/$path$img$ext'");

# Get text

if (system("html2text"))
{
  warn("Explonation disabled. 'html2text' should be installed.\n");
  $explonation = 0;
}

if (system("convert -version"))
{
  warn("Explonation disabled. 'convert' (imagemagick) should be installed. \n");
  $explonation = 0;
}


if ($explonation)
{
  system("html2text -style pretty -o /tmp/apxxxxxx.txt /tmp/apxxxxxx.html");
 
  open TXT, "/tmp/apxxxxxx.txt";
  $content = join('',(<TXT>));
  close TXT;

  $text = 
    ($content =~ /Explanation:\s*(.*)\s*Tomorrow\'s picture:/s)
    ? $1
    : '';

  print $text."\n";
  
  $text =~ s/\n/ /g;

  open TXT, ">/tmp/apxxxxxx-anno.txt";
  print TXT $text;
  close TXT;

  system("convert ~/Pictures/Backgrounds/$img$ext "
         ."-resize $width"."x$height\\> "
         ."-size $width"."x$height xc:black +swap "
         ."-gravity center "
         ."-composite "
         ."~/Pictures/Backgrounds/$img$ext"
         );
         
  system("convert "
         ."-background '#0008' "
         ."-fill white "
         ."-gravity northwest "
         ."-pointsize 14 "
         ."-size $explonation_width"."x$explonation_height "
         ."caption:\@/tmp/apxxxxxx-anno.txt "
         ."~/Pictures/Backgrounds/$img$ext "
         ."+swap -gravity $explonation_place -composite "
         ."~/Pictures/Backgrounds/$img$ext"
         );
}

system("gconftool -t string -s /desktop/gnome/background/picture_filename ~/Pictures/Backgrounds/$img$ext");
system("xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s ~/Pictures/Backgrounds/$img$ext");
