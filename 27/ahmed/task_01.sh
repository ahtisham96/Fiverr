#!/bin/bash

#ls /home > users_file.txt
awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534) print $1}' /etc/passwd  > users_file.txt

while IFS= read -r line; 
do
    getent passwd $line | cut -d: -f6
done < users_file.txt
