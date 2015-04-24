#!/bin/bash

# scourge-themes.sh - Scrapes popular themes from wordpress.org
# Version 2015-04-24

IFS=$'\n'

# Define variables
theme_dir="$HOME/dropzone/wordpress-themes"
tmp_dir="/tmp/$(echo $RANDOM | md5sum | awk '{print $1}')"
log_time=$(date +'%Y-%m-%d-%H%M')
scourge_themes_log="scourge-themes-$log_time.log"

# Check for working dirs
checkDirs() {
    [ -d "$theme_dir" ] || ( mkdir -p "$theme_dir" )
    [ -d "$tmp_dir" ] || ( mkdir -p "$tmp_dir" )
}

first24() {
    for i in $(curl -s -S https://wordpress.org/themes/browse/popular/ | grep 'downloads.wordpress.org/theme' | grep -v slug | awk -F'"' '{print $4}'); do
        # Extract names for dir structure
        zip_name=$(echo "$i" | awk -F'/' '{print $5}')
        base_name=$(echo "$zip_name" | awk -F"." '{print $1}')
        ver_name=$(echo "$zip_name" | perl -pe 's/^\w+\.?//' | sed -e 's/\.zip$//')

        # Create unzip dir, download and unzip
        unzip_dir="$theme_dir/$base_name/$ver_name"
        [[ -d "$unzip_dir" ]] || (
            echo "Downloading $base_name $ver_name"
            mkdir -p "$unzip_dir"
            wget -q --no-check-certificate --no-clobber -O "$tmp_dir/$zip_name" "$i"
            unzip -q -d "$unzip_dir" "$tmp_dir/$zip_name" && rm "$tmp_dir/$zip_name"
            echo "$base_name,$ver_name,$i" >> "$scourge_themes_log"
        )
    done
}

checkDirs
first24

rmdir "$tmp_dir"
echo
echo "Complete"
echo
