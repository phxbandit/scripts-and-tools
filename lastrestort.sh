#!/bin/bash

# lastresort.sh - Reboot with DNS
# VVestron Phoronix

# crontab
# 0 * * * * /path/to/lastresort.sh

file='/path/to/.lastresort'
bit=$(cat "$file")
xdom="nameservers.com"
xran=$(($(($RANDOM%10))%2))

if [ "$bit" -eq 0 ]; then
    exit
fi

if [ "$xran" -eq 0 ]; then
    xdns="sub1"
else
    xdns="sub2"
fi

xdig=$(dig -t txt blah.yourdomain.com @"$xdns.$xdom" +short | sed -e 's/"//g')

if [ "$xdig" = "true" ]; then
    echo -n '0' > "$file"
    shutdown -r now
fi
