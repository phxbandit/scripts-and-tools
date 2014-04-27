#!/usr/bin/perl -w

# convertstr.pl - Reverses and converts a string to:
# Base64, binary, decimal, hex, ROT13, MD5, SHA1, and SHA256 
#
# by dual (whenry)

use strict;
use MIME::Base64;
use Digest::MD5;
use Digest::SHA qw(sha1_hex sha256_hex);

my $usage = "convertstr.pl - Reverses and converts a string to:
    Base64, binary, decimal, hex, ROT13, MD5, SHA1, and SHA256
Usasge: perl convertstr.pl <string>
";

# Get and check args
print $usage and exit unless my $string = shift;
chomp($string);

print "Converting \'$string\'...\n\n";

# Reverse
print "REVERSED:";
my $reversed = reverse($string);
print $reversed . "\n";

# Base64
print "BASE64:";
my $base64 = encode_base64($string);
chomp($base64);
print $base64 . "\n";

# Binary
print "BINARY:";
my $binary = unpack('B*', $string);
print $binary . "\n";

# Decimal
print "DECIMAL:";
my @decimal = unpack('C*', $string);
foreach (@decimal) {
    print $_;
}
print "\n";

# Hex
print "HEX:";
my $hex = unpack('H*', $string);
print $hex . "\n";

# ROT13
print "ROT13:";
my $rot13 = $string;
$rot13 =~ tr/A-Za-z/N-ZA-Mn-za-m/;
print $rot13 . "\n";

# MD5
print "MD5:";
my $md5 = Digest::MD5->new;
$md5->add($string);
my $md5hex = $md5->hexdigest;
print $md5hex . "\n";

# SHA1
print "SHA1:";
my $sha1hex = sha1_hex($string);
print $sha1hex . "\n";

# SHA256
print "SHA256:";
my $sha256hex = sha256_hex($string);
print $sha256hex . "\n";

print "\nComplete\n"
