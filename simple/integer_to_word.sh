#!/bin/bash
declare -a arr
declare -a arr2=(one two three)
read -p "Enter 1st number: " arr[0]
read -p "Enter 2nd number: " arr[1]
read -p "Enter 3rd number: " arr[2]
integer_to_word_func() 
{
    case $1 in
    
    1)
        echo "one"
        ;;

    2)
        echo "Two"
        ;;

    3)
        echo "Three"
        ;;

    *)
        echo "This Number: $1 not belong to 1-3"
        ;;
    esac
}
i=0
while((i<3))
do
    integer_to_word_func ${arr[$i]}
    ((i=i+1))
done
