#!/usr/bin/perl -Wall
#
my @mp3s = reverse (@ARGV);

foreach (@mp3s) {
	system ("audacious -e \"$_\"");
}
