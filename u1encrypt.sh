#!/bin/bash

# u1encrypt.sh - Encrypts file or directory for Ubuntu One cloud sync
# by dual
#
# Original script from:
# http://gnome-look.org/content/show.php/Ubuntu+One+Encrypt+Decrypt?content=142064

echo "u1encrypt.sh - Encrypts file or directory for Ubuntu One cloud"
echo

# Check for argument
if [ $# -ne 1 ]; then
	echo "$0 needs a file or directory as an argument. Exiting."
	exit 1
else
	target="$1"
fi

# Define and verify sync dir
ubuntu1="$HOME/Ubuntu One"

if [ ! -d "$ubuntu1" ]; then
	echo "$ubuntu1 directory not found. Exiting."
	exit 2
fi

# Verify openssl is installed
echo "Checking for openssl..."
type openssl || {
	echo "openssl not found. Exiting."
	exit 3
}

# Get and confirm encryption passphrase
echo
while [[ "$match" = "" ]]; do
	read -p "Please enter the encryption passphrase:   " pass
	read -p "Please confirm the encryption passphrase: " pass_conf
	if [[ "$pass" = "" ]]; then
		echo "Passphrase is empty. Exiting."
		exit 4
	elif [[ "$pass" = "$pass_conf" ]]; then
		match='1'
		continue
	else
		echo "Passphrases did not match."
	fi
done

# Encrypt file or dir
if [ -d "$target" ]; then
	dirname=$(echo $target | sed 's/\/$//g;s/.*\///g')
	echo
	echo "Encrypting $dirname..."
	tar czf $(basename $target).tar.gz $(basename $target)
	openssl des3 -salt -pass pass:$pass -in $(basename $target).tar.gz -out $ubuntu1/$(basename $target).tar.gz.des3
	rm $dirname.tar.gz
else
	filename=$(echo $target | sed 's/.*\///g')
	echo
	echo "Encrypting $filename..."
	openssl des3 -salt -pass pass:$pass -in $target -out $ubuntu1/$target.des3
fi

echo
echo "Done."
