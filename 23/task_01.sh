#!/bin/bash
awk '{print NR  "     " $s}' $1 # It will print the line number against each line of the file on standard output
