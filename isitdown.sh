#!/bin/bash
# isitdown.sh - Checks site at downforeveryoneorjustme.com

if [ $# -ne 1 ]; then
    echo "usage: isitdown example.com"
    exit 1
fi

lynx -dump "http://www.downforeveryoneorjustme.com/$1" | grep -i "is up" > /dev/null

if [ $? -eq 0 ]; then
    echo "$1 is up"
else
    echo "$1 is down"
fi
