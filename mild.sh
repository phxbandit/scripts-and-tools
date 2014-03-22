#!/bin/bash

# mild.sh 0.7.4 - Subdomain brute forcer inspired by fierce.pl
# by dual (whenry)
#
# Usage: ./mild.sh -d DOMAIN <-n NAMESERVER> <-s X>
# -d = Set target DOMAIN
# -n = Use NAMESERVER
# -s = Sleep X number of seconds
#
# hosts-plus.txt based on hosts.txt from
# http://ha.ckers.org/fierce/hosts.txt

# Help function
help() {
    cat <<EndHelp
mild.sh - Subdomain brute forcer
Usage: mild.sh -d DOMAIN [-n NAMESERVER] [-s X]
  -d
      Set target DOMAIN
  -n
      Use NAMESERVER
  -s
      Sleep X number of seconds
EndHelp
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

while getopts :d:n:s: opt; do
    case $opt
    in
        d) dom=${OPTARG};;
        n) nam=${OPTARG};;
        s) sleep=${OPTARG};;
    esac
done

# Source time and date functions
[ -e "$HOME/.iso8601" ] || {
    wget -q https://raw.github.com/getdual/scripts-n-tools/master/iso8601
    mv iso8601 $HOME/.iso8601
}
. "$HOME/.iso8601"

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
        echo "Sleeping $sleep second(s) between queries"
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
    exit 1
fi

# Check for subdomains list
if [ -f hosts-plus.txt ]; then
    echo "Subdomain list found"
else
    echo "No subdomain list found... fetching"
    if [ "$(which wget)" = '' ]; then
        echo "No wget... exiting"
        exit 1
    fi
    wget -q https://raw.github.com/getdual/scripts-n-tools/master/hosts-plus.txt
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
