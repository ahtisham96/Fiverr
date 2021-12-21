#!/bin/bash

# ncdu command

# Count the sizes of the files present in the current directory
ls -lc | grep "^[^d;]" | grep "^[^t;]" | awk '{print $5}' > temp_file.txt
size1=0
while IFS= read -r line; 
do
    ((size1=size1+line))
done < temp_file.txt

set -- "."/*
sleep "$1"

# Count the sizes of the files present in the current directory
ls -lc | grep "^[^d;]" | grep "^[^t;]" | awk '{print $5}' > temp_file.txt
size2=0
while IFS= read -r line; 
do
    ((size2=size2+line))
done < temp_file.txt

# Get the deleted files size
((remaining=size1-size2)) 
echo "removed files total size" $remaining "Bytes"

# Display the deleted files name
for pathname do
    if [ ! -e "$pathname" ]; then
        printf 'Deleted from given directory: %s\n' "${pathname##*/}"
    fi
done