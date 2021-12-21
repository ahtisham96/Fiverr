#!/bin/bash

# Display the larges files against each entered path
while read line # Demand input from the user
do
    ls -lc $line | grep "^[^d;]" | grep "^[^t;]" | awk '{print $5}' > file.txt # Get all the files from each argument
    count=0 # set the size to 0 to check the maximum size against each entered directory from command line
    while IFS= read -r line; 
    do
        if ((line>count)) # It will check if the size is > then previous then it will update
        then
            ((count=line)) # It will update the counter
        fi 
    done < file.txt
    ls -lc $line | grep "^[^d;]" | grep "^[^t;]" | grep -w $count | awk '{print $9}' # It will get the max file name against each argument
    ((i=i+1)) # It will update the counter
done