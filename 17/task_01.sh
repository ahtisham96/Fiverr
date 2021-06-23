#!/bin/bash

ls /home > users_file.txt 

while IFS= read -r line; 
do
    test="/home/"$line
    echo $test
done < users_file.txt
