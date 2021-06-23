#!/bin/bash

if [ "$1" == "" ] # Check if argument pass or not
then 
    echo "No Argument pass through command line" # Display the message no argument is pass
else # argument is pass, argument must be the name of the file
    sort $1 | uniq -i > result.txt # It will first sort the file then get the unique identities of the file and store then into the result.txt file
    echo " " # Printing empty line for just formatting
    echo "The Unique identities of the files are" # Display the prompt about the output 
    echo " " # Printing empty line for just formatting
    cat result.txt > $1 # It will apply changes to the file permanently
    cat result.txt # It will print the resulting file
fi