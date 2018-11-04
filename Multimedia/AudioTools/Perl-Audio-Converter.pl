#!/usr/bin/perl
#
# Copywrite (C) Philip Lyons 2013 (vorzox@gmail.com)
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;
use File::Spec::Functions qw(rel2abs);

my $debug = 0;
my $input = '';

my $name = "Perl Audio Converter";

my $formats = "FALSE 3G2 FALSE 3GP FALSE 8SVX FALSE AAC FALSE AC3 FALSE ADTS FALSE AIF FALSE AIFF FALSE AL FALSE AMB FALSE AMR FALSE APE FALSE AU FALSE AVR FALSE BONK FALSE CAF FALSE CDR FALSE CVU FALSE DAT FALSE DTS FALSE DVMS FALSE F32 FALSE F64 FALSE FAP FALSE FLA FALSE FLAC FALSE FSSD FALSE GSRT FALSE HCOM FALSE IMA FALSE IRCAM FALSE LA FALSE M4A FALSE MAT FALSE MAT4 FALSE MAT5 FALSE MAUD FALSE MMF FALSE MP2 FALSE MP3 FALSE MP3HD FALSE MP4 FALSE MPC FALSE MPP FALSE NIST FALSE OFF FALSE OFR FALSE OFS FALSE OGA FALSE OGG FALSE OPUS FALSE PAF FALSE PRC FALSE PVF FALSE RA FALSE RAM FALSE RAW FALSE RF64 FALSE RM FALSE SD2 FALSE SF FALSE SHN FALSE SMP FALSE SND FALSE SOU FALSE SPX FALSE SRC FALSE TTA FALSE TXW FALSE VMS FALSE VOC FALSE W64 FALSE WAV FALSE WMA FALSE WV";

# main sub
sub process_files {

  # sort through input files and discard those with unsupported formats (excluding directories)
  foreach (@ARGV) {

          chomp($_);

          $_ = rel2abs($_);

          my $input_ext = `echo \"$_\" | awk -F"." '{print \$NF}'`;
          print "\"$_\" has the ext $input_ext\n" if $debug == 1;
          
          if (-f $_ and not `pacpl --formats | grep $input_ext`) 
          {
             print "$_ has unrecognized extension, skipping...\n" if $debug == 1;
            `notify-send \"$name\" \"Unable to convert $_ (unsupported format)\"`;
             next;
          }
          else 
          {             
             $input = "$input \"$_\"";
          }
  }       
  
  # invoke pacpl and start conversion process
  if ($input) {

      my $out_format = `zenity --title \"$name\" --width 250 --height 300 --list --radiolist --column 'Select' --column 'Output Format' $formats`;
    
      chomp($out_format);
      
      print  "pacpl --to $out_format $input --gui --gnome\n" if $debug == 1;
      system("pacpl --to $out_format $input --gui --gnome");
  }
  
}

# start main
process_files();

