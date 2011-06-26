#!/usr/bin/perl -w

# dnsx.pl - Automates zone file transfers
# by dual

use strict;

# Declare
my $domain;
my $output;
my $where_to_print = 0;
my $usage = "dnsx.pl -
Automates zone file transfers
Usage: perl dnsx.pl <domain.(com|edu|net)> [o]
o => Output results to domain.zone.txt
";

# Get and check args and handle output
print $usage and exit unless defined(my $fqdn = shift);
print $usage and exit if $fqdn !~  /^[0-9a-z\-]+\.com|edu|net$/;

if (my $option = shift) {
  if ($option =~ /o/) {
    $where_to_print = 1;
    ($domain, undef) = split(/\./, $fqdn);
    open $output, '>>', "$domain.zone.txt" or die ">>> Can't create $domain.zone.txt: $!";
    print $output ">>> dnsx.pl -\n\n";
  }
  else { print $usage and exit; }
}

# Print header
print ">>> dnsx.pl -\n\n";
print ">>> Printing output to $domain.zone.txt\n" if $where_to_print == 1;

# Parse whois query
my @lookup = `whois -h whois.internic.net $fqdn`;

foreach my $line (@lookup) {
  if ($line =~ /Name Server: (.+)$/) {
    if ($where_to_print == 1) {
      print $output ">>> Found name server: $1\n";
    }
    else { print ">>> Found name server: $1\n"; }
    transfer($1);
  }
}

# Perform transfer on each name server
sub transfer {
  my @zone_transfer = `dig axfr \@$_[0] $fqdn`;
  if ($where_to_print == 1) {
    print $output @zone_transfer;
  }
  else { print @zone_transfer; }
}
