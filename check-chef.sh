#!/bin/bash

# check-chef.sh - Checks for latest version of CyberChef

# Change $cur to where cyberchef.htm is stored
cur="/dir/to/cyberchef.htm"

if [ "$(which wget)" = '' ]; then
    echo "wget not in \$PATH... exiting"
    exit 1
fi

echo "Checking for latest CyberChef..."

if [ -f "$cur" ]; then
    wget -q https://gchq.github.io/CyberChef/cyberchef.htm -O "${cur}.new"
    diff_out=$(diff -q "$cur" "${cur}.new")

    if [[ "$diff_out" =~ 'differ' ]]; then
        echo "Updating CyberChef"
        cp "$cur" "${cur}.bak"
        mv "${cur}.new" "$cur"
    else
        rm "${cur}.new"
    fi
else
    echo "Installing CyberChef"
    wget -q https://gchq.github.io/CyberChef/cyberchef.htm -O "$cur"
fi

echo "Done"
