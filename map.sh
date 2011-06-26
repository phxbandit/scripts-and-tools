#!/bin/bash
# map.sh - Quickly see what's up on the local net
# by dual
IP_RANGE=$(ifconfig | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | awk -F. '{print $1"."$2"."$3".1-254"}')
echo
echo "Scanning $IP_RANGE..."
nmap -sn -n $IP_RANGE
