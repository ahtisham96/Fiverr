#!/bin/bash

# Fucntion to write the contents into the file
my_write()
{
	#read -p "Press [Enter] key to continue..." fackEnterKey
	read -p "Enter the name of the file:    " file_name
	read -p "Enter data to insert in file and enter end to exit: " content
	while [ "$content" != "end" ]
	do
		echo "$content" >> $file_name
		read -p "Enter data to insert in file and enter end to exit: " content
	done
	sleep 2;
}

# Function to print the contents of the file
my_print()
{
	#read -p "Press [Enter] key to continue..." fackEnterKey
	read -p "Enter the name of the file: " file_name
	cat $file_name
	sleep 2

}

# Function to rename the name of the file
my_rename()
{
	read -p "Enter the old file name: " old_file_name
	read -p "Enter the new file name: " new_file_name
	mv $old_file_name $new_file_name
	sleep 2
}

# function to display menus
show_menus() {
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Writing to a file"
	echo "2. Printing the contents of the file"
	echo "3. Rename the name of the file"
	echo "4. Exit"
}

# read input from the keyboard and take a action
# invoke the write() when the user select 1 from the menu option.
# invoke the print() when the user select 2 from the menu option.
# invoke the rename() when the user select 3 from the menu option.
# Exit when user the user select 4 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 4]: " choice
	case $choice in
		1) my_write ;;
		2) my_print ;;
		3) my_rename ;;
		4) exit 0;;
		*) echo "Invalid Choice" && sleep 2
	esac
}
# ----------------------------------------------
# Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP
 
# -----------------------------------
# Main Function
# ------------------------------------
while true
do
 
	show_menus
	read_options
done
