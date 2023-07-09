#!/usr/bin/perl -w

# convertstr.pl - Converts a string into various formats
# phxbandit

use strict;
use MIME::Base64;
use Digest::MD5;
use Digest::SHA qw(sha1_hex sha256_hex sha512_hex);

my $usage = "
convertstr.pl - Converts a string into various formats

Usasge: convertstr.pl <string>

";

# Get and check args
print $usage and exit unless my $string = shift;
chomp($string);

print "\nConverting '$string'...\n\n";

# Upper
print "Upper\t: " . uc($string) . "\n";

# Lower
print "Lower\t: " . lc($string) . "\n";

# Reverse
print "Reverse\t: " . reverse($string) . "\n";

# Base64
print "Base64\t: ";
my $base64 = encode_base64($string);
chomp($base64);
print "$base64\n";

# Binary
print "Binary\t: " . unpack('B*', $string) . "\n";

# Decimal
print "Decimal\t: ";
my @decimal = unpack('C*', $string);
foreach (@decimal) {
    print $_;
}
print "\n";

# Hex
print "Hex\t: " . unpack('H*', $string) . "\n";

# Octal
print "Octal\t: ";
foreach my $tmp_str ( split(//, $string) ) {
    my $tmp_ord = ord($tmp_str);
    printf "%o", $tmp_ord;
}
print "\n";

# ROT13
print "ROT13\t: ";
my $rot13 = $string;
$rot13 =~ tr/A-Za-z/N-ZA-Mn-za-m/;
print "$rot13\n";

# ROT26lol
print "ROT26\t: ";
my $rot26 = $string;
print "$rot26\n";

# MD5
print "MD5\t: ";
my $md5 = Digest::MD5->new;
$md5->add($string);
my $md5hex = $md5->hexdigest;
print "$md5hex\n";

# SHA-1
print "SHA-1\t: " . sha1_hex($string) . "\n";

# SHA-256
print "SHA-256\t: " . sha256_hex($string) . "\n";

# SHA-512
print "SHA-512\t: " . sha512_hex($string) . "\n";

print "\nDone\n\n"