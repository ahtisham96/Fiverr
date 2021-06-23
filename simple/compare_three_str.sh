#!/bin/bash
declare -a arr
read -p "Enter 1st string: " arr[0]
read -p "Enter 2nd string: " arr[1]
read -p "Enter 3rd string: " arr[2]
#checking the equality of strings
if [[ "${arr[0]}" == "${arr[1]}" ]]; then
    if [[ "${arr[0]}" == "${arr[2]}" ]]
    then
        echo "Strings are equal."
    else
        echo "Strings are not equal."
    fi
else
    echo "Strings are not equal."
fi