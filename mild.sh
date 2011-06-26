#!/bin/bash

# mild.sh - Subdomain brute forcer inspired by fierce.pl
# by dual
#
# Usage: ./mild.sh <-s X> DOMAIN NAMESERVER
# -s = Sleep X number of seconds
#
# Uses subdomain list, hosts.txt, from:
# http://ha.ckers.org/fierce/hosts.txt

echo "mild.sh - A subdomain brute forcer inspired by fierce.pl"

# Check for sleep, domain and nameserver arguments
if [ $# -ne 2 ]; then
	if [ $# -ne 4 ]; then
		echo "Usage: ./mild.sh <-s X> DOMAIN NAMESERVER"
		echo "-s = Sleep X number of seconds"
		exit;
	fi
fi

if [ "$1" == "-s" ]; then
	if [ $2 -eq $2 ]; then
		echo "  Sleeping $2 seconds between queries."
		CHECK=1
		SLEEP=$2
		DOM=$3
		NAM=$4
	else
		echo "  Sleep value must be integer."
		exit;
	fi
else
	echo "  No sleep. That's not very nice."
	DOM=$1
	NAM=$2
fi

# Check for dig
echo "  Checking for dig:"
type dig || {
	echo "  No dig. Maybe run aptitude install dnsutils?"
	exit;
}

# Check for subdomains list
if [ -f hosts.txt ]; then
	echo "  Good, we have a subdomain list."
else
	echo "  No subdomain list. Fetching."
	echo "  Checking for wget:"
	type wget || {
		echo "  No wget. Forget it."
		exit;
	}
	wget http://ha.ckers.org/fierce/hosts.txt
fi

# Randomize subdomains
echo "  Randomizing subdomains."
if [ $(uname) = "Darwin" ]; then
	for i in $(cat hosts.txt); do echo "$RANDOM $i"; done | sort | sed -E 's/^[0-9]+ //' > rand_hosts.txt
else
	sort -R hosts.txt > rand_hosts.txt
fi

echo "  Brute forcing subdomains of $DOM using nameserver, $NAM."
echo

# Perform queries
for i in $(cat rand_hosts.txt); do
	dig +noall +answer $i.$DOM @$NAM
	if [ $CHECK ]; then sleep $SLEEP; fi
done
