#!/usr/bin/perl

# startgw.pl - Launches VM through web request
# VVinston Phelix

use strict;
use warnings;
use Net::OpenSSH;

# Define cnnx
my $host = 'HOST';
my $user = 'USER';
my $pass = 'PASS';
my $cmd = 'VBoxManage startvm "VM-NAME" --type headless';

# Create SSH object
my $DUMMY_STDIN_OUT = '/dev/null';
open(my $stdin_fh, $DUMMY_STDIN_OUT) or die;
open(my $stdout_fh, $DUMMY_STDIN_OUT) or die;
my $ssh = Net::OpenSSH->new($host, user => $user, passwd => $pass, default_stdin_fh => $stdin_fh, default_stdout_fh => $stdin_fh);
$ssh->error and die;
#print "Connected to $host\n";

# Run command
$ssh->system($cmd) or die;

# Clean up
undef $ssh;
