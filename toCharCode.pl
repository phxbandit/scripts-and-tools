#!/usr/bin/perl -w

# toCharCode.pl - Creates decimal string for JavaScript's fromCharCode
# WSTN

use strict;

my $count;

# Help
my $usage = "toCharCode.pl - Creates decimal string for JavaScript's fromCharCode
Usage: perl toCharCode.pl <string>
";

# Get and check args
print $usage and exit unless my $string = shift;
chomp($string);

my @decimal = unpack('C*', $string);
foreach (@decimal) {
  if ( ++$count == scalar(@decimal) ) {
    print "$_\n";
  }
  else {
    print "$_,";
  }
}
