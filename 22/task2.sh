#!/bin/bash
# sudo ls -R | grep .*.java$ | wc -l

for dir in $@
do
    if [ $(find $dir -maxdepth 1 -type f -ls | wc -l) -ge 20 ]; then
        echo $dir
    fi 
done
