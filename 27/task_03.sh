#!/bin/bash

# Display the childrens and grand childrens against $1 PID
pstree -p $1 | grep -o '([0-9]\+)' | grep -o '[0-9]\+' > results.txt ; cat results.txt | tail -n +2 