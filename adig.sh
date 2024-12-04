#!/bin/bash

if [ $# -ne 1 ]; then
    echo "usage: adig example.com"
    exit 1
fi

echo -e "\ndig +short $1 @8.8.8.8"
ipaddr=$(dig +short "$1" @8.8.8.8)
echo "$ipaddr"

echo -e "\ndig +short -x $ipaddr"
dig +short -x "$ipaddr" | head -1

echo -e "\ndig +short -t ns $1"
dig -t ns "$1" +short
echo