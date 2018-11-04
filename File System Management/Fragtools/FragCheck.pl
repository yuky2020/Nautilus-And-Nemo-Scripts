#!/usr/bin/perl -w

# Original creator: _droop_
# Updated by: as
# Updated again by: user11

#this script search for frag on a fs
use strict;

#number of files
my $files = 0;
#number of fragment
my $fragments = 0;
#number of fragmented files
my $fragfiles = 0;

my $verbose;

if ($ARGV[0] eq '-v') { shift @ARGV; $verbose++; }

open (REPORT, "find " . $ARGV[0] . " -xdev -type f -print0 | xargs -0 filefrag |");

while (defined (my $res = <REPORT>)) {
        if ($res =~ m/.*:\s+(\d+) extents? found$/) {
                my $fragment = $1;
                $fragments += $fragment;
                if ($fragment > 1) {
                        $fragfiles++;
                }
                $files++;
        } else {
                print ("Failed to parse: $res\n");
        }
}
close (REPORT);

if ($verbose) {
   print "Total files:      $files\n";
   print "Fragmented files: $fragfiles\n";
   print "Fragments:        $fragments\n";
}

sub round($$) {
   my $v = shift; # value
   my $p = shift; # rouding divisor (1 for '123', 10 for '123.4', 100 for '123.45')
   return int($v * $p) / $p;
}
print ( $fragfiles / $files * 100 . "% non contiguous files, " . $fragments / $files . " average fragments.\n");
