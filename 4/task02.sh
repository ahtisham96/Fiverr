#!/bin/bash

# Write the user input data into the file in which user want to enter data
my_write_func()
{
	
	read -p "Enter the name of the file:    " file1
	read -p "Enter data to insert in file and enter end to exit: " data
	while [ "$data" != "end" ]
	do
		echo "$data" >> $file1
		read -p "Enter data to insert in file and enter end to exit: " data
	done
}

# Print the contents of the file, against the entered filename by the user
my_print_func()
{
	read -p "Enter file name of the file which you want to print: " file1
	cat $file1
}

# Rename the name of the file against the new file name entered by the user
my_rename_func()
{
	read -p "Enter the name of the file which you want to rename : " file1
	read -p "Enter the new name of the file which you want to rename: " file2
	mv $file1 $file2
}

# Show the menue on the screen
show_menus_func() {
	#clear
	echo "--------------------------------------"	
	echo "          M A I N - M E N U           "
	echo "--------------------------------------"
	echo "1. Writing data into the file"
	echo "2. Printing the data of the file"
	echo "3. Renaming the name of the file"
	echo "4. Exiting from the bash script"
}

# Take input data from the user and perfrom action against the store data
read_options_func(){
	local option
	read -p "Enter choice [ 1 - 4]: " option
	case $option in
		1) my_write_func ;;
		2) my_print_func ;;
		3) my_rename_func ;;
		4) exit 0;;
		*) echo "Invalid Choice" && sleep 2
	esac
}
# ----------------------------------------------
# Ignore keyboard intruptable signals
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP
 
# -----------------------------------
# Program Entry Point
# ------------------------------------
while true
do
	show_menus_func
	read_options_func
done
