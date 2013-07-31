#!/bin/bash

# u1encrypt.sh - Encrypts file or directory for Ubuntu One cloud sync
# by dual
#
# Original script from:
# http://gnome-look.org/content/show.php/Ubuntu+One+Encrypt+Decrypt?content=142064

echo "u1encrypt.sh - Encrypts file or directory for Ubuntu One cloud"

# Check for argument
if [ $# -ne 1 ]; then
	echo "u1encrypt.sh needs a file or directory as an argument... exiting"
	exit 1
else
	target="$1"
fi

# Define and verify sync dir
ubuntu1="$HOME/Ubuntu One"

if [ ! -d "$ubuntu1" ]; then
	echo "$ubuntu1 directory not found... exiting"
	exit 2
fi

# Verify openssl is installed
if [ "$(which openssl)" = '' ]; then
	echo "openssl not found... exiting"
	exit 3
fi

# Get and confirm encryption passphrase
echo
while [[ "$match" = "" ]]; do
	read -p "Please enter the encryption passphrase:   " pass
	read -p "Please confirm the encryption passphrase: " pass_conf
	if [[ "$pass" = "" ]]; then
		echo "Passphrase is empty... exiting"
		exit 4
	elif [[ "$pass" = "$pass_conf" ]]; then
		match='1'
		continue
	else
		echo "Passphrases did not match"
	fi
done

# Encrypt file or dir
if [ -d "$target" ]; then
	dirname=$(basename "$target")
	echo
	echo "Encrypting $dirname..."
	tar czf "$dirname.tar.gz" "$dirname"
	openssl des3 -salt -pass pass:"$pass" -in "$dirname.tar.gz" -out "$ubuntu1/$dirname.tar.gz.des3"
	rm "$dirname.tar.gz"
else
	filename=$(echo "$target" | sed 's/.*\///g')
	echo
	echo "Encrypting $filename..."
	openssl des3 -salt -pass pass:"$pass" -in "$target" -out "$ubuntu1/$target.des3"
fi

echo
echo "Done"
