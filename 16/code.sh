#!/bin/bash

sort -k 2,2 students2.dat # sort the file based on 2nd column 
echo " "
cat --number students2.dat | grep -w CS # Display the major CS records with line number
echo " "
cat --number students2.dat | grep -w Davis # Display the records their 1st and last name is Davis
echo " "
cat students2.dat | grep -w ECE | sort -r -k 4,4 # sort the contents of the file based on the CGPA in reverse order
echo " "
cut -f 2,4 students2.dat | sort -k 2,2 # Display only 2nd & 4th column of the file and sort it based on the CGPA in ascending order
echo " "
readlink -f csc252/*.cpp 2>/dev/null # get all the files have .cpp extension from my current directory
echo " "

# checking the existence of the file
if [ -e newFile.hard ]
then
    rm newFile.hard # Delete the file 
else
    ln students2.dat newFile.hard # Create the hard link
    ls -l -i students2.dat newFile.hard # long listing the properties of these files

    # We can also compare the attributes of these two files by using this command
    # diff newFile.hard students2.dat 
    # It will only shows the differences of these two files if exists otherwise it will shows nothing!

    # We can verify the hardlink of these two files by checking their inode numbers by using this command
    # ls -i newFile.hard students2.dat
    # The inode numbers for these two files must be same for the hardlink created files
fi
echo " "

# checking the existence of the file
if [ -e newFile.soft ]
then
    rm newFile.soft # Delete the file 
else
    ln -s students2.dat newFile.soft # Create the soft link 
    ls -l -i students2.dat newFile.soft # long listing the properties of these files

    # We can also compare the attributes of these two files by using this command
    # diff students2.dat newFile.soft
    # It will only shows the differences of these two files if exists otherwise it will shows nothing!

    # We can verify the softlink of these two files by checking their inode numbers by using this command
    # ls -i students2.dat newFile.soft
    # The inode numbers for these two files must be identical for the softlink created files
    
fi

echo " "
ls -i csc135/ | sort -k 1,1 # Display the inode and filename pair and sort them based on indoe numbers 