#!/bin/bash

# gallery-downloader-3.sh - by dual

while read i; do
	echo "Trying $i..."
	lynx -dump http://www.example.com/gallery$i/pic_1.jpg | grep "some text" > /dev/null
	if [ $? -eq 1 ]; then
		PIC=1
		while true; do
			wget http://www.example.com/gallery$i/pic_$PIC.jpg
			file pic_$PIC.jpg | grep HTML
			if [ $? -eq 0 ]; then
				rm pic_$PIC.jpg
				break
			fi
			mv pic_${PIC}.jpg ${i}_${PIC}.jpg
			PIC=$((PIC+1))
			sleep 1
		done
	fi
	sleep 1
done < code_list.txt
