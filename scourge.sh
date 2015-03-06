#!/bin/bash

# scourge.sh - Scrapes popular plugins from wordpress.org
# WSTN

IFS=$'\n'

# Define variables
no_of_plugins='2' # Number of plugins equals $no_of_plugins * 30
log_time=$(date +'%Y-%m-%d-%H%M')
scourge_log="scourge-$log_time.log"
get_old=''
plugin_dir="$HOME/database/files/CMS/wordpress-plugins"
tmp_dir="/tmp/$(echo $RANDOM | md5sum | awk '{print $1}')"

# Help
usage() {
    echo
    echo "scourge.sh - Scrapes popular plugins from wordpress.org"
    echo
    echo "Usage: ./scourge.sh [-ho]"
    echo "   -h: Show this help"
    echo "   -o: Download old versions of plugins"
    echo
    exit 1
}

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
        [ -d "$unzip_dir1" ] || (
            echo "Downloading $base_name1 $ver_name1"
            mkdir -p "$unzip_dir1"
            wget -q --no-check-certificate --no-clobber -O "$tmp_dir/$zip_name1" "$download1_link"
            unzip -q -d "$unzip_dir1" "$tmp_dir/$zip_name1" && rm "$tmp_dir/$zip_name1"
            echo "$base_name1,$ver_name1,$download1_link" >> "$scourge_log"
        )

        # Check to download old versions
        if [ "$get_old" ]; then
            old_vers "$base_name1"
        fi

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
            [ -d "$unzip_dir" ] || (
                echo "Downloading $base_name $ver_name"
                mkdir -p "$unzip_dir"
                wget -q --no-check-certificate --no-clobber -O "$tmp_dir/$zip_name" "$downloads_link"
                unzip -q -d "$unzip_dir" "$tmp_dir/$zip_name" && rm "$tmp_dir/$zip_name"
                echo "$base_name,$ver_name,$downloads_link" >> "$scourge_log"
            )

            # Check to download old versions
            if [ "$get_old" ]; then
                old_vers "$base_name"
            fi

            sleep 1
        done
    done
}

# Download old versions of plugin
old_vers() {
    base_name_old="$1"
    for i in $(curl -s -S "https://wordpress.org/plugins/$base_name_old/developers/" | grep -P '<li>.*downloadUrl' | grep -v 'Development Version' | awk -F"</a>" '{print $1}'); do
        download_old=$(echo "$i" | awk -F"href='" '{print $2}' | awk -F"' rel" '{print $1}')
        zip_name_old=$(echo "$i" | awk -F"/" '{print $5}' | awk -F"' rel" '{print $1}')
        ver_name_old=$(echo "$i" | awk -F'nofollow">' '{print $2}')

        unzip_dir_old="$plugin_dir/$base_name_old/$ver_name_old"
        [ -d "$unzip_dir_old" ] || (
            echo "Downloading $base_name_old $ver_name_old"
            mkdir -p "$unzip_dir_old"
            wget -q --no-check-certificate --no-clobber -O "$tmp_dir/$zip_name_old" "$download_old"
            unzip -q -d "$unzip_dir_old" "$tmp_dir/$zip_name_old" && rm "$tmp_dir/$zip_name_old"
            echo "$base_name_old,$ver_name_old,$download_old" >> "$scourge_log"
        )

        sleep 1
    done
}

# Check for args
if [ $# -eq 1 ]; then
    if [[ "$1" =~ '-h' ]]; then
        usage
    elif [[ "$1" =~ '-o' ]]; then
        get_old='1'
    else
        usage
    fi
fi

echo
echo "Starting scourge.sh ( SECCON )"
echo

checkDirs
page1
#pages

rm -rf "$tmp_dir"
echo
echo "Complete"
echo
