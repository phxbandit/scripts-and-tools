#!/bin/bash

# bangrab.sh - Simple HTTP banner grabber
# by dual

. iso8601

log=bangrab-$shTime.log

if [ $# -ne 1 ]; then
	echo "Usage: $0 <nmap-compatible IP range>"
	exit
fi

nmap -n -p80 -oG .bangrabtemp1 $1

grep open .bangrabtemp1 | awk '{print $2}' > .bangrabtemp2

for i in $(cat .bangrabtemp2); do
	echo $i >> $log
	echo "HEAD / HTTP/1.1" | nc -w 5 $i 80 2>&1 >> $log
	echo >> $log
done

rm -f .bangrabtemp*
