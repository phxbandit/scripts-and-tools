#!/bin/bash
# VVestron Phoronix
kernpack=()
curkern=$(uname -r | awk -F'-generic' '{print $1}')
for i in $(dpkg -l | grep 'linux-' | awk '{print $2}' | egrep '[[:digit:]]\.[[:digit:]]\.[[:digit:]]' | grep -v "$curkern"); do
    kernpack+=($i)
done
printf "\nCurrent kernel: $(uname -r)\n\n"
apt purge "${kernpack[@]}"
