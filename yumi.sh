#!/bin/bash

# yumi.sh - Checks YUMI and tool versions
# by dual

ver=.yumi.ver
tools=(Yumi Clonezilla Dban Deft GParted ophcrack7 ophcrackXP)

echo "yumi.sh - Checks YUMI and tool versions"
echo

# YUMI Multiboot USB Creator
Yumi=$(curl -s -S http://www.pendrivelinux.com/yumi-multiboot-usb-creator/ | grep MD5 | awk -F: '{print $2}' | awk -F"<" '{print $1}' | sed 's/^ //')

# Clonezilla alternative stable (Ubuntu based)
Clonezilla=$(curl -s -S http://clonezilla.org/downloads/alternative/checksums.php | grep -E "clonezilla-live-.+-raring-amd64.iso" | head -1 | awk '{print $1}')

# Darik's Boot And Nuke Beta
Dban=$(curl -s -S http://sourceforge.net/api/file/index/project-id/61951/mtime/desc/limit/20/rss | grep -E "CDATA\[\/dban\/dban-" | head -1 | awk -F"-" '{print $2}' | cut -c 1-5)

# DEFT Linux Computer Forensics Live CD (latest stable version)
Deft=$(curl -s -S http://linuxfreedom.com/deft/md5.txt | grep -v beta | grep deft | tail -1 | awk '{print $1}')

# GParted i486
GParted=$(curl -s -S http://free.nchc.org.tw/gparted-live/stable/CHECKSUMS.TXT | head -3 | tail -1 | awk '{print $1}')

# ophcrack 7 LiveCD: cracks NT hashes (Windows Vista and 7)
ophcrack7=$(curl -s -S http://ophcrack.sourceforge.net/download.php?type=livecd | grep md5sum | head -2 | tail -1 | awk -F: '{print $2}' | sed 's/^ //' | cut -c 1-32)

# ophcrack XP LiveCD: cracks LM hashes (Windows XP and earlier)
ophcrackXP=$(curl -s -S http://ophcrack.sourceforge.net/download.php?type=livecd | grep md5sum | head -1 | awk -F: '{print $2}' | sed 's/^ //' | cut -c 1-32)

if [ ! -e $ver ]; then
	echo "No .yumi.ver found. Creating..."
	for i in "${tools[@]}"; do
		echo "$i:$(eval echo \$$i)" >> $ver
	done
	echo "Done."
else
	echo "Comparing versions..."
	for i in "${tools[@]}"; do
		new=$(echo "$(eval echo \$$i)")
		old=$(grep $i $ver | awk -F: '{print $2}')
		if [ "$new" != "$old" ]; then
			echo "$i has a new version."
			read -p "Would you like to update $i in .yumi.ver to the latest version? " yon
			if [[ "$yon" -eq 'y' || "$yon" -eq 'Y' ]]; then
				echo "Updating $i's version in .yumi.ver..."
				sed -i "s/$old/$new/" $ver
			fi
		fi
	done
	echo "Done."
fi
