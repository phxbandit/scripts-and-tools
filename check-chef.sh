#!/bin/bash

# check-chef.sh - Checks for new version of CyberChef

# Change this to where you store cyberchef.htm
cur="/dir/to/cyberchef.htm"

if [ "$(which wget)" = '' ]; then
    echo "wget not in PATH... exiting"
    exit 1
fi

if [ -f "$cur" ]; then
    wget -q https://gchq.github.io/CyberChef/cyberchef.htm -O "${cur}.new"
    diff_out=$(diff -q "$cur" "${cur}.new")

    if [[ "$diff_out" =~ 'differ' ]]; then
        cp "$cur" "${cur}.bak"
        mv "${cur}.new" "$cur"
    else
        rm "${cur}.new"
    fi
else
    wget -q https://gchq.github.io/CyberChef/cyberchef.htm -O "$cur"
fi
