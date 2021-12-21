#!/bin/bash
export var=y
func()
{
    var=$1
    echo Directory: $var # It will print the name of the entered directory
    files=`ls -l $var | grep ^- | wc -l` # It will count the number of files in the given directory
    directories=`ls -l $var | grep ^d | wc -l` # # It will count the number of sub-directories in the given directory
    echo Files: $files Sub-directories: $directories # It will display the count of files and sub-directoires

}

# ---------------------------------------------------------------------
# -------------------------Main-Function-------------------------------
# ---------------------------------------------------------------------
while [ $var == "y" ]
do
    read -p "Please enter a directory: " var # It will take input the name of the directory
    func $var
    read -p "Do you wish to continue (y/n): " var # It will ask the user to continue or exit the program
done