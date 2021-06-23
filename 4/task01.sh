#!/bin/bash


direc_nm=$(basename $1)
direc_pth=$(dirname $1)


declare -a file_nm__array



if [ -d $1 ];then  # checking the entered directory exists or not
    file_name=$(ls -1 $1 | tr '\n' ' ')  # getting the list of files separated by space
    
    for f in $file_name
    do  
       if [ -f "$1"/"$f" ]  # checking it is a file or not
       then
           if [ $(cat "$1"/"$f" | grep -ic "$2") != 0 ] # checking if the string pattern is found in the file or not
           then
               file_nm_array+=("$f")  # add components into the files

               echo "$f"  # getting the name of the file

               wc -c "$1"/"$f" | cut -d" " -f1 # Take the size of the file in terms of bytes

               grep "$2" "$1"/"$f" | wc -l  # count the occurence of the word in the file

           fi
       fi
    done
fi

> result.txt  # clear the content of the file

touch result.txt # It will create the empty file if not exist

printf "\nName of the Files\n"

# It will search the results and append them into the result file 
for nm in "${file_nm_array[@]}"  
do 
    echo $nm
    echo $nm >> result.txt  
done

