#!/bin/bash

# lastresort.sh - Reboot with DNS
# crontab
# 0 * * * * /path/to/lastresort.sh

xdom="nameservers.com"
xran=$(($(($RANDOM%10))%2))

if [ "$xran" -eq 0 ]; then
    xdns="sub1"
else
    xdns="sub2"
fi

xdig=$(dig -t txt blah.yourdomain.com @"$xdns.$xdom" +short | sed -e 's/"//g')

if [ "$xdig" = "true" ]; then
    shutdown -r now
fi
