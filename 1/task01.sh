#!/bin/bash
dir_name=$(basename $1)
dir_path=$(dirname $1)

#echo $dir_path
#echo $dir_name

declare -a fnames_array

if [ -d $1 ];then  # seaching if the user given directory exists
    #echo exist
    fnames=$(ls -1 $1 | tr '\n' ' ')  # getting the list of files separated by space
    
    for file in $fnames
    do  
       if [ -f "$1"/"$file" ]  # checking if $file is a file
       then
           if [ $(cat "$1"/"$file" | grep -ic "$2") != 0 ] # checking if the string pattern is found in the file or not
           then
               fnames_array+=("$file")  # adding elements to an array
               echo "$file"  # getting the name of the file
               wc -c "$1"/"$file" | cut -d" " -f1 # getting the file size in bytes
               grep "$2" "$1"/"$file" | wc -l  # getting the frequency of string pattern
           fi
       fi
    done
fi

> report.txt  # emptying the file
touch report.txt # creating a file
printf "\nFile Names\n"
for name in "${fnames_array[@]}"  # looping through fnames_array
do 
    echo $name
    echo $name >> report.txt  # appending data to report.txt
done

