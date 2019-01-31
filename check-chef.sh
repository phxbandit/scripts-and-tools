#!/bin/bash
# check-chef.sh - Checks for latest version of CyberChef

loc="$HOME/bin/cyberchef.htm"
rem='https://gchq.github.io/CyberChef/cyberchef.htm'

echo "Checking for latest CyberChef..."

if [ ! -f "$loc" ]; then
    echo "Retreiving cyberchef.htm..."
    wget -q "$rem" -O "$loc"
else
    loc_size=$(ls -l "$loc" | awk '{print $5}')
    rem_size=$(curl -sI "$rem" | grep Content-Length | awk -F': ' '{print $2}' | tr -d '\r')
    if [ "$loc_size" != "$rem_size" ]; then
        echo "Retreiving cyberchef.htm..."
        wget -q "$rem" -O "$loc"
    fi
fi

echo "Done"
