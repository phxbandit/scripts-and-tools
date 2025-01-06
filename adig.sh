#!/bin/bash

if [ $# -ne 1 ]; then
    echo "usage: adig example.com"
    exit 1
fi

echo -e "\ndig +short @8.8.8.8 $1"
ipaddr=$(dig +short @8.8.8.8 "$1")
echo "$ipaddr"

echo -e "\ndig +short -x $ipaddr"
dig +short -x "$ipaddr" | head -1

echo -e "\ndig +short -t ns $1"
dig -t ns "$1" +short
echo

echo -e "Showing redirect with wget...\n"
wget -O /dev/null "$1"