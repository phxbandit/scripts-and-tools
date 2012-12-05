#!/bin/bash

# mild.sh 0.5 - Subdomain brute forcer inspired by fierce.pl
# by dual (whenry)
#
# Usage: ./mild.sh <-s X> DOMAIN NAMESERVER
# -s = Sleep X number of seconds
#
# hosts-plus.txt based on hosts.txt from
# http://ha.ckers.org/fierce/hosts.txt

# Include time and date functions
. iso8601

# Main query function
query() {
	# Log output
	exec > >(tee $DOM-$SH_TIME.log)

	# Perform dig query
	for i in $(cat rand-hosts.txt); do
		dig +noall +answer $i.$DOM @$NAM
		if [ $CHECK ]; then sleep $SLEEP; fi
	done
}

# Check for minimum arguments
if [ $# -ne 2 ]; then
	if [ $# -ne 4 ]; then
		echo "mild.sh - Subdomain brute forcer"
		echo "Usage: $0 <-s X> DOMAIN NAMESERVER"
		echo "-s = Sleep X number of seconds"
		exit;
	fi
fi

# Output banner
echo "Starting mild.sh ( https://github.com/getdual ) at $TIME"

# Check for sleep
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
if [ -f hosts-plus.txt ]; then
	echo "  Good, we have a subdomain list."
else
	echo "  No subdomain list. Fetching."
	echo "  Checking for wget:"
	type wget || {
		echo "  No wget. Forget it."
		exit;
	}
	wget https://raw.github.com/getdual/scripts-n-tools/master/hosts-plus.txt
fi

# Randomize subdomains
echo "  Randomizing subdomains."
if [ $(uname) = "Darwin" ]; then
	for i in $(cat hosts-plus.txt); do echo "$RANDOM $i"; done | sort | sed -E 's/^[0-9]+ //' > rand-hosts.txt
else
	sort -R hosts-plus.txt > rand-hosts.txt
fi

echo "  Brute forcing subdomains of $DOM using nameserver, $NAM."
echo

# Call main function
query
