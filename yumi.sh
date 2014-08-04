#!/bin/bash

# yumi.sh - Checks YUMI and tool versions
# by dual

yver="$HOME/.yumi.ver"
tools=(Yumi Clonezilla Dban GParted OfflineNT ophcrack7 ophcrackXP)

echo "yumi.sh - Checks YUMI and tool versions"
echo

# YUMI Multiboot USB Creator
Yumi=$(curl -s -S http://www.pendrivelinux.com/yumi-multiboot-usb-creator/ | grep MD5 | awk -F: '{print $2}' | awk -F"<" '{print $1}' | sed 's/^ //')
YumiDL="http://www.pendrivelinux.com/yumi-multiboot-usb-creator/"

# Clonezilla alternative stable (Ubuntu based)
Clonezilla=$(curl -s -S http://clonezilla.org/downloads/alternative/checksums.php | grep -E "clonezilla-live-.+-trusty-amd64.iso" | head -1 | awk '{print $1}')
ClonezillaDL="http://clonezilla.org/downloads.php"

# Darik's Boot And Nuke
Dban=$(curl -s -S http://sourceforge.net/projects/dban/files/dban/ | grep 'Download dban' | awk '{print $2}')
DbanDL="http://www.dban.org/download"

# GParted
GParted=$(curl -s -S http://free.nchc.org.tw/gparted-live/stable/CHECKSUMS.TXT | head -3 | tail -1 | awk '{print $1}')
GPartedDL="http://gparted.sourceforge.net/download.php"

# Offline NT Password & Registry Editor
OfflineNT=$(curl -s -S http://pogostick.net/~pnh/ntpasswd/main.html | grep "Latest release is" | awk '{print $4}')
OfflineNTDL="http://pogostick.net/~pnh/ntpasswd/bootdisk.html"

# ophcrack 7 LiveCD: cracks NT hashes (Windows Vista and 7)
ophcrack7=$(curl -s -S http://ophcrack.sourceforge.net/download.php?type=livecd | grep md5sum | head -2 | tail -1 | awk -F: '{print $2}' | sed 's/^ //' | cut -c 1-32)

# ophcrack XP LiveCD: cracks LM hashes (Windows XP and earlier)
ophcrackXP=$(curl -s -S http://ophcrack.sourceforge.net/download.php?type=livecd | grep md5sum | head -1 | awk -F: '{print $2}' | sed 's/^ //' | cut -c 1-32)
ophcrackDL="http://ophcrack.sourceforge.net/download.php"

if [ ! -e "$yver" ]; then
    echo "$yver not found. Creating..."
    echo
    for i in "${tools[@]}"; do
        ver=$(eval echo \$$i)
        if [ "$ver" = '' ]; then
            echo "WARN: Cannot retrieve version for $i."
        fi
        echo "$i:$ver" >> "$yver"
    done
    echo "Done."
else
    echo "Comparing versions..."
    echo
    for i in "${tools[@]}"; do
        new=$(echo "$(eval echo \$$i)")
        old=$(grep "$i" "$yver" | awk -F: '{print $2}')
        if [ "$new" = '' ]; then
            echo "WARN: Cannot retrieve version for $i."
            echo
            continue
        elif [ "$new" != "$old" ]; then
            echo "INFO: $i has a new version, which you can download at:"
            dload="DL"
            dload="$i$dload"
            eval echo \${$dload}
            read -p "Would you like to update the $i version in .yumi.ver [y/n]? " yon
            if [[ "$yon" = 'y' || "$yon" = 'Y' ]]; then
                echo "Updating $i's version in .yumi.ver..."
                sed -i "s/$old/$new/" "$yver"
            fi
            echo
        fi
    done
    echo "Done."
fi
