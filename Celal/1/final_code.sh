BOLD=`tput smso`    # store code for bold mode in BOLD
NORMAL=`tput rmso`  # store code for end of the bold in NORMAL
export BOLD NORMAL  # make them recognized by subshells
main_menue()
{
    tput clear
    tput cup 5 10
    echo "UNIX Library - ${BOLD}MAIN MENU${NORMAL}"
    tput cup 7 20 ;   echo "0: ${BOLD}EXIT${NORMAL} this program"
    tput cup 9 20 ;   echo "1: ${BOLD}CUSTOMER Information${NORMAL} Menu"
    tput cup 11 20 ;   echo "2: ${BOLD}BILL Information${NORMAL} Menu"
    tput cup 13 20 ;  echo "3: ${BOLD}REPORTS${NORMAL} Menu"
    error_flag=0
    main_read_options
}
bill_info()
{
    tput clear
    tput cup 5 10
    echo "UNIX Library - ${BOLD}Bills Information${NORMAL}"
    tput cup 7 20 ; echo "Bill Due Date"
    tput cup 9 20 ; echo "Bill Post Date"
    tput cup 11 20 ; echo "Bill Amount"
    tput cup 13 20 ; echo "Client ID"
    tput cup 15 20; read due_date
    tput cup 15 35; read post_date
    tput cup 15 50; read bill_amount
    tput cup 15 60; read client_id
    echo $due_date $post_date $bill_amount $client_id >> bills_info.txt   
}
customer_info()
{
    tput clear
    tput cup 5 10
    echo "UNIX Library - ${BOLD}CUSTOMER Information${NORMAL} Menue"
    tput cup 7 20 ; echo "First Name"
    tput cup 9 20 ; echo "Last Name"
    tput cup 11 20 ; echo "Total Credit debit Amount"
    tput cup 13 20 ; echo "Last update date"
    tput cup 15 20 ; echo "Client ID"
    tput cup 17 20; read first_name
    tput cup 17 35; read last_name
    tput cup 17 50; read credit_amount
    tput cup 17 70; read debit_amount
    tput cup 17 85; read last_update_date
    tput cup 17 100; read client_id
    test=$(head -n 1 results.txt) 
    if((test == 0))
    then
        echo $client_id > results.txt
        echo $first_name $last_name $credit_amount $debit_amount $last_update_date $client_id >> results.txt
        ((test=test+1))
    else
        id=$(head -n 1 results.txt)
        ((id=id+1))
        sed -i "1s/.*/$id/" results.txt
        echo $first_name $last_name $credit_amount $debit_amount $last_update_date $id >> results.txt
    fi
}
report_menue()
{
    #Here you need to write the code for report menue
    tput clear
    tput cup 5 10 
    echo "UNIX Library - ${BOLD}REPORT MENU${NORMAL}"
    tput cup 7 20 ;   echo "Enter Client ID:  "
    tput cup 7 50 ; read client_id
    cat results.txt | cut -d " " -f6 | grep -n ${client_id} | cut -d : -f1 > temp.txt
    line_num=$(head -n 1 temp.txt) 
    cat bills_info.txt | cut -d " " -f4 | grep -n ${client_id} | cut -d : -f1 > temp.txt
    line_num2=$(head -n 1 temp.txt)
    echo "_______________________________________"
    echo "Client information with billing details"
    echo "_______________________________________"
    if(($line_num > 0))
    then
        sed -n "${line_num}p" results.txt
        sed -n "${line_num2}p" bills_info.txt
        echo "Customer Information printed to the client_info.txt file"
        cat results.txt > client_info.txt 
    else
        echo "Record not found!"
    fi  
    echo "Press Enter key to continue"
    read key
}
main_read_options()
{
    tput cup 15 10 ; echo -e "Enter your choice> \c"
    read choice
    #
    # case construct for checking the user selection
    #
    case $choice in
    0 ) tput clear ; exit 0 ;;
    1 ) customer_info ;;
    2 ) bill_info ;;
    3 ) report_menue ;;
    * ) ./ERROR 20 10
    tput cup 20 1 ; tput ed   # clear the rest of the screen
    error_flag=1 ;;
    esac
}
##########################--Main-Program--##########################
while true
do
    main_menue
done