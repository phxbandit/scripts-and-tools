#!/usr/bin/env perl -w

# convertstr.pl - Reverses and converts a string
# to base64, binary, hex, and rot13 and provides
# the md5, sha1 and sha256 hashes 
#
# by dual

use strict;
use MIME::Base64;
use Digest::MD5;
use Digest::SHA qw(sha1_hex sha256_hex);

my $usage = "convertstr.pl - Reverses and converts a string
to base64, binary, hex and rot13, and provides
the md5, sha1 and sha256 hashes
Usasge: perl convertstr.pl <string>
";

# Get and check args
print $usage and exit unless my $string = shift;
chomp($string);

# Print header
print "Converting \'$string\'...\n\n";

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
my $sha1hex = sha1_hex($string);
print $sha1hex . "\n\n";

# SHA256
print "SHA256:\n";
my $sha256hex = sha256_hex($string);
print $sha256hex . "\n\n";

# Close out
print "Done.\n"
