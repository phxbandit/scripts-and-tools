#!/bin/bash

# mild.sh 0.7.3 - Subdomain brute forcer inspired by fierce.pl
# by dual (whenry)
#
# Usage: ./mild.sh -d DOMAIN <-n NAMESERVER> <-s X>
# -d = Set target DOMAIN
# -n = Use NAMESERVER
# -s = Sleep X number of seconds
#
# hosts-plus.txt based on hosts.txt from
# http://ha.ckers.org/fierce/hosts.txt

# Include time and date functions
# https://github.com/getdual/scripts-n-tools/blob/master/iso8601
. iso8601

# Help function
help() {
	echo "mild.sh - Subdomain brute forcer"
	echo "Usage: mild.sh -d DOMAIN <-n NAMESERVER> <-s X>"
	echo "-d = Set target DOMAIN"
	echo "-n = Use NAMESERVER"
	echo "-s = Sleep X number of seconds"
	exit 0
}

# Main query function
query() {
	# Log output
	exec > >(tee $dom-$shTime.log)

	# Perform dig query
	for i in $(cat rand-hosts.txt); do
		dig +noall +answer $i.$dom @$nam
		if [ $chk -eq 1 ]; then sleep $sleep; fi
	done
}

# Handle arguments
if [ $# -ne 2 ]; then
	if [ $# -ne 4 ]; then
		if [ $# -ne 6 ]; then
			help
		fi
	fi
fi

while getopts d:n:s: option; do
	case "${option}"
	in
		d) dom=${OPTARG};;
		n) nam=${OPTARG};;
		s) sleep=${OPTARG};;
	esac
done

# Output banner
echo "Starting mild.sh ( https://github.com/getdual ) at $isoTime"
echo

# Check for target domain
if [ ! $dom ]; then
	help
fi

# Check for and verify name server
if [ ! $nam ]; then
	nam=$(dig +short NS $dom | tail -1 | sed 's/\.$//')
fi

dig +noall +answer www.$dom @$nam > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Name server seems bad"
	echo "Try a new server with -n"
	exit 1
fi

# Check for sleep
if [ $sleep ]; then
	if [ $sleep -eq $sleep ]; then
		echo "Sleeping $sleep seconds between queries"
		chk=1
	else
		help
	fi
else
	echo "Not sleeping between queries"
	chk=0
fi

# Check for dig
if [ "$(which dig)" = '' ]; then
	echo "dig not found... exiting"
	exit 2
fi

# Check for subdomains list
if [ -f hosts-plus.txt ]; then
	echo "Subdomain list found"
else
	echo "No subdomain list found... fetching"
	if [ "$(which wget)" = '' ]; then
		echo "No wget... exiting"
		exit 3
	fi
	wget https://raw.github.com/getdual/scripts-n-tools/master/hosts-plus.txt
fi

# Randomize subdomains
echo "Randomizing subdomains"
if [ $(uname) = "Darwin" ]; then
	for i in $(cat hosts-plus.txt); do echo "$RANDOM $i"; done | sort | sed -E 's/^[0-9]+ //' > rand-hosts.txt
else
	sort -R hosts-plus.txt > rand-hosts.txt
fi

echo "Brute forcing subdomains of $dom using name server, $nam"
echo "Logging to $dom-$shTime.log"
echo

# Call main function
query
