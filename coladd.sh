#!/bin/bash

# coladd.sh - Sums a column from a file

help() {
    printf "\nUsage: ./coladd.sh <field number> <file>\n\n"
    exit 1
}

[ $# -eq 2 ] || help

IFS=$'\n'
field="$1"
file="$2"
total=0

for i in $(awk -v var="$field" '{print $'"var"'}' "$file"); do
    total=$(($total+$i))
done

echo "$total"
