#!/bin/bash
read -p "Please enter the port number : " port_number

if [ $(sudo netstat -tulpn | grep -i listen | grep -oc "$port_number") -ge 1 ]
then
    echo "Port is in use"
else
    echo "Port not in use"
fi