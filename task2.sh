#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

name="$1"
inode=$(ls -i "$name" | awk '{print $1}')
res=$(ls -lRi ~ | grep "^$inode")
echo "$res" > ./out2.txt