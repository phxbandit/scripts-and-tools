#!/bin/bash
# quick-scan.sh - quick scan script
if [ $# -ne 2 ]; then
    echo "usage: quick-scan <IPv4 range> <port>"
    exit 1
fi
ipv4="$1"
port="$2"
rand=$(echo $RANDOM)
tmp="tmp.${rand}"
nmap -n --open -p"$port" "$ipv4" -oG "$tmp"
echo
for i in $(grep open "$tmp" | grep -iv nmap | awk '{print $2}'); do
    if [[ "$port" -eq 80 || "$port" -eq 443 ]]; then
        echo -e "\n$i:$port :"
        curl -L -I -k --max-redirs 1 "$i"
        echo
    else
        echo -e "\n$i:$port :"
        echo "" | nc -q 1 "$i" "$port"
        echo
    fi
done
rm "$tmp"
