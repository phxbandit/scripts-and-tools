#!/bin/bash

# porn-scraper.sh - Or manga or whatever.

# http://gallery.example.com/1234/01.jpg

url='http://gallery.example.com'
beg='1000'
end='3000'
str='HTML document'

for i in $(seq "$beg" "$end"); do
    for j in $(seq 1 99); do
        printf -v k "%02d" "$j"
        pic="$i-$k.jpg"
        if [ ! -e "$pic" ]; then
            echo "Grabbing $url/$i/$k.jpg..."
            wget -q --user-agent='<INSERT USER AGENT STR HERE>' -O "$pic" "$url/$i/$k.jpg"
            res=$(file "$pic")
            if [[ "$res" =~ "$str" ]]; then
                rm "$pic"
                break
            fi
            sleep 1
        fi
    done
done
