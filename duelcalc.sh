#!/bin/bash

# duelcalc.sh - Command line duel calculator
# by dual

# Source time and date functions
[ -e "$HOME/.iso8601" ] || {
    wget -q https://raw.github.com/getdual/scripts-n-tools/master/iso8601
    mv iso8601 $HOME/.iso8601
}
. "$HOME/.iso8601"

log=duel-$shTime.log

# Initialize life points
lp1=8000
lp2=8000

# Opening message
echo
echo "duelcalc.sh - Command line duel calculator"
echo

# Help message
help() {
    echo "  -h = This help message"
    echo "  -n = No logging"
    echo
    echo "  Subtract life points with '-', e.g. -1000"
    echo "  Add life points as normal, e.g. 500"
    echo "  Use zero for no damage, e.g. 0"
    echo
    exit 0
}

# Handle command line args
if [ "$1" == "-h" ]; then
    help
elif [ "$1" == "-n" ]; then
    chk=0
else
    chk=1
    echo "duelcalc.sh log - Duel began at $isoTime" >> $log
fi

# Do work
while :; do
    read -p "Player 1 DAMAGE: " dmg1
    read -p "Player 2 DAMAGE: " dmg2
    lp1=$(($lp1+$dmg1))
    lp2=$(($lp2+$dmg2))
    if [ $chk ]; then
        echo >> $log
        echo "$isoTime" >> $log
        read -p "Comment? (y or n) " yon
        if [[ "$yon" = "y" || "$yon" = "Y" ]]; then
            read -p "Please enter comment: " com
            echo "$com" >> $log
        fi
        echo "P1: $lp1" >> $log
        echo "P2: $lp2" >> $log
    fi
    echo
    if [ "$lp1" -lt "$lp2" ]; then
        echo -e "Player 1 LP: $(tput setaf 1)$lp1$(tput sgr0)"
        echo -e "Player 2 LP: $(tput setaf 2)$lp2$(tput sgr0)"
    elif [ "$lp1" -gt "$lp2" ]; then
        echo -e "Player 1 LP: $(tput setaf 2)$lp1$(tput sgr0)"
        echo -e "Player 2 LP: $(tput setaf 1)$lp2$(tput sgr0)"
    else
        echo -e "Player 1 LP: $(tput setaf 6)$lp1$(tput sgr0)"
        echo -e "Player 2 LP: $(tput setaf 6)$lp2$(tput sgr0)"
    fi
    echo

    if [ "$lp1" -le 0 ]; then
        echo "  == Player 2 WINS! =="
        echo
        break
    elif [ "$lp2" -le 0 ]; then
        echo "  == Player 1 WINS! =="
        echo
        break
    fi
done
