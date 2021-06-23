#!/bin/bash
# This script prints out the 
# some special arguments
# 
# Check if there are arguments!
#
if [ $# -eq 0 ]; then
	echo "There are no arguments!"
	exit 1  # Exit if no arguments!
fi
# Otherwise, let's print some arguments
# 
	# Comment
echo "There are $# arguments!"
echo "Argument #1 is: $1"
exit 0
