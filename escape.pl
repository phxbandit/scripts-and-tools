#!/usr/bin/perl -w

# escape.pl - Automatically escapes regular expressions

use strict;
use Getopt::Std;

# Handle arguments
my %opts;

getopts('h', \%opts);

if ($opts{h}) {
    help();
}

# Provide help
sub help {
    print "
escape.pl - Automatically escapes regular expressions

  Usage: escape.pl
    -h
        Show this help

  Delineate regex commands with three commas, e.g.: ,,,REGEX,,,
  and then paste the regex at the prompt.

";
    exit;
}

# Ask user for the regex they want to test 
print "\nPlease enter the regex: ";

# Clear any spaces at the beginning or end of the input
chomp(my $regex = <STDIN>);

# Split the regex in to an array using a pre-defined delimiter
my @array = split(",,,", $regex);
my $result;

# Loops through the array and on the even array values look for and escape any special characters
for ( my $i=0; $i < scalar(@array); $i++ ) {
        if ($i % 2 == 0){
                $array[$i] =~ s/(\\|\/|\*|\+|\?|\^|\$|\(|\)|\[|\]|\{|\}|\.|\:|\&|\@|\|)/\\$1/g;
        }

        $result .= $array[$i];
}

print "\n$result\n\n";
