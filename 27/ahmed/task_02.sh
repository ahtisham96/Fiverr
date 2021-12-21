#!/bin/bash

# ncdu command

ls -lc | grep "^[^d;]" | grep "^[^t;]" | awk '{print $5}' > temp_file.txt
size1=0
while IFS= read -r line; 
do
    ((size1=size1+line))
done < temp_file.txt
sleep $1
ls -lc | grep "^[^d;]" | grep "^[^t;]" | awk '{print $5}' > temp_file.txt
size2=0
while IFS= read -r line; 
do
    ((size2=size2+line))
done < temp_file.txt
((remaining=size1-size2)) 
echo "removed files total size" $remaining

