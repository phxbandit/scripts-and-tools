#!/bin/bash
# zonetrans.sh - Attempts full zone transfer from
#                each authoritative name server

if [ $# -ne 1 ]; then
    echo "usage: zonetrans example.com"
    exit 1
fi

echo
for i in $(dig ns $1 +short | sed -e 's/\.$//'); do
    echo "$i"
    dig "$1" @"$i" axfr
    echo
done
