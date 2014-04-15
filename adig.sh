#!/bin/bash
# adig.sh - Queries authoritative name servers
#           for A, www, and TXT records

IFS=$'\n'

if [ $# -ne 1 ]; then
    echo "usage: adig example.com"
    exit 1
fi

cname="www.$1"

echo
for i in $(dig ns $1 +short | sed -e 's/\.$//'); do
    echo "$i"
    for j in $(dig "$1" @"$i" +short); do
        echo "@ A $j"
    done
    www=$(dig "$cname" @"$i" +short | head -1)
    echo "www CNAME $www"
    for k in $(dig "$1" @"$i" txt +short); do
        echo "@ TXT $k"
    done
    echo
done
