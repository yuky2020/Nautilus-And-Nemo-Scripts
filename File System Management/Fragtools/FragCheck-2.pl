#! /usr/bin/perl -w

# Original creator: _droop_
# Updated by: as
# Updated again by: c07

use strict;

@ARGV >= 1 && @ARGV <= 2 or die "usage: $0 <dir> [<block size in KB>]";

$/= "\0";
my ($files, $blocks, $fragments, $frag, $fragblocks, $multi, $empty)= (0) x 7;
my $dir= shift;
my $blocksize= (shift || 4) + 0;

print qq|scanning "$dir", using block size $blocksize KB ...\n|;

open my $find, "-|", "find", $dir, qw"-xdev -type f -print0";

while ( my $file= <$find> ) {
  { open my $fh, "-|", "filefrag", $file; $_= <$fh> }
  /:\s+(\d+) extents? found/ or (print qq|"$_"?\n|), next;
  my $n= $1 + 0;
  { open my $fh, "-|", "ls", "-sk", $file; $_= <$fh> }
  /^(\d+)\s/ or (print qq|"$_" (ls)?\n|), next;
  my $s= $1 / $blocksize;
  ++$files;
  $s or ++$empty, next;
  $blocks += $s;
  $fragments += $n;
  ++$frag, $fragblocks += $s if $n > 1;
  ++$multi if $s > 1;
}

my $single= $files - $multi - $empty;
my $nonfrag= $files - $frag - $empty;

if ( ! $files ) { print "no files\n" }
else {
  printf "$files files, $frag (%.3f %%) fragmented\n", 100 * $frag / $files;
  if ( ! $multi ) { print "no multi-block files\n" }
  else {
    printf "$multi multi-block files, %.3f %% fragmented\n",
      100 * $frag / $multi;
  }
  print "$blocks blocks, $fragments fragments, $empty empty files\n";
  if ( $fragments ) {
    printf "average %.3f fragments per file, %.3f blocks per fragment,\n",
      $fragments / $files, $blocks / $fragments;
    if ( $multi ) {
      printf "%.3f fragments per multi-block file, %.3f blocks each,\n",
        ($fragments - $single) / $multi,
        ($blocks - $single) / ($fragments - $single);
      if ( $frag ) {
        printf "%.3f fragments per fragmented file, %.3f blocks each\n",
        ($fragments - $nonfrag) / $frag,
        $fragblocks / ($fragments - $nonfrag);
} } } }
