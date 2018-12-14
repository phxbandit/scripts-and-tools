#!/bin/bash
if [ $# -ne 1 ]; then
    echo "usage: json-voorhees file" && exit 1
fi
cat "$1" | python -m json.tool
