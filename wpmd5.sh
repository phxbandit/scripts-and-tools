#!/bin/bash

# wpmd5.sh - Compares wordpress.org md5s to installed wp md5s
#
# One-liner to generate MD5s
# for i in $(ls); do find "$i" -type f -not -path "*wp-content*" | xargs md5sum; done

IFS=$'\n'

# Define md5 file
wpmd5s='wordpress-md5s.txt'

# Help
usage() {
    echo
    echo "Usage: ./wpmd5.sh /absolute/path/to/wordpress"
    echo
    exit 1
}

# Get and check arg
[ $# = 1 ] || usage

# Check for md5sum
if [ "$(which md5sum)" = '' ]; then
    echo "ERROR: md5sum not found... exiting"
    exit 1
fi

# Verify wp exists
wp_path_tmp="$1"
wp_path=$(echo $wp_path_tmp | sed -e 's#/$##')
[ -f "$wp_path/wp-config.php" ] || usage

# Find wp version
installed_ver=$(grep 'wp_version =' "$wp_path/wp-includes/version.php" | awk -F"= '" '{print $2}' | sed -e "s/';$//")

# Compare md5s
for i in $(grep "$installed_ver/" "$wpmd5s"); do
    master_md5=$(echo "$i" | awk '{print $1}')
    master_file=$(echo "$i" | awk '{print $2}' | sed -e "s#$installed_ver/##")

    installed_md5=$(md5sum "$wp_path/$master_file" | awk '{print $1}')

    echo "Checking $wp_path/$master_file..."

    if [ "$master_md5" != "$installed_md5" ]; then
        echo
        echo "ALERT: MD5s for $master_file do not match"
        echo "Master file:    $master_md5"
        echo "Installed file: $installed_md5"
        echo
    fi
done
