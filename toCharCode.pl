#!/usr/bin/perl -w

# toCharCode.pl - Creates decimal string for JavaScript's fromCharCode
# by dual

use strict;

my $count;

# Help
my $usage = "$0 <string>\n";

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
