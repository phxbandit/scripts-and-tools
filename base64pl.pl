#!/usr/bin/perl -w

# base64pl.pl - Encodes/decodes string(s) using base64
# by dual

use strict;
use MIME::Base64;

my $opt;
my $usage = "base64pl.pl -
Encodes or decodes a string using base64
Usage: perl base64pl.pl <-e|-d> <string|str1 str2 strn|\"str1 str2 strn\">
-e => encode
-d => decode
";

print $usage and exit unless (defined($opt = shift) && $opt =~ /^(-e|-d)$/);
print $usage and exit unless ($#ARGV > -1);

if ($opt =~ /e/) {
  my $enc_ref = \&encode;
  for my $enc_str (@ARGV) {
    $enc_ref->($enc_str);
  }
}
else {
  my $dec_ref = \&decode;
  for my $dec_str (@ARGV) {
    $dec_ref->($dec_str);
  }
}	

sub encode {
  my $string = $_[0];
  my $encoded = encode_base64($string);
  chomp($encoded);
  print "$string: $encoded\n";
}

sub decode {
  my $string = $_[0];
  my $decoded = decode_base64($string);
  chomp($decoded);
  print "$string: $decoded\n";
}
