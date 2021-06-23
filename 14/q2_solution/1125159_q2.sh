#!/bin/bash
# check if two arguments are passed
echo "$@" |awk '{for(i=0;i<=NF;i++); print i-1 }' > temp
args=`awk -F',' '{print $1}' temp`
if [[ $args -ne 2 ]]
then
    exit
fi
# check the existence of samplebash.sh file
if [[ ! -f "$1" ]] 
then
    exit
fi

# check the existence of output file
if [[ -f "$2" ]] 
then
    read -p "do you want to override the file(y,n): " option
    #this portion is not working still
    echo $option
    while [[ $option != "y" && $option != "Y" && $option != "N" && $option != "n" ]]
    do
        echo "It is going to validate input" 
        read -p "Please enter valid option [y/n]? " option
    done
    case "$option" in
        Y|y) # checking if uer pressed any of them
            # Remove Comments from the file
            echo "The script is going to remove comments and overwrite the file" && sleep 1
            sed -e '/^$/d' samplebash.sh > output_1 # It will remove empty lines from the file
            sed -e '1{/^#!/ {p}}; /^[\t\ ]*#/d;/\.*#.*/ {/[\x22\x27].*#.*[\x22\x27]/ !{:regular_loop s/\(.*\)*[^\]#.*/\1/;t regular_loop}; /[\x22\x27].*#.*[\x22\x27]/ {:special_loop s/\([\x22\x27].*#.*[^\x22\x27]\)#.*/\1/;t special_loop}; /\\#/ {:second_special_loop s/\(.*\\#.*[^\]\)#.*/\1/;t second_special_loop}}' output_1 > output.sh
            chmod +x output.sh
            rm output_1 temp
            ;;
        N|n)  # checking if user pressed any of them
            echo "The script is going to exit " && sleep 1
            rm temp 
            exit  # exiting the script
            ;;

    esac
else
    # Remove Comments from the file
    echo "The script is going to remove comments and store the result into output file" && sleep 1
    sed -e '/^$/d' samplebash.sh > output_1 # It will remove empty lines from the file
    sed -e '1{/^#!/ {p}}; /^[\t\ ]*#/d;/\.*#.*/ {/[\x22\x27].*#.*[\x22\x27]/ !{:regular_loop s/\(.*\)*[^\]#.*/\1/;t regular_loop}; /[\x22\x27].*#.*[\x22\x27]/ {:special_loop s/\([\x22\x27].*#.*[^\x22\x27]\)#.*/\1/;t special_loop}; /\\#/ {:second_special_loop s/\(.*\\#.*[^\]\)#.*/\1/;t second_special_loop}}' output_1 > output.sh
    chmod +x output.sh
    rm output_1 temp
fi
