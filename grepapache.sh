#!/bin/bash

# grepapache.sh

IFS=$'\n'

[[ $# -eq 1 ]] || { echo 'ERROR: Missing grep argument'; exit; }

dir='/var/log/apache2'
tmp="/tmp/grepapache-$RANDOM"

rm -f /tmp/grepapache-*

for i in "$dir"/access.log "$dir"/access.log.*; do
    zgrep "$1" "$i" >> "$tmp"
done

cat "$tmp"
