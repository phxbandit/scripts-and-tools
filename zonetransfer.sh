#!/bin/bash
# zonetrans.sh - Attempts full zone transfer from
#                each authoritative name server

[ $# -eq 1 ] || {
    echo "usage: zonetrans example.com"
    exit 1
}

echo
for i in $(dig ns $1 +short | sed -e 's/\.$//'); do
    echo "$i"
    dig "$1" @"$i" axfr
    echo
done
