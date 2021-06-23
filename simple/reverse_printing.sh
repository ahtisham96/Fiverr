#!/bin/bash
arr=(1 2 3 4 5 6 7 8 9 10)
i=9
while((i>=0))
do
     echo "${arr[$i]}"
    ((i=i-1))
done