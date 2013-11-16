#!/bin/bash

# bangrab.sh - Simple HTTP banner grabber
# by dual

# Source time and date functions
[ -e "$HOME/.iso8601" ] || {
    wget -q https://raw.github.com/getdual/scripts-n-tools/master/iso8601
    mv iso8601 $HOME/.iso8601
}
. "$HOME/.iso8601"

log=bangrab-$shTime.log

# Help
if [ $# -ne 1 ]; then
    echo "Usage: $0 <nmap-compatible IP range>"
    exit
fi

# Check for 80
nmap -n -p80 -oG .bangrabtemp1 $1

grep open .bangrabtemp1 | awk '{print $2}' > .bangrabtemp2

# Grab headers
for i in $(cat .bangrabtemp2); do
    echo $i >> $log
    echo "HEAD / HTTP/1.1" | nc -w 5 $i 80 2>&1 >> $log
    echo >> $log
done

rm -f .bangrabtemp*
