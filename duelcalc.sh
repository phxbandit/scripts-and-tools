#!/bin/bash

# duelcalc.sh - Command line duel calculator
# by dual

# https://github.com/getdual/scripts-n-tools/blob/master/iso8601
. iso8601
LOG=duel-$SH_TIME.log

# Initialize life points
LP1=8000
LP2=8000

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
	CHK=0
else
	CHK=1
	echo "duelcalc.sh log - Duel begins at $TIME" >> $LOG
fi

# Do work
while (:); do
	read -p "Player 1 DAMAGE: " DMG1
	read -p "Player 2 DAMAGE: " DMG2
	echo
	LP1=$(($LP1+$DMG1))
	LP2=$(($LP2+$DMG2))
	if [ $CHK ]; then
		echo >> $LOG
		echo "$TIME" >> $LOG
		echo "P1: $LP1" >> $LOG
		echo "P2: $LP2" >> $LOG
	fi
	echo "Player 1 LP: $LP1"
	echo "Player 2 LP: $LP2"
	echo

	if [ "$LP1" -le 0 ]; then
		echo "  == Player 2 WINS! =="
		echo
		break
	elif [ "$LP2" -le 0 ]; then
		echo "  == Player 1 WINS! =="
		echo
		break
	fi
done
