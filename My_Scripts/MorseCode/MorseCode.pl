#!/usr/bin/perl

use strict;

## Morse Code Converter version 2
## Copyright (C) 2010 Cipherboy_LOC
## Licensed under the GNU General Public License version 3.

# Morse Code Table:
# a = .-	| x = -..-
# b = _...	| y = -.--
# c = -.-.	| z = --..
# d = -..	| 1 = .----
# e = .		| 2 = ..---
# f = ..-.	| 3 = ...--
# g = --.	| 4 = ....-
# h = ....	| 5 = .....
# i = ..	| 6 = -....
# j = .---	| 7 = --...
# k = -.-	| 8 = ---..
# l = .-..	| 9 = ----. 
# m = --	| 0 = -----
# n = -.	| , = ..-..
# o = ---	| . = .-.-.-
# p = .--.	| ? = ..--..
# q = --.-	| ; = -.-.-
# r = .-.	| : = ---...
# s = ...	| / = -..-.
# t = -		| - = -....-
# u = ..-	| ' = .----.
# v = ...-	| () = -.--.-
# w = .--	| _ = ..--.-
# (space) = /

## The main method of the program. It encrypts and decrypts text based on arguments. 
sub main {
	## Argument parsing variables.
	my $ARGC = $#ARGV+1;
	my $ARGI = 0;
	
	## Variable that stores the text to encrypt/decrypt.
	my $text = '';
	
	## Variable that stores the output of the encryption/decryption to/from morse code.
	my $output;
	
	## Depending on what this variable is set to, the program either encrypts or decrypts the $text variable.
	### Values: 
	#### $EorD = 'Encrypt';
	##### Used to encrypt the $text variable.
	
	#### $EorD = 'Decrypt';
	##### Used to decrypt the $text variable.
	my $EorD = '';
	
	## If set, this variable will specify a file to write the $output variable to.
	my $outFile = '';
	
	## If set, $text will be gotten VIA STDIN.
	my $stdin = '';
	
		
	## Make sure we at least have one argument before going through and parsing them. 
	if ($ARGC eq '0') {
		## Whoops, there were no arguments passed! Print the help text, print a helpful message, and exit.
		printHelp();
		print "\nPlease specify at least on argument... Exiting...\n";
		exit 1;
	}
	
	## Parse the arguments.
	for ($ARGI = 0; $ARGI < $ARGC; $ARGI++) {
	
		## Create a variable to store the current argument in.
		my $value = $ARGV[$ARGI];
		
		## Start testing for arguments. For printing the help text, the possible choices are:
		### --help
		### -help
		### -h
		### -?
		### /help
		### /h
		### /?
		if (($value eq '--help') or ($value eq '-help') or ($value eq '-h') or ($value eq '-?') or ($value eq '/help') or ($value eq '/h') or ($value eq '/?')) {
			## Print the help text, and exit successfully.
			printHelp();
			exit 0;
		} elsif (($value eq '--license') or ($value eq '-license') or ($value eq '-l') or ($value eq '/license') or ($value eq '/l')) {
			## For printing the license the choices are:
			### --license
			### -license
			### -l
			### /license
			### /l
			
			## Print the license and exit successfully.
			printLicense();
			exit 0;
		} elsif (($value eq '--encrypt') or ($value eq '-encrypt') or ($value eq '-e') or ($value eq '/encrypt') or ($value eq '/e')) {
			## For encrypting [text] the choices are:
			### --encrypt
			### -encrypt
			### -e
			### /encrypt
			### /e
			
			## Make sure $EorD (The variable that decides which to do (Encrypt or Decrypt)) is not set...
			if ($EorD eq '') {
				## If it is not set, set it to Encrypt.
				$EorD = 'Encrypt';
			} else {
				## Whoops, it is already set. Exit with an error.
				print "Error, please use either the -d OR -e options... Exiting...\n";
				exit 1;
			}
		} elsif (($value eq '--decrypt') or ($value eq '-decrypt') or ($value eq '-d') or ($value eq '/decrypt') or ($value eq '/d')) {
			## For decrypting [text] the choices are:
			### --decrypt
			### -decrypt
			### -d
			### /decrypt
			### /d
			
			## Make sure $EorD (The variable that decides which to do (Encrypt or Decrypt)) is not set...
			if ($EorD eq '') {
				## If it is not set, set it to Decrypt.
				$EorD = 'Decrypt';
			} else {
				## Whoops, it is already set. Exit with an error. 
				print "Error, please use either the -d OR -e options... Exiting...\n";
				exit 1;
			}
		} elsif (($value eq '--input') or ($value eq '-input') or ($value eq '-i') or ($value eq '/input') or ($value eq '/i')) {
			## For specifying [text] from a file, the choices are:
			### --input [file]
			### -input [file]
			### -i [file]
			### /input [file]
			### /i [file]
			
			## The next argument passed is the name of the file to read [text] from.
			my $file = $ARGV[$ARGI+=1];
			
			## Make sure that $text is not set...
			if ($text eq '') {
				## If it is not set, make sure the file ([file]) exists.
				if (-e $file) {
					## So [file] exists, so read it and load it into $text after removing all un-needed characters.
					
					## Open up a file handle on the file.
					open (FILE, '<', $file) or die "Error opening $file...\n";
					
					## Create an array to store the contents of the file line by line.
					my @contents = <FILE>;
					
					## Close the file handle.
					close(FILE);
					
					## Load each line (from the array @contents) into $contents...
					foreach my $contents (@contents) {
						## Remove the \n at the end of the line. It is there because at the end of each line in a file there is a \n.
						chomp($contents);
						
						## Check to see if the line contains characters that cannot be encrypted in morse code.
						if ($contents =~ /^[abcdefghijklmnopqrstuvwxyz123456789,\.\?;:\/\-\(\)_\/ ]{1,}$/i) {
							## The line only contains characters that can be encoded in morse code, so we can add it to $text.
							$text .= $contents;
						} else {
							## The line contains characters that cannot encoded using morse code, so remove it.
							while ($contents =~ s/[^abcdefghijklmnopqrstuvwxyz123456789,\.\?;:\/\/\-\(\)_ ]{1}//i) {}
							
							## Now that they are removed, its time to add it to $text.
							$text .= $contents;
						}
					}
				} else {
					## Tell the user that $file does not exist and exit with an error.
					print "No such file or directory $file...\n";
					exit 1;
				}
			} else {
				## Whoops, it was set already. Exit with an error.
				print "Please use either the --text or the --input. Do not use both. Exiting...\n";
				exit 1;
			}
		} elsif (($value eq '--output') or ($value eq '-output') or ($value eq '-o') or ($value eq '/output') or ($value eq '/o')) {
			## The choices for specifying an output file are:
			### --output [file]
			### -output [file]
			### -o [file]
			### /output [file]
			### /o [file]
			
			## The next argument passed should be the name of the output file, so save it into a temp variable. 
			my $path = $ARGV[$ARGI+=1];
			
			## Remove whitespace at the end. Just in case.
			chomp($path);
			
			## Save the path to $outFile for later use.
			$outFile = $path;
		} elsif (($value eq '--stdin') or ($value eq '-stdin') or ($value eq '-s') or ($value eq '/stdin') or ($value eq '/s')) {
			## To specify [text] from STDIN use:
			### --stdin
			### -stdin
			### -s
			### /stdin
			### /s
			
			## Set $stdin to true. 
			$stdin = 'true';
		} elsif (($value eq '--text') or ($value eq '-text') or ($value eq '-t') or ($value eq '/text') or ($value eq '/t')) {
			## To specify [text] as an option use:
			### --text [text]
			### -text [text]
			### -t [text]
			### /text [text]
			### /t [text]
			
			## Check to see if [text] has been specified before...
			if ($text eq '') {
				## Nope? Then we are good to go. Take the next argument and add it to $text.
				$text = $ARGV[$ARGI+=1];
				
				## Remove whitespace at the end.. Just in case...
				chomp($text);
			} else {
				## Whoops, [text] was previously specified... Exit with an error.
				print "Please use either the --text or the --input. Do not use both. Exiting...\n";
				exit 1;
			}
		} else {
			## There was an unknown option. Print the help and exit with an error.
			printHelp();
			print "\nError. Unknown Option: $value... Exiting.\n";
			exit 1;
		}
	}
	
	## Parsing the arguments is half the work. Now we need to act upon the passed arguments further.
	
	## Check to see if $text is equal to nothing (AKA it is not set)...
	if ($text eq '') {
		## Check to see if $stdin is set...
		if ($stdin eq '') {
			## Because it is not set, exit with an error.
			print "Nothing to encrypt/decrypt in Morse Code... Exiting...\n";
			exit 1;
		} else {
			## Because it is set, get [text] from STDIN.
			my $TMP = "\L$EorD";
			print "What would you like to $TMP in Morse Code?\n> ";
			$text = <STDIN>;
			
			## Remove the new line (from pressing enter) from $text.
			chomp($text);
		}
	}
	
	## Check to see which to do: Encrypt or Decrypt (from $EorD).
	if ($EorD eq 'Encrypt') {
		## Encrypt $text and put it in $output.
		$output = morseCodeEncrypt($text);
	} elsif ($EorD eq 'Decrypt') {
		## Decrypt $text and put it in $output.
		$output = morseCodeDecrypt($text);
	} else {
		## Neither was set, so exit with an error.
		print "Error... You must specify either -d or -e...\n";
		exit 1;
	}
	
	## Check for an output file...
	if ($outFile eq '') {
		## No output file, so print to STDOUT.
		print "$output\n";
		exit 0;
	} else {
		## An output file was specified, so print to the file..
		
		## Open up a file handle on the $outFile...
		open(OUTFILE, '> ', $outFile);
		
		## Print to the file..
		print OUTFILE "$output\n";
		
		## Close the output file.
		close(OUTFILE);
		exit 0;
	}
	
}

sub printHelp {
	## Method to print the help text. Just print a bunch of stuff and add a new line character after it.
	print "Morse Code Converter v2\n";
	print "Copyright (C) 2010 Cipherboy_LOC\n";
	print "Licensed under the GNU General Public License version 3.\n\n";
	print "Options: \n";
	print "-d, --decrypt\t\tSet the mode to decrypt.\n";
	print "-e, --encrypt\t\tSet the mode to encrypt.\n";
	print "-h, --help\t\tPrint this help text.\n";
	print "-i, --input [file]\tGet [text] from [file].\n";
	print "-l, --license\t\tPrint the GNU GPL version 3.\n";
	print "-o, --output [file]\tOutput the results to [file].\n";
	print "-s, --stdin\t\tUse STDIN to read the text to encrypt/decrypt using Morse Code.\n";
	print "-t, --text [text]\tThe text to encrypt/decrypt using Morse Code.\n";
}

sub printLicense {
	## Method to print the license. 
	print "Morse Code Convert v2\n";
	print "Copyright (C) 2010 Cipherboy_LOC\n";
	print "Licensed under the GNU General Public License version 3.\n\n";
	print "GNU GPLv3:\n";
	
	## Find a GNU GPL v3 license some where. If it cannot be found, download it from the internet.
	if (-e '/usr/share/common-licenses/GPL-3') {
		open(LICENSE, '<', "/usr/share/common-licenses/GPL-3");
		my @license = <LICENSE>;
		close(LICENSE);
		foreach my $line (@license) {
			chomp($line);
			print "$line\n";
		}
	} elsif (-e '/usr/share/R/share/licenses/GPL-3') {
		open(LICENSE, '<', "/usr/share/R/share/licenses/GPL-3");
		my @license = <LICENSE>;
		close(LICENSE);
		foreach my $line (@license) {
			chomp($line);
			print "$line\n";
		}
	} else {
		my @license = `curl -s http://www.gnu.org/licenses/gpl-3.0.txt`;
		if ($license[0] eq '') {
			@license = `wget -O- http://www.gnu.org/licenses/gpl-3.0.txt`;
			if ($license[0] eq '') {
				print "Unable to download GNU General Public License version 3...\nYou can read it on http://www.gnu.org/licenses/gpl-3.0.txt \n\n";
				exit 0;
			}
		}
		foreach my $line (@license) {
			chomp($line);
			print "$line\n";
		}
	}
}

sub morseCodeEncrypt {
	## Function to encrypt the first argument passed. Returns encrypted text.
	
	## Get the first argument passed and store as a new variable.
	my $toEncrypt = shift;
	
	## Convert all letters to lower case.
	$toEncrypt = lc($toEncrypt);
	
	## Create a variable to store the encrypted text.
	my $result;
	
	## This hash stores the table of conversion. Just access $morseCodeHashEN{'a'} to get what 'a' equals when encrypted: '.-'.
	my %morseCodeHashEN = (
		'a', '.-',
		'b', '-...',
		'c', '-.-.',
		'd', '-..',
		'e', '.',
		'f', '..-.',
		'g', '--.',
		'h', '....',
		'i', '..',
		'j', '.---',
		'k', '-.-',
		'l', '.-..',
		'm', '--',
		'n', '-.',
		'o', '---',
		'p', '.--.',
		'q', '--.-',
		'r', '.-.',
		's', '...',
		't', '-',
		'u', '..-',
		'v', '...-',
		'w', '.--',
		'x', '-..-',
		'y', '-.--',
		'z', '--..',
		'1', '.----',
		'2', '..---',
		'3', '...--',
		'4', '....-',
		'5', '.....',
		'6', '-....',
		'7', '--...',
		'8', '---..',
		'9', '----.',
		'0', '-----',
		',', '..-..',
		'.', '.-.-.-',
		'?', '..--..',
		';', '-.-.-',
		':', '---...',
		'/', '-..-.',
		'-', '-....-',
		"'", '.----.',
		'(', '-.--.-',
		')', '-.--.-',
		'_', '..--.-',
		' ', ' / '
	);
	
	## A variable to store the current variable. This is just a random value because it loops until this variable is not set. 
	my $letter = 'a';
	
	## The location of the current character. 
	my $i = 0;
	
	## Loop until there are no more letters to parse.
	while ($letter ne '') {
		## Set $letter to the current letter that we want to parse.
		$letter = substr($toEncrypt, $i, 1);
		
		## Add to the result what $letter is when encrypted. Also append a space.
		$result .= "$morseCodeHashEN{$letter} ";
		
		## Add one to the current position.
		$i += 1;
	}
	
	## Return the result.
	return $result;
}

sub morseCodeDecrypt {
	## Function to decrypt the first argument passed. Returns the result of decryption.
	
	## Put the first argument into a variable.
	my $toDecryptText = shift;
	
	## Convert to lower case.
	$toDecryptText = lc($toDecryptText);
	
	## Variable to store the result of decryption
	my $result;
	
	## Hash to store the decryption table. Access it like %morseCodeHashEN
	my %morseCodeHashDE = (
		'.-', 'a',
		'-...', 'b',
		'-.-.', 'c',
		'-..', 'd',
		'.', 'e',
		'..-.', 'f',
		'--.', 'g',
		'....', 'h',
		'..', 'i',
		'.---', 'j',
		'-.-', 'k',
		'.-..', 'l',
		'--', 'm',
		'-.', 'n',
		'---', 'o',
		'.--.', 'p',
		'--.-', 'q',
		'.-.', 'r',
		'...', 's',
		'-', 't',
		'..-', 'u',
		'...-', 'v',
		'.--', 'w',
		'-..-', 'x',
		'-.--', 'y',
		'--..', 'z',
		'.----', '1',
		'..---', '2',
		'...--', '3',
		'....-', '4',
		'.....', '5',
		'-....', '6',
		'--...', '7',
		'---..', '8',
		'----.', '9',
		'-----', '0',
		'..-..', ',',
		'.-.-.-', '.',
		'..--..', '?',
		'-.-.-', ';',
		'---...', ':',
		'-..-.', '/',
		'-....-', '-',
		'.----.', "\'",
		'-.--.-', '()',
		'..--.-', '_',
		'/', ' '
	);
	
	## Split the morse code by spaces, and store in an array to be processed. 
	my @toDecrypt = split(' ', $toDecryptText);
	
	## Current place in the array.
	my $i = 0;
	
	## Length of the array.
	my $length = $#toDecrypt+1;
	
	## This is used to deal with parenthesis. (There are better ways of doing it, because this assumes the user does not embed parenthesis... (Which they might, but....))
	my $paren = 0;
	
	## Loop through the array. 
	for ($i = 0; $i < $length; $i++) {
		## Store the current character (that is encrypted in morse code) in a variable.
		my $value = $toDecrypt[$i];
		
		## Remove any whitespace at the end of the variable.
		chomp($value);
		
		## Remove all characters that are not . and -
		while ($value =~ s/[^\.\-\/]//i) {}
		
		## Check to see if the encrypted value is a parenthesis.
		if ($morseCodeHashDE{$value} ne '()') {
			## If no, add the decrypted value to $result.
			$result .= "$morseCodeHashDE{$value}";
		} else {
			## If it is, decide based on $paren what parenthesis it is (Opening or closing).
			if ($paren == 0) {
				## If $paren is 0, then it is an opening parenthesis.
				$result .= '(';
				
				## Set $paren to 1.
				$paren = 1;
			} else {
				## $paren must be 1, so it is a closing parenthesis.
				$result .= ')';
				
				## Set $paren to 0.
				$paren = 0;
			}
		}
	}
	
	## Return decrypted text.
	return $result;
}

## Call the main method, to start the program.
main();
