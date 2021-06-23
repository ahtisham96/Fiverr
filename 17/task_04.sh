#!/bin/bash
declare -a arr
stop="STOP"

echo "Enter the path of the directory and STOP to quit the program: "
count=0
read  input
while [[ "$input" != "$stop" ]]
do
    arr[$count]=$input
    read  input
    ((count=count+1))
done

i=0
echo "The name of the entered directories are: "
while ((i<count))
do
    ls -lc ${arr[$i]} | grep "^[^d;]" | grep "^[^t;]" | awk '{print $5}' > temp.txt
    max=0
    while IFS= read -r line; 
    do
        if ((line>max))
        then
            ((max=line))
        fi
        
    done < temp.txt
    ls -lc ${arr[$i]} | grep "^[^d;]" | grep "^[^t;]" | grep -w $max | awk '{print $9}'
    ((i=i+1))
done
