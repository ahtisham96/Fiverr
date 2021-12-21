#!/bin/bash

# Display the larges files against each entered path
for var in "$@"
do
    ls -lc $var | grep "^[^d;]" | grep "^[^t;]" | awk '{print $5}' > temp.txt
    max=0
    while IFS= read -r line; 
    do
        if ((line>max))
        then
            ((max=line))
        fi
        
    done < temp.txt
    ls -lc $var | grep "^[^d;]" | grep "^[^t;]" | grep -w $max | awk '{print $9}'
    ((i=i+1))
done