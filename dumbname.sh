#!/bin/bash
# dumbname.sh - Get netbios names on local net
# by dual
. /var/root/bin/iso8601
for i in $(/var/root/bin/map | grep "scan report" | awk '{print $5}'); do
	nmblookup -A $i | tee -a dumbname-$SH_TIME.log
done
