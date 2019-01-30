#!/bin/bash
# oui.sh - IEEE OUI lookup

if [ $# -ne 1 ]; then
    echo "Usage: oui.sh <MAC address>"
    exit 1
fi

tmp_mac="$1"
ieee='http://standards-oui.ieee.org/oui.txt'
txt="$HOME/bin/oui.txt"

mac=$(echo "$tmp_mac" | cut -b 1-8 | sed -e 's/\:/-/g' | tr [:lower:] [:upper:])

if [ ! -e "$txt" ]; then
    echo "Retreiving oui.txt from ieee.org..."
    wget -q "$ieee" -O "$txt"
else
    loc_size=$(ls -l "$txt" | awk '{print $5}')
    rem_size=$(curl -sI "$ieee" | grep Content-Length | awk -F': ' '{print $2}' | tr -d '\r')
    if [ "$loc_size" != "$rem_size" ]; then
        echo "Retreiving oui.txt from ieee.org..."
        wget -q "$ieee" -O "$txt"
    fi
fi

printf "Searching for $mac...\n\n"
grep "$mac" "$txt"
echo
