#!/bin/bash
# now.sh - map and scan local net
# by dual
. /var/root/bin/iso8601
for i in $(/var/root/bin/map | grep "scan report" | awk '{print $5}'); do
	nmap -sC -F $i | tee -a now-$SH_TIME.log
done
