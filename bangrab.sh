#!/bin/bash

# bangrab.sh - Simple HTTP banner grabber
# VVestron Phoronix

# Source time and date functions
[ -e "$HOME/.iso8601" ] || {
    wget -q https://raw.github.com/WSTNPHX/scripts-n-tools/master/iso8601
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
nmap -n -p80 -oG .bangrabtmp1 $1

grep open .bangrabtmp1 | awk '{print $2}' > .bangrabtmp2

# Grab headers
for i in $(cat .bangrabtmp2); do
    echo $i >> $log
    echo "HEAD / HTTP/1.0\r\n\r\n" | nc -i 1 $i 80 2>&1 >> $log
    echo >> $log
done

rm -f .bangrabtmp*
