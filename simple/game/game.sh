#!/bin/bash
declare -a arr=("Room 1" "Room 2" "Room 3" "Room 4" "Room 5" "Room 6" "Room 7" "Room 8" "Room 9")
display_func()
{
    tput cup 3 20 ; echo "           RPG Game"
    tput cup 4 20 ; echo "______________________________"
    tput cup 5 20 ; echo "| Room 1" 
    tput cup 5 30 ; echo "| Room 2" 
    tput cup 5 40 ; echo "| Room 3 |" 
    tput cup 6 20 ; echo "|____________________________|"
    tput cup 7 20 ; echo "| Room 4" 
    tput cup 7 30 ; echo "| Room 5" 
    tput cup 7 40 ; echo "| Room 6 |" 
    tput cup 8 20 ; echo "|____________________________|"
    tput cup 9 20 ; echo "| Room 7" 
    tput cup 9 30 ; echo "| Room 8" 
    tput cup 9 40 ; echo "| Room 9 |" 
    tput cup 10 20 ; echo "|____________________________|"
   
}

total_chances=3 ; remaining_chances=3; i=0 ; guess=`echo $((1 + $RANDOM % 10))`
while ((i<total_chances))
do
    tput clear;
    display_func  
    tput cup 12  25 ; read -p  "Enter Room no. to guess the particle: " choice
    while ((choice<1 || choice>9))
    do
        tput clear;
        display_func
        tput cup 12 25 ; read -p " Please enter valid room no from 1-9: " choice
    done
    if ((choice==guess))
    then
        tput cup 15 20 ; echo "Congratulations you won the game!"
        exit
    fi
    ((i=i+1))
done
tput cup 15 20 ; echo "You guess wrong room upto 3 time!. You lose the game!"