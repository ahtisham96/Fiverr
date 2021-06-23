#!/bin/bash
read -p "Enter the file location : " f_loc
read -p "Enter the file name : " f_name
read -p "Enter the username on the remote machine : " u_name
read -p "Enter the remote machine name or ip address : " ip_addr

if [ "$(find $f_loc/$f_name -perm 777 -type f)" == "$f_loc/$f_name" ]
then
    sudo scp -v $f_loc/$f_name $u_name@$ip_addr:/tmp
else
    echo "Warning - the current user does not have rights to access this file"
fi