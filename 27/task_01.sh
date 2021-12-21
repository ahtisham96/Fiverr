#!/bin/bash
for var in "$@"
do
    cat /etc/passwd | grep $var | cut -d: -f6 2>/dev/null # Get the home directory of the users having name entered by the user
done

 