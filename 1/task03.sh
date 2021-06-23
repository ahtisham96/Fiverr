#!/bin/bash

touch new_users.txt  # creating new_users.txt file
> new_users.txt  # emptying the new_users.txt file


# user creation function
user_creation(){
    if [ $(grep -c "$1" /etc/passwd) == 1 ]  # condition for checking if a particular user exists in the system
        then
            echo $1 already exists
        elif [ $(grep -c "$1" /etc/passwd) == 0 ] # condition for checking if a particular user does not exists in the system
        then
            # echo user dont exists
            sudo useradd "$1" -m -s /bin/bash -c "$1"  # adding user to the system including the home directory
            echo "$1" >> new_users.txt
    fi
}


# user deletion function
user_deletion(){
    sudo userdel -r $1  # deleting the user and all its associated file including home directory
    printf "\n"
    echo "/etc/passwd file's contents"
    echo "==========================="
    cat /etc/passwd
    printf "\n"
    echo "/home directory contents"
    echo "========================"
    ls /home
}


if [ $# -eq 1 ] && [ -f $1 ] # checking if any argument has been passed to the script and if it is a file in the current directory
then
    # while loop: reading file line by line
    while read line
    do
        # calling user_creation function
        user_creation "$line"
    done <$1
    printf "\n"
    echo "/etc/passwd file's contents"
    echo "==========================="
    cat /etc/passwd
    printf "\n"
    echo "/home directory contents"
    echo "========================"
    ls /home
    
    
    printf "\n"
    read -p "Do you want to delete the newly created accounts ? " choice  # taking input from user
    
    # Checking if the user pressed y or Y or yes or YES or Yes
    if [ $choice == 'y' ] || [ $choice == 'Y' ] || [ $choice == 'yes' ] || [ $choice == 'YES' ] || [ $choice == 'Yes' ]
    then
        # while loop: reading file new_users.txt line by line
        while read line
        do
            # calling user_deletion function
            user_deletion "$line"
        done <new_users.txt
    else
        echo "No newly created user account deleted"
        exit
    fi
else
    echo "Please provide the filename containg usernames to be created!"
    exit  # exiting the script
fi

