#!/bin/bash

# lastresort.sh - Reboot with DNS
# VVestron Phoronix
#
# echo -n '1' > /path/to/.lastresort
# crontab -e
# @hourly /path/to/lastresort.sh

file='/path/to/.lastresort'
bit=$(cat "$file")
xdom="nameservers.com"
xran=$(($(($RANDOM%10))%2))

if [ "$bit" -eq 0 ]; then
    exit
fi

if [ "$xran" -eq 0 ]; then
    xdns="ns1"
else
    xdns="ns2"
fi

xdig=$(dig -t txt blah.yourdomain.com @"$xdns.$xdom" +short | sed -e 's/"//g')

if [ "$xdig" = "true" ]; then
    echo -n '0' > "$file"
    /sbin/reboot
fi
