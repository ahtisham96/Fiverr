#!/bin/bash

# Count the sizes of the files present in the current directory
ls -lc | grep "^[^d;]" | grep "^[^t;]" | awk '{print $5}' > file_size.txt 
ls -lc | grep "^[^d;]" | grep "^[^t;]" | awk '{print $9}' > file_name.txt 
count=0 # intialize to size 0 bytes counting the size of current directory before sleep
# It will count the sizes of all the files exists in the current directory
while IFS= read -r line; 
do
    ((count=count+line))
done < file_size.txt

sleep "$1" # It will stop the session for $1 seconds

# Count the sizes of the files present in the current directory
ls -lc | grep "^[^d;]" | grep "^[^t;]" | awk '{print $5}' > file1_size.txt
ls -lc | grep "^[^d;]" | grep "^[^t;]" | awk '{print $9}' > file1_name.txt

count2=0 # intialize to size 0 bytes counting the size of current directory after sleep
# It will count the sizes of all the files exists in the current directory
while IFS= read -r line; 
do
    ((count2=count2+line))
done < file1_size.txt

((size=count-count2)) # Get the deleted files size
echo "Deleted files overall size" $size "in terms of Bytes" # Print the total size of deleted files on the screen
note=0
while IFS= read -r line; 
do
    while IFS= read -r line1; 
    do
        if [[ "$line" == "$line1" ]]
        then
            ((note=note+1))
        fi
    done < file1_name.txt
    if [[ "$note" == "0" ]]
    then
        echo $line    
    fi
    note=0
done < file_name.txt

