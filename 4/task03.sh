#!/bin/bash


# create new file and clear the contents of the file if anything exists in the file already
touch user.txt  
> user.txt  


# This function will create the new user in the system if it already not exists
create_user()
{

    if [ $(grep -c "$1" /etc/passwd) == 1 ] 
        then
            echo $1 This user already exists in-the system
        elif [ $(grep -c "$1" /etc/passwd) == 0 ] 
        then
            sudo useradd "$1" -m -s /bin/bash -c "$1" 
            echo "$1" >> user.txt
    fi

}


# This function will delete the existing user and all its data from the system if exists
delete_user()
{

    sudo userdel -r $1  
    printf "\n"
    echo "Print the contents of the following file /etc/passwd"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    cat /etc/passwd
    printf "\n"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    printf "\n"
    echo "Print the contents of the home directory /home"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    ls /home
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

}

# test wheter any arg passed to it or also check if is a file or not
if [ $# -eq 1 ] && [ -f $1 ] 
then
    while read line
    do
        create_user "$line"
    done <$1
    printf "\n"
    echo "Print the contents of the following file /etc/passwd"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    cat /etc/passwd
    printf "\n"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Print the contents of the home directory /home"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    ls /home
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    printf "\n"

    # Take input from the user against to delete the newly created account or not
    read -p "Are you realy want to delete the fresh created account ? " option  
    
    # Validate the choice of the user to delete account or not
    if [ $option == 'y' ] || [ $option == 'Y' ] || [ $option == 'yes' ] || [ $option == 'YES' ] || [ $option == 'Yes' ]
    then
        while read line
        do
            delete_user "$line"
        done < user.txt
    else
        echo "No! account deleted that created in newly"
        exit
    fi
else
    echo "Please enters the file name wchich contains info of the created users"
    exit  # Terminate the script now!
fi

