#!/bin/bash

# gallery-downloader.sh - by dual

array=( 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 )

for i in {100..1000}; do
	wget -O /dev/null http://galleries.example.com/$i/01.jpg 2>&1 | grep "image/jpeg" > /dev/null
	if [ $? -eq 0 ]; then
		for j in "${array[@]}"; do
			wget http://galleries.example.com/$i/$j.jpg
			mv ${j}.jpg ${i}_${j}.jpg
			sleep 2
		done
	fi
	sleep 3
done
