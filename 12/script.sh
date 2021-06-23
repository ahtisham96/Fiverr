#!/bin/bash

arg1=$1
arg2=$2


# show_menu function
show_menu()
{
    echo 
    echo "Select your desired option"
    echo "=========================="
    echo "1. -i: Name of the Package a FileName is part of"
    echo "2. -l: Components of a Package"
    echo "3. -d: Description of a Package"
    echo "4. -s: Stores Installed Packages in a File"
    echo "5. -h or -help: Application Help"
    echo "6. -g: Graphical Menu"
    echo "7. -m: Text Menu"
    echo "8. -v: Application Version & Author Name"
    echo "9. -o: Names of Installed Packages"
    echo "10. -f: Lines Containing Word from a File"
    echo 
    
    read -p "Enter your desired option from 1 to 10 : " option  # taking input from user and storing in the variable named "option"
    echo

    # switch-case statement for Text Menu
    case "$option" in
        1)
            read -p "Please enter the File Name : " input
            dpkg -S $(which -a "$input" | sed -n '1p')  # passing the path of binary exectable to dpkg -S
            ;;
	2)
	    read -p "Please enter the Package Name : " input
            dpkg -L "$input"
            ;;
	3)
	     read -p "Please enter the Package Name : " input
	     apt-cache show "$input"
            ;;
	4)
	     sudo apt list --installed | cut -d/ -f1 > packages_distribution_date.txt
	     echo "Installed packages saved to file named packeges_distribution_date.txt"
	     ;;
	5)
             if [ -f application_help.txt ]  # checks if the file application_help.txt exists in the current directory
	     then
                 less application_help.txt  # printing the contents of file page by page
             else
                 echo "Application Help File does NOT exist in the current directory"
             fi
             ;;  
	6)
	     ./GUI.sh  # Calling the script named "GUI.sh" that contains the GUI of this application
	     ;;
	7)
	     show_menu  # calling the show_menu function
	     ;;
	8)
	     echo "Version : 1"
	     echo "Author : $(whoami)"
	     ;;
	9)
	     read -p "Please enter the File Name : " FILE
	     if [ -f $FILE ];then
	         less $FILE
	     else
	         echo "Error, this file does not exist in the current directory!"
	     fi
	     ;;
	10)
	     read -p "Please enter your desired KEYWORD : " keyword
	     read -p "Please enter the File Name : " fname
	     if [ -f "$fname" ]
	     then
	         grep -o "$keyword" "$fname"  # printing all those lines from a file that contain your desired keyword
	     else
	         echo "Error, this option requires a file to search for the KEYWORD"
	     fi
	     ;;
	*)
	     echo "Error, invalid input. Please select a number from 1 to 10"
	     sleep 2
	     show_menu # calling the show_menu function
	     ;;
    esac
    
    # This while loop will keep on running until you press ctrl+c or when you are asked to perform another operation, and you input "no"
    while true
    do
        echo ""
        read -p "Do you want to perform another operation [yes/no]? " choice

        case "$choice" in
            YES|yes|YEs|Yes|yES|yeS) # checking if uer pressed any of them
                show_menu # calling the search function
                ;;
            NO|no|No|nO)  # checking if user pressed any of them
                exit  # exiting the script
                ;;
        esac
    done
}


# This code runs first when you run the script

if [ $# -eq 0 ]  # checks if no arguments have been passed to the script
then
    echo "Error. No argument passed to the script"
else
    # switch-case statement for directly running the application without GUI or Text Menu
    case "$arg1" in
        -i)
            if [ -z "$arg2" ]  # checks if the arg2 variable is emtpy
            then
                echo "Error, File Name not entered"
            else
                dpkg -S $(which -a "$arg2" | sed -n '2p')
            fi
            ;;
	 -l)
	    if [ -z "$arg2" ]
            then
                echo "Error, Package Name not entered"
            else
                dpkg -L "$arg2"
            fi
            ;;
	 -d)
	     if [ -z "$arg2" ]
            then
                echo "Error, Package Name not entered"
            else
	         apt-cache show "$arg2"
	    fi
            ;;
	 -s)
	     apt list --installed | cut -d/ -f1 > packages_distribution_date.txt
	     echo "Installed packages saved to file named packeges_distribution_date.txt"
	     ;;
	 -h|-help)
	     if [ -f application_help.txt ]
	     then
                 less application_help.txt
             else
                 echo "Application Help  File does NOT exist in the current directory"
             fi
             ;;  
	 -g)
	     ./GUI.sh  # GUI.sh is the script that contains the GUI of this application
	     ;;
	 -m)
	     show_menu  # calling the text menu for this application
	     ;;
	 -v)
	     echo "Version : 1"
	     echo "Author : $(whoami)"
	     ;;
	 -o)
	     read -p "Please enter the File Name : " FILE
	     if [ -f $FILE ];then
	         less $FILE
	     else
	         echo "Error, this file does not exist in the current directory!"
	     fi
	     ;;
	 -f)
	     read -p "Please enter your desired KEYWORD : " keyword
	     read -p "Please enter the File Name : " fname
	     if [ -f "$fname" ]
	     then
	         grep -o "$keyword" "$fname"  # printing all those lines from a file that contain your desired KEYWORD
	     else
	         echo "Error, this option requires a file to search for the KEYWORD"
	     fi
	     ;;
	  *)
	     echo "Error, invalid input"
	     echo
	     ;;
	esac
fi

