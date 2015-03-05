#!/bin/bash

# scourge.sh - Scrapes popular plugins from wordpress.org
# WSTN

IFS=$'\n'

# Define vars
no_of_plugins='2' # Number of plugins equals $no_of_plugins * 30
log_time=$(date +'%Y-%m-%d-%H%M')
plugin_log="wp-plugins-$log_time.log"
plugin_dir="$HOME/database/files/CMS/wordpress-plugins"
tmp_dir='/tmp/dropzone'

# Check for working dirs
checkDirs() {
    [ -d "$plugin_dir" ] || ( mkdir -p "$plugin_dir" )
    [ -d "$tmp_dir" ] || ( mkdir -p "$tmp_dir" )
}

# Grab first page of plugins
page1() {
    for i in $(curl -s -S "https://wordpress.org/plugins/browse/popular/" | grep '<h4>' | awk -F'"' '{print $2}'); do
        page1_link=$(curl -s -S "$i" | grep 'downloads.wordpress.org' | awk -F"href='" '{print $2}' | awk -F"<" '{print $1}')
        download1_link=$(echo "$page1_link" | awk -F"'>" '{print $1}')

        # Extract names for dir structure
        zip_name1=$(echo "$page1_link" | awk -F"/" '{print $5}' | awk -F"'" '{print $1}')
        ver_name1=$(echo "$page1_link" | awk -F"'>Download Version " '{print $2}' | sed -e 's#</a>\s*</p>##')
        base_name1=$(echo "$zip_name1" | awk -F"." '{print $1}')

        # Create unzip dir, download and unzip
        unzip_dir1="$plugin_dir/$base_name1/$ver_name1"
        mkdir -p "$unzip_dir1"
        wget --no-check-certificate --no-clobber -O "$tmp_dir/$zip_name1" "$download1_link"
        unzip -d "$unzip_dir1" "$tmp_dir/$zip_name1" && rm "$tmp_dir/$zip_name1"

        echo "$base_name1,$ver_name1,$download1_link" >> "$plugin_log"
        sleep 1
    done
}

# Grab X pages of plugins
pages() {
    for j in $(seq 2 "$no_of_plugins"); do
        for k in $(curl -s -S "https://wordpress.org/plugins/browse/popular/page/$j/" | grep '<h4>' | awk -F'"' '{print $2}'); do
            pages_link=$(curl -s -S "$k" | grep 'downloads.wordpress.org' | awk -F"href='" '{print $2}' | awk -F"<" '{print $1}')
            downloads_link=$(echo "$pages_link" | awk -F"'>" '{print $1}')

            # Extract names for dir structure
            zip_name=$(echo "$pages_link" | awk -F"/" '{print $5}' | awk -F"'" '{print $1}')
            ver_name=$(echo "$pages_link" | awk -F"'>Download Version " '{print $2}' | sed -e 's#</a>\s*</p>##')
            base_name=$(echo "$zip_name" | awk -F"." '{print $1}')

            # Create unzip dir, download and unzip
            unzip_dir="$plugin_dir/$base_name/$ver_name"
            mkdir -p "$unzip_dir"
            wget --no-check-certificate --no-clobber -O "$tmp_dir/$zip_name" "$downloads_link"
            unzip -d "$unzip_dir" "$tmp_dir/$zip_name" && rm "$tmp_dir/$zip_name"

            echo "$base_name,$ver_name,$downloads_link" >> "$plugin_log"
            sleep 1
        done
    done
}

checkDirs
page1
#pages
