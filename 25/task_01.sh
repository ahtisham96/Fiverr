#!/bin/bash

cat /etc/passwd | grep $1 | cut -d: -f6 2>/dev/null # Get the home directory of the users having name $1