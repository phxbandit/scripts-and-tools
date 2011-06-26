#!/usr/bin/perl -w

# convertstr.pl - by dual
#
# Reverses and converts a string to
# base64, binary, hex, and rot13 and
# provides the md5 and sha1 hashes 

use strict;
use MIME::Base64;
use Digest::MD5;
use Digest::SHA1;

my $usage = "convertstr.pl -
Reverses and converts a string to base64, binary, hex
and rot13, and provides the md5 and sha1 hashes
Usasge: perl convertstr.pl <string>
";

# Get and check args
print $usage and exit unless my $string = shift;
chomp($string);

# Print header
print "\n>>> Converting \'$string\'...\n\n";

# Reverse
print "REVERSED:\n";
my $reversed = reverse($string);
print $reversed . "\n\n";

# Base64
print "BASE64:\n";
my $base64 = encode_base64($string);
chomp($base64);
print $base64 . "\n\n";

# Binary
print "BINARY:\n";
my $binary = unpack('B*', $string);
print $binary . "\n\n";

# Hex
print "HEX:\n";
my $hex = unpack('H*', $string);
print $hex . "\n\n";

# Rot13
print "ROT13:\n";
if ($string =~ /[^A-Za-z\s]/) {
  print ">>> String must be alphabetic\n\n";
}
else {
  my $rot13 = $string;
  $rot13 =~ tr/A-Za-z/N-ZA-Mn-za-m/;
  print $rot13 . "\n\n";
}

# MD5
print "MD5:\n";
my $md5 = Digest::MD5->new;
$md5->add($string);
my $md5hex = $md5->hexdigest;
print $md5hex . "\n\n";

# SHA1
print "SHA1:\n";
my $sha1 = Digest::SHA1->new;
$sha1->add($string);
my $sha1hex = $sha1->hexdigest;
print $sha1hex . "\n\n";

# Close out
print ">>> Done!\n\n"