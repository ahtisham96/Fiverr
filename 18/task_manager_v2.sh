#!/bin/bash
#ESC=$( $e "\033")
BOLD=`tput smso`    # store code for bold mode in BOLD
NORMAL=`tput rmso`  # store code for end of the bold in NORMAL

export BOLD NORMAL  # make them recognized by subshells
export START_ROW=15
export END_ROW=34
export CURR_COL=2
export right_active_starting_index=1 
export right_active_ending_index=20
export left_active_starting_index=1
export left_active_ending_index=1
export selected_left_index=1
export selected_right_index=1
export curr_position=1 # 1 for left and 2 for right

echo "root" > users_file.txt
ps -aux | sed 's/\|/ /'|awk '{print $1, $11, $2, $9, $8}' > ps_file.txt # it will take all the process running in the system and store them into the file ps_file.txt 
ps -aux | sed 's/\|/ /'|awk '{print $1}' > temp_usr.txt
sort -k1,1 -u temp_usr.txt > temp_usr2.txt # get unique users exists in the task manager includig servers name

declare -a allusers_arr
count1=0
while IFS= read -r line; 
do
    allusers_arr[$count1]=$line
    ((count1=count1+1))
done < temp_usr2.txt

left_active_ending_index=$count1
# Create process detail file for each user                 
i=0
while ((i<count1))
do
    touch ${allusers_arr[$i]}.txt
    > ${allusers_arr[$i]}.txt
    cat ps_file.txt | grep ${allusers_arr[$i]} | sed 's/\|/ /'|awk '{print $2, $3, $4, $5}' | sort -nr -k2,2  > ${allusers_arr[$i]}.txt 
    ((i=i+1))
done
show_menue()
{
    #tput cup $prev_right_ind 0 ; echo "                                                                                                           "
    # It will print the same content in the same manner by applying some margine
    #if (($curr_position==1))
    #then
    #    tput cup $left_prev 0; tput el
    #else
    #    tput cup $right_prev 0; tput el
    #fi 
    tput clear
    tput cup 36 0 ; echo "If you want to exit , Please Type 'q' or 'Q'"
    tput cup 1 0 ; echo "______                           _     _     "            
    tput cup 2 0 ; echo "| ___ ＼                        | |   (_)                "
    tput cup 3 0 ; echo "| |_/  / _ __   __  _    ____   | |_   _   ____   ____   "
    tput cup 4 0 ; echo "|  __ / |  __| /  _  |  /  __|  | __| | | /  __| /  _ ＼ "
    tput cup 5 0 ; echo "|  |    |  |  |  ( | | |  (__   | |_  | ||  (__ |   __/  "
    tput cup 6 0 ; echo "＼_|    |__|  ＼__,__| ＼____|  ＼__| |_|＼____|＼____|  "
    tput cup 8 0 ; echo "(_)           |  |     (_)                             "
    tput cup 9 0 ; echo " _   __ ___   |  |      _   __ ___    __   __   __   __  "    
    tput cup 10 0 ; echo "| | |   _  ＼ |  |     | | |   _  ＼ |  | |  | ＼ ＼/ /  "    
    tput cup 11 0 ; echo "| | |  | |  | |  |____ | | |  | |  | |  |_|  |  >     <  "     
    tput cup 12 0 ; echo "|_| |__| |__| ＼_____/ |_| |__| |__| ＼___,__|  /_/＼_＼ "    
    tput cup 13 0 ;
    tput cup 14 0 ; echo "-NAME-----------------CMD--------------------PID------STIME-----"
    max_rows=20 ; start=1 ; end=20 ; name_ind=15
    i=$right_active_starting_index ; j=1 ; temp=$selected_left_index ; ((temp-=1)) ; var1=${allusers_arr[$temp]} 
    line_track=`cat ${allusers_arr[$temp]}.txt | wc -l`
    while((start<=end))
    do
        tput cup $name_ind 1 ; echo "|"
        tput cup $name_ind 21 ; echo "|"
        tput cup $name_ind 44 ; echo "|"
        tput cup $name_ind 53 ; echo "|"
        tput cup $name_ind 63 ; echo "|"
        if (($selected_right_index==j)) 
        then
            right_prev=$selected_right_index
            temp=`awk '{print $1}' ${var1}.txt | sed "${i}q;d" | head -c 18`
            temp2=`awk '{print $4}' ${var1}.txt | sed "${i}q;d" | grep + | wc -l`
            if ((temp2==1))
            then
                tput cup $name_ind 22 ; printf "\e[48;5;%sm%03s" 2 !F$temp ; printf '\e[0m \n'
            else
                tput cup $name_ind 22 ; printf "\e[48;5;%sm%03s" 2 !B$temp ; printf '\e[0m \n'
            fi
            temp=`awk '{print $2}' ${var1}.txt | sed "${i}q;d"`
            tput cup $name_ind 45 ; printf "\e[48;5;%sm%03s" 2 $temp ; printf '\e[0m \n'
            temp=`awk '{print $3}' ${var1}.txt | sed "${i}q;d"`
            tput cup $name_ind 54 ; printf "\e[48;5;%sm%03s" 2 $temp ; printf '\e[0m \n'
        else
            temp=`awk '{print $1}' ${var1}.txt | sed "${i}q;d" | head -c 19`
            temp2=`awk '{print $4}' ${var1}.txt | sed "${i}q;d" | grep + | wc -l`
            temp3=`awk '{print $1}' ${var1}.txt | sed "${i}q;d" | wc -l`
            if ((temp2==1 && temp3==1))
            then
                tput cup $name_ind 22; echo !F $temp
            fi
            if ((temp2==0 && temp3==1))
            then
                tput cup $name_ind 22; echo !B $temp
            fi
            temp=`awk '{print $2}' ${var1}.txt | sed "${i}q;d"`
            tput cup $name_ind 45; echo $temp
            temp=`awk '{print $3}' ${var1}.txt | sed "${i}q;d"`
            tput cup $name_ind 54; echo $temp
        fi
        ((name_ind=name_ind+1)) ; ((start=start+1)) ; ((i=i+1)) ; ((j=j+1))
    done
    tput cup 35 0 ; echo "----------------------------------------------------------------"

    # Fill the table with user detail
    row=$START_ROW
    start=$left_active_starting_index ; end=$left_active_ending_index ; i=$left_active_starting_index ; zz=$selected_left_index ; j=1 ;
    while((start<=end))
    do
        if (($zz==j)) 
        then
            left_prev=$selected_left_index
            temp=`awk '{print $1}' temp_usr2.txt | sed "${i}q;d"`
            tput cup $row 2 ; printf "\e[48;5;%sm%03s" 1 $temp ; printf '\e[0m \n'
        else
            temp=`awk '{print $1}' temp_usr2.txt | sed "${i}q;d"`
            tput cup $row 2 ; echo "$temp"
        fi
        ((start+=1)) ; ((i=i+1)) ; ((row=row+1)) ; ((j+=1))
    done
}

# Display menue
show_menue 

#Handle Arrow keys movement
tput cup 36 0 ; echo "If you want to exit , Please Type 'q' or 'Q'"
while tput cup 37 0 ; read -rsn1 k 
do
    case "$k" in
    A) # Up
        # Routine for handling arrow-up-key
        echo "UP"
        
        #Handle Left Column
        if ((selected_left_index>1 && curr_position==1))
        then
            ((selected_left_index-=1))
        else
            if ((left_active_starting_index>1 && curr_position==1))
            then
                ((left_active_starting_index-=1)) ; ((left_active_ending_index-=1))
            fi
        fi

        #Handle Right Column
        if ((selected_right_index>1 && curr_position==2))
        then
            ((selected_right_index-=1))
        else
            if ((right_active_starting_index>1 && curr_position==2))
            then
                ((right_active_starting_index-=1)) ; ((right_active_ending_index-=1))
            fi
        fi
        show_menue 
        ;;
    B) # Down
        # Routine for handling arrow-down-key
        # Handle Right Column
        var=`awk '{print $1}' final_users.txt | sed "${selected_left_index}q;d"`
        max_right_index=`cat ${var}.txt | wc -l`
        if ((selected_right_index<20 && curr_position==2))
        then
            ((selected_right_index+=1))
        else 
            if ((right_active_ending_index < max_right_index && curr_position==2))
            then
                ((right_active_starting_index+=1)) ; ((right_active_ending_index+=1))
            fi
        fi
        # Hanlde Left Column
        ((max_left_index=$count1))
        if ((selected_left_index<20 && curr_position==1 && selected_left_index<max_left_index))
        then
            ((selected_left_index+=1))
        else
            if ((left_active_ending_index < max_left_index && curr_position==1))
            then
                ((left_active_starting_index+=1)) ; ((right_active_ending_index+=1))
            fi
        fi
        show_menue 
        ;;
    C) # Right
        # Routine for handling arrow-left-key
        if ((curr_position==1))
        then
            selected_right_index=1 ; right_active_starting_index=1 ; right_active_ending_index=20 ; ((curr_position=2))
        fi
        show_menue 
        ;;
    D) # Left
         #Routine for handling arrow-right-key
        if ((curr_position==2))
        then
            selected_right_index=1 ; right_active_starting_index=1 ; right_active_ending_index=20 ; ((curr_position=1))
        fi
        show_menue 
        ;;
    "") # Enter key handler
        usr=`who | cut -d' ' -f1 | sort | uniq`
        if [ $curr_position -eq 2 ] && [ $usr == ${var1} ]
        then
            sed -i "$selected_right_index d" ${var1}.txt 
            temp=`awk '{print $2}' ${var1}.txt | sed "${selected_right_index}q;d"`
            kill -9 $temp
            #((selected_right_index=selected_right_index+1))
        else
            tput cup 38 1 ; echo "This user is not currently logged in. So, you can't kill it"
        fi
        show_menue
        ;;     
    [Qq]) # quit the script
         # Routine for handling q and Q key
         i=0
        while ((i<count1))
        do
            rm ${allusers_arr[$i]}.txt
            ((i=i+1))
        done
        rm  ps_file.txt temp_usr.txt temp_usr2.txt users_file.txt
        exit;
    esac
done