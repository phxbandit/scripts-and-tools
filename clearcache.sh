#!/bin/bash
# clearcache.sh -
if [ $# -ne 1 ]; then
    echo "usage: clearcache example.com"
    exit
fi
curl -XBAN http://"$1"
curl -XBAN http://www."$1"
curl -XBAN https://"$1"
curl -XBAN https://www."$1"
curl -XPURGE http://"$1"
curl -XPURGE http://www."$1"
curl -XPURGE https://"$1"
curl -XPURGE https://www."$1"