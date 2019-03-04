#!/bin/bash

# pron-scraper.sh - Or manga or whatever
# http://www.example.com/pics/gallery123/pic_1.jpg

url='http://www.example.com/pics/gallery'
beg='1'
end='200'
str='HTML document'

for i in $(seq "$beg" "$end"); do
    printf -v j "%03d" "$i"
    for k in $(seq 1 99); do
        printf -v m "%02d" "$k"
        out="$j-$m.jpg"
        pic="$url${i}/pic_${k}.jpg"
        if [ ! -e "$out" ]; then
            echo "Grabbing $pic..."
            wget -q --user-agent='<INSERT USER AGENT STR HERE>' -O "$out" "$pic"
            res=$(file "$out")
            if [[ "$res" =~ "$str" ]]; then
                rm "$out"
                break
            fi
            sleep 1
        fi
    done
done
