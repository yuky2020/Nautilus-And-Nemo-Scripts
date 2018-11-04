#!/usr/bin/ruby

VERSION="0.1.2"
CONFIGFILE_PATH=File.expand_path("~/.imploaderrc")

require 'fileutils'
require 'open-uri'
require 'find'

if not File.file?(CONFIGFILE_PATH)
  File.open(CONFIGFILE_PATH, "w") do |file|
    file.write <<EOS
# Imploader #{VERSION}    
# Edit these:
TEMPPATH="~/Desktop/" # Path to save the wallpaper and temp files
STYLE=1               # Black=1, White=2, Polaroid=3
W=1600                # Width of final image
H=1200                # Height of final image
BORDERW=50            # Left/right border width
BORDERH=50            # Top/bottom border height
N=3                   # How many pictures do you need horizontally?
M=2                   # and vertically?
EOS
  end
  puts "Configfile generated, please edit #{CONFIGFILE_PATH}"
  exit
end

load CONFIGFILE_PATH
TMPPATH = File.expand_path(TEMPPATH)

def get_random_names(array, n)
  additional = Array.new

  Find.find("#{TMPPATH}/additional_images/") do |path|
    additional.push(path) if File.file?(path)
  end

  additional = additional.shuffle[0..n-1]

  if additional.size < n
    array = array.shuffle[0..(n-additional.size)-1]+additional
  else
    array = additional
  end
  images = " " + array.shuffle.join(" ") + " "
  return images
end

FileUtils.mkdir_p TMPPATH + "/posters"
FileUtils.mkdir_p TMPPATH + "/additional_images"
FileUtils.mkdir_p TMPPATH + "/tmp"

@no_internet=false
ARGV.each do |argument|
  case argument
  when "--help", "-h"
    puts "IMPloader #{VERSION}
--no-internet, -n: generate only (no internet)
--help,        -h: show this help
You can edit options in #{CONFIGFILE_PATH}"
    exit
  when "--no-internet", "-n"
    @no_internet=true
  else
    puts "Unknown argument #{argument}"
    exit
  end 
end

unless @no_internet
  puts "Downloading index..."
  File.open("#{TMPPATH}/tmp/index.html", "w") do |file|
    file.write(open('http://www.impawards.com/').read.split("<!--// Posters Start //-->")[1].split("<!--// Posters End //-->")[0])
  end
end

file = File.open("#{TMPPATH}/tmp/index.html")
array = file.read.split(" ")
file.close

array.delete_if do |item|
  not item.include?("/thumbs/")
end

array.map! do |i|
  i.sub!("thumbs", "posters")
  i.sub!("imp_", "")
  entries = Dir.entries("#{TMPPATH}/posters")
  unless @no_internet or entries.include?(i.split("/")[-1])
    filename = "#{TMPPATH}/posters/#{i.split("/")[-1]}"
    begin
      puts "Downloading #{i.split("/")[-1]}"
      File.open(filename, "w") do |file|
        file.write(open('http://www.impawards.com/'+i).read)
      end
    rescue Interrupt
      puts "ctr+c hit, exiting"
      FileUtils.rm (filename) if File.file?(filename)
      exit
    end
  end
  TMPPATH + "/posters/" + i.split("/")[-1]
end

case STYLE
when 1
  images = get_random_names(array, N*M)
  COLOR = "black"

  IMGCOMMAND="-background #{COLOR} -border 2x2 -bordercolor white -geometry #{((W-(BORDERW*2))/N)-45+1}x#{(H-(BORDERH*2))/M-45+1}+20+20 -monitor -tile #{N}x#{M} #{TMPPATH}/collage_tmp.jpg"

  system "cd #{TMPPATH}/posters; montage " + images + IMGCOMMAND

when 2
  images = get_random_names(array, N*M)
  COLOR="white"

  IMGCOMMAND="-shadow -geometry #{((W-(BORDERW*2))/N)-40-1}x#{((H-(BORDERH*2))/M)-40-4}+20+20 -monitor -tile #{N}x#{M} #{TMPPATH}/collage_tmp.jpg"

  system "cd #{TMPPATH}/posters; montage " + images + IMGCOMMAND

when 3
  images = get_random_names(array, N*M)
  COLOR="LightGray"
    
  IMGCOMMAND="-monitor -border 2x2 -background black +polaroid -background LightGray -tile #{N}x#{M} -geometry #{46+(W-(BORDERW*2))/N}x#{46+(H-(BORDERH*2))/M}-25-25 #{TMPPATH}/collage_tmp.jpg"

  system "cd #{TMPPATH}/posters; montage " + images + IMGCOMMAND

end

system "cd #{TMPPATH}; convert collage_tmp.jpg -background #{COLOR} -gravity center -extent #{W}x#{H}  collage.jpg"
system "cd #{TMPPATH}; rm collage_tmp.jpg"

puts "\nWallpaper generated, saved as #{TMPPATH}/collage.jpg"
