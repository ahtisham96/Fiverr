#!/bin/bash
declare -a arr
read -p "Enter 1st number: " arr[0]
read -p "Enter 2nd number: " arr[1]
read -p "Enter 3rd number: " arr[2]
largest=-999999
i=0
while((i<3))
do
    if((largest<${arr[$i]}))
    then
        largest=${arr[$i]}
    fi
    ((i=i+1))
done
echo "Largest number is: " $largest