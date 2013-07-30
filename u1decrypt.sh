#!/bin/bash

# u1decrypt.sh - Decrypts file or directory from Ubuntu One cloud
# by dual
#
# Original script from:
# http://gnome-look.org/content/show.php/Ubuntu+One+Encrypt+Decrypt?content=142064

echo "u1decrypt.sh - Decrypts encrypted file from Ubuntu One cloud to home directory"
echo

# Check for argument
if [ $# -ne 1 ]; then
        echo "$0 needs an encrypted file as an argument. Exiting."
        exit 1
else
        target="$1"
fi

# Define and verify sync dir (though not necessary)
ubuntu1="$HOME/Ubuntu One"

if [ ! -d "$ubuntu1" ]; then
        echo "$ubuntu1 directory not found. Exiting."
        exit 2
fi

# Verify openssl is installed
if [ "$(which openssl)" = '' ]; then
        echo "openssl not found. Exiting."
        exit 3
fi

# Get decryption passphrase
echo
read -p "Enter the decryption passphrase: " pass
if [[ "$pass" = "" ]]; then
	echo "A passphrase is required to decrypt data. Exiting..."
	exit 4
fi

# Copy and decrypt
if [[ "$target" =~ \.tar\.gz\.des3 ]]; then
	echo
	echo "Decrypting $target..."
	filename=$(basename $target | sed -r 's/\.des3$//')
	dirname=$(echo $filename | sed -r 's/\.tar\.gz$//')
	openssl des3 -d -salt -pass pass:$pass -in $target -out $HOME/$filename
	if [ -e $dirname ]; then
		echo
		echo "Directory $dirname exists."
		read -p "Do you want to overwrite $dirname? (y or n) " yon
		if [[ "$yon" = 'y' || "$yon" = 'Y' ]]; then
			tar xzf $HOME/$filename
			rm $HOME/$filename
		else
			echo
			echo "Exiting so as to not overwrite $dirname."
			rm $HOME/$filename
			exit 5
		fi
	else
		tar xzf $HOME/$filename
		rm $HOME/$filename
	fi
elif [[ "$target" =~ \.des3 ]]; then
	echo
	echo "Decrypting $target..."
	filename=$(basename $target | sed -r 's/\.des3$//')
	if [ -e "$HOME/$filename" ]; then
		openssl des3 -d -salt -pass pass:$pass -in $target -out $HOME/$filename-1
	else
		openssl des3 -d -salt -pass pass:$pass -in $target -out $HOME/$filename
	fi
else
	echo
	echo "$target is not encrypted file. Exiting."
	exit 6
fi

echo
echo "Done."
