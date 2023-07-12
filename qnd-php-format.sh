#!/bin/bash

# qnd-php-format.sh - Strips comments, then formats PHP

# From my limited testing of PHP malware, I found no difference between strip
# then format vs. format then strip. Plus, strip then format preserves the
# original PHP file wihtout extra steps.

# References
# https://github.com/PHP-CS-Fixer/PHP-CS-Fixer
# https://www.php-fig.org/psr/psr-2/

[ $# -eq 1 ] || {
    echo "Usage: qnd-php-format.sh <php file>"
    exit 1
}

# Make sure php-cs-fixer exists and is in the path
if [ "$(which php-cs-fixer)" = '' ]; then
    echo "php-cs-fixer not found in path... exiting"
    exit 1
fi

# Check for strip-comments.php
[ -f strip-comments.php ] || {
    echo "strip-comments.php not found... getting"
    wget --no-check-certificate https://raw.githubusercontent.com/phxbandit/scripts-and-tools/master/strip-comments.php
}

# Random name
rand_name="qndformat-$RANDOM.php"

php strip-comments.php "$1" > "$rand_name"

php-cs-fixer fix "$rand_name" --rules=@PSR2