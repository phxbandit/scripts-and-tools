#!/usr/bin/env perl -w

# netbiowned.pl - Simplifies windows share enumeration
# VVestron Phoronix
#
# Usage: perl netbiowned.pl <ip addresss>

use strict;

# Declare
my $ip_addr;
my $comp_name;

# Get and check args
usage() unless defined($ip_addr = shift);
usage() unless $ip_addr =~ /(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/;
usage() unless ($1 < 255 && $2 < 255 && $3 < 255 && $4 < 255);

# Provide assistance
sub usage {
    print "netbiowned.pl - Simplifies windows share enumeration\n";
    print "Usage: perl netbiowned.pl <ip address>\n";
    exit;
}

# Perform initial lookup
print "netbiowned.pl -
Performing initial lookup...";

my @lookup = `nmblookup -A $ip_addr`;

foreach my $line (@lookup) {
    if ($line =~ /No reply/i) {
        print "\nWindows shares not vulnerable... exiting.\n";
        exit;
    }
    else {
        if ($line =~ /\s*([\w\-]*)\s*<00>/ && $line !~ /GROUP/) {
            $comp_name = $1;
        }
    }
}

print " Done.\n";

# Now list shares
print "Attempting to list shares on $comp_name...
Try a password of \'password\' and

    smbclient //$comp_name/DIR -I $ip_addr

if that's successful.
";

system("smbclient -L $comp_name -I $ip_addr");
