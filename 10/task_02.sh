#!/bin/bash

store_results()
{
    echo "--------------------------------------"
    read -p "To store the results, please enter directory name alongwith its location? " dir_location
    
    mkdir -p "$dir_location"  # creating directory at the given location if it does not exist already
    
    read -p "Please enter the file name to store the results? " file_name
    
    if [ -f "$dir_location/$file_name" ]  # this condition checks if the file exists at the given location
    then
        # -a with tee appends the data to the already existing file. column command puts data in a nicely formatted columnar format
        cat $1 | column -t -s "," | grep "suspicious" | tee -a "$dir_location/$file_name"  # storing/printing only the suspicious results
    else
        cat $1 | column -t -s "," | grep "suspicious" | tee "$dir_location/$file_name" # creating the file cuz it doesn't exist already
    fi
    
        
    # condition to check if the user is searching based "Packets" column or "Bytes" Column
    if((tot_columns==1 && column_arr[0]==8 || tot_columns==1 && column_arr[0]==9))
    then
        echo " "  # prints a blank line
        echo "Total Records Found : $(cat $1 | grep "suspicious" | wc -l)"  # counting & printing the total records found
    # condition to check if the user is searching based on both "Packets" Column as well as "Bytes" Column
    elif((tot_columns==2 && column_arr[0]==8 && column_arr[1]==9 || tot_columns==2 && column_arr[0]==9 && column_arr[1]==8))
    then
        echo ""
        echo "Total Records Found : $(cat $1 | grep "suspicious" | wc -l)"  # counting & printing the total records found
    fi
}


select_file()
{
    echo ""
    echo "Possible Files to Search into"
    echo "-----------------------------"
    echo "1. serv_acc_log_03042020.csv"
    echo "2. serv_acc_log_12032020.csv"
    echo "3. serv_acc_log_14032020.csv"
    echo "4. serv_acc_log_17032020.csv"
    echo "5. serv_acc_log_21032020.csv"
    read -p "Enter file number [1-5] in which you want to search : " input
    while((input < 1 || input > 5))  # condition to check if the user inputs VALID number
    do
        read -p "Please enter the VALID choice [1-5] : " input
    done
    
    echo ""
    
    # switch-case to decide which file has been selected by the user for searching
    case "$input" in
        1)
             filename_srch="serv_acc_log_03042020.csv"
             echo "You Selected $filename_srch"
             ;;
        2)  
            filename_srch="serv_acc_log_12032020.csv"
            echo "You Selected $filename_srch"
            ;;
        3)  
            filename_srch="serv_acc_log_14032020.csv"
            echo "You Selected $filename_srch"
            ;;
        4)  
            filename_srch="serv_acc_log_17032020.csv"
            echo "You Selected $filename_srch"
            ;;
        5)  
            filename_srch="serv_acc_log_21032020.csv"
            echo "You Selected $filename_srch"
            ;;
    esac
}

select_search_method()
{
    echo ""
    echo "How would you like to search?"
    echo "-----------------------------"
    echo "1. Values equal to $1"
    echo "2. Values less than $1"
    echo "3. Values greater than $1"
    echo "4. Values not equal to $1"
   
    read -p "Your Choice [1-4] : " input
    while((input < 1 || input > 4))  # condition to check if the user inputs VALID number
    do
        read -p "Please enter the VALID choice [1-4] : " input
    done
    
    echo ""
    
    # switch-case to decide how the user wants to search
    case "$input" in
        1)
            # storing those line numbers in f1.txt for which the user specified value is equal to values in files(to be searched)
            cat $filename_srch | cut -d , -f${column_arr[0]} | grep -in ^$1$ | cut -d : -f1 > f1.txt
            ;;
        2)  
             # storing those line numbers in f1.txt for which the user specified value is less than the values in files(to be searched)
            cat $filename_srch | cut -d , -f${column_arr[0]} | grep -in ^${column_arr_srch_str[0]}$ | cut -d : -f1
            ;;
        3)  
            # storing those line numbers in f1.txt for which the user specified value is greater than the values in files(to be searched)
            cat $filename_srch | cut -d , -f${column_arr[0]} | grep -in ^${column_arr_srch_str[0]}$ | cut -d : -f1
            ;;
        4)  
             # storing those line numbers in f1.txt for which the user specified value is NOT equal to values in files(to be searched)
            cat $filename_srch | cut -d , -f${column_arr[0]} | grep -vin ^$1$ | cut -d : -f1 > f1.txt
            ;;
    esac
}



search() 
{
    declare -a column_arr
    declare -a column_arr_srch_str
    
    read -p "Enter total number of columns based on which you want to search [1-3]: " column
    while((column < 1 || column > 3)) #[ $choice -lt 0 || $choice -gt 2 ]
    do
        read -p "Please Enter Valid No. of Columns Required to Perform Search: " column
    done
    
    tot_columns=$column
    
    echo " "
    echo "                                       Column Names                                            "
    echo "---------------------------------------------------------------------------------------------"
    echo " 1      2        3        4      5        6       7         8      9    10    11    12   13"
    echo "DATE DURATION PROTOCOL SRC_IP SRC_PORT DEST_IP DEST_PORT PACKETS BYTES FLOWS FLAGS  TOS CLASS"
    echo "---------------------------------------------------------------------------------------------"
    echo ""
    echo "Based on which column you want to search?"
    echo "----------------------------------------"
    
    i=0
    while((i < column))
    do
	read -p "Enter column number [1-13]: " value

        while((value < 1 || value > 13))
        do
	    read -p "Please Enter VALID $i column number value : " value
        done
        column_arr[i]=$value
        ((i=i+1))
    done
    echo ""
    
    echo "Enter the search strings against the selected columns"
    echo "-----------------------------------------------------"
 
    i=0
    while((i < column))
    do
	read -p "Enter column $(($i+1)) Search String : " value
	# value=$(echo ${input,,})  # making the input case-insensitive by converting the input to lowercase
        column_arr_srch_str[i]=$value
        ((i=i+1))
    done
    
    
    echo ""
    echo "Do you want to Search from All Files OR Single File?"
    echo "----------------------------------------------------"
	echo "1. Single File Searching"
	echo "2. All Files Searching"
	read -p "Enter choice [1-2]: " choice
	while((choice < 1 || choice > 2)) #[ $choice -lt 0 || $choice -gt 2 ]
    do
	    read -p "Please Enter the VALID choice [1-2]: " choice
    done
    

    if((column == 1))
    then
        # Searching in single column
        if((choice==1))
        then
            select_file  # calling the function named select_file
            
            # condition to check if the user is searching based "Packets" column or "Bytes" Column
            if((tot_columns==1 && column_arr[0]==8 || tot_columns==1 && column_arr[0]==9))
            then
                select_search_method ${column_arr_srch_str[0]} # calling the select_search_method function with one argument
            
            # condition to check if the user is searching based on "SRC IP" or "DEST IP"
            elif((tot_columns==1 && column_arr[0]==4 || tot_columns==1 && column_arr[0]==6))
            then
                cat $filename_srch | cut -d , -f${column_arr[0]} | grep -in ${column_arr_srch_str[0]} | cut -d : -f1 > f1.txt
            else
                cat $filename_srch | cut -d , -f${column_arr[0]} | grep -in ^${column_arr_srch_str[0]}$ | cut -d : -f1 > f1.txt
            fi
        fi
        if((choice==2))
        then
            # condition to check if the user is searching based on "SRC IP" or "DEST IP"
            if((tot_columns==1 && column_arr[0]==4 || tot_columns==1 && column_arr[0]==6))
            then
                cat *.csv | cut -d , -f${column_arr[0]} | grep -in ${column_arr_srch_str[0]} | cut -d : -f1 > f1.txt
            else  
                # the following line will run if the user is not searching either of the 4 or 6 column
                cat *.csv | cut -d , -f${column_arr[0]} | grep -in ^${column_arr_srch_str[0]}$ | cut -d : -f1 > f1.txt
            fi
        fi
        >f1_results.txt
        while read  line 
        do
            if((choice==1))
            then
                sed -n "$line"p $filename_srch >> f1_results.txt
            fi
            if((choice==2))
            then
                sed -n "$line"p *.csv >> f1_results.txt
            fi
        done<f1.txt
        store_results f1_results.txt
    fi
    
    
    if((column == 2))
    then
        # Searching in two columns
        if((choice==1))
        then
            select_file  # calling the function named select_file
            cat $filename_srch | cut -d , -f${column_arr[0]},${column_arr[1]} | grep -E -in ^"${column_arr_srch_str[0]},${column_arr_srch_str[1]}"$ | cut -d : -f1 > f1.txt
        # cat test.txt | cut -d , -f3,4 | grep -E -in ^"1,46"$
        # cat test.txt | cut -d , -f3,4 | grep -E -in ^'1.*46'$
        fi
        if((choice==2))
        then
            cat *.csv | cut -d , -f${column_arr[0]},${column_arr[1]} | grep -E -in ^"${column_arr_srch_str[0]},${column_arr_srch_str[1]}"$ | cut -d : -f1 > f1.txt
        fi
        >f1_results.txt
        while read  line 
        do
            if((choice==1))
            then
                sed -n "$line"p $filename_srch >> f1_results.txt
            fi
            if((choice==2))
            then
                sed -n "$line"p *.csv >> f1_results.txt
            fi
        done<f1.txt
        store_results f1_results.txt
    fi
    
    
    if((column == 3))
    then
        # Search in three columns
        if((choice==1))
        then
            select_file  # calling the function named select_file
            cat $filename_srch | cut -d , -f${column_arr[0]},${column_arr[1]},${column_arr[2]} | grep -E -in ^"${column_arr_srch_str[0]},${column_arr_srch_str[1]},${column_arr_srch_str[2]}"$ | cut -d : -f1 > f1.txt
        fi
        if((choice==2))
        then
            cat *.csv | cut -d , -f${column_arr[0]},${column_arr[1]},${column_arr[2]} | grep -E -in ^"${column_arr_srch_str[0]},${column_arr_srch_str[1]},${column_arr_srch_str[2]}"$ | cut -d : -f1 > f1.txt
        fi
        >f1_results.txt
        while read  line 
        do
            if((choice==1))
            then
                sed -n "$line"p $filename_srch >> f1_results.txt
            fi
            if((choice==2))
            then
                sed -n "$line"p *.csv >> f1_results.txt
            fi
        done<f1.txt
        store_results f1_results.txt
    fi
}

# -----------------------------------
#            Main Function
# -----------------------------------
search  # calling the search function

# This while loop will keep on running until you press ctrl+c or when you are asked to "search again" and you input "no"
while true
do
    echo ""
    read -p "Do you want to search again [yes/no]? " choice

    case "$choice" in
        YES|yes|YEs|Yes|yES|yeS) # checking if uer pressed any of them
            search # calling the search function
            ;;
        NO|no|No|nO)  # checking if user pressed any of them
            exit  # exiting the script
            ;;
    esac
done



