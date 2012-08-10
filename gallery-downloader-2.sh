#!/bin/bash

# gallery-downloader-2.sh - by dual

for i in {1..100}; do
	PIC=1
	while true; do
		wget --user-agent="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20100101 Firefox/14.0.1" http://www.example.com/gallery$i/pic_$PIC.jpg
		file pic_$PIC.jpg | grep HTML
		if [ $? -eq 0 ]; then
			rm pic_$PIC.jpg
			break
		fi
		mv pic_${PIC}.jpg ${i}_${PIC}.jpg
		PIC=$((PIC+1))
		sleep 2
	done
done
