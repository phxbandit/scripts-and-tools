#!/bin/bash
# oui.sh - IEEE OUI lookup

help() {
    echo "Usage: oui.sh <MAC address>"
    exit 1
}

if [ $# -ne 1 ]; then
    help
fi

tmp_mac="$1"
ieee='http://standards-oui.ieee.org/oui.txt'
txt="$HOME/bin/oui.txt"

if [[ "$tmp_mac" =~ ^([0-9A-Fa-f]{2}(:|-)){5}[0-9A-Fa-f]{2}$ ]]; then
    mac=$(echo "$tmp_mac" | cut -b 1-8 | sed -e 's/\:/-/g' | tr [:lower:] [:upper:])
elif [[ "$tmp_mac" =~ ^[0-9A-Fa-f]{12}$ ]]; then
    mac=$(echo "$tmp_mac" | cut -b 1-6 | tr [:lower:] [:upper:])
else
    help
fi

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

grep "$mac" "$txt"
