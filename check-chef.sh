#!/bin/bash

# check-chef.sh - Checks for latest version of CyberChef

# Change $dir to where cyberchef.htm is stored
dir="/dir/to/cyberchef.htm"

if [ "$(which wget)" = '' ]; then
    echo "wget not in \$PATH... exiting"
    exit 1
fi

echo "Checking for latest CyberChef..."

if [ -f "$dir" ]; then
    wget -q https://gchq.github.io/CyberChef/cyberchef.htm -O "${dir}.new"
    diff_out=$(diff -q "$dir" "${dir}.new")

    if [[ "$diff_out" =~ 'differ' ]]; then
        echo "Updating CyberChef"
        cp "$dir" "${dir}.bak"
        mv "${dir}.new" "$dir"
    else
        rm "${dir}.new"
    fi
else
    echo "Installing CyberChef"
    wget -q https://gchq.github.io/CyberChef/cyberchef.htm -O "$dir"
fi

echo "Done"
