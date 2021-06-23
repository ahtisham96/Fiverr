#!/bin/bash

# Define variables to store file names
DICT_FILE="dict.txt"
LOG_FILE="out.log"
PID_FILE="monitor.pid"
# Get full path of script using realpath command
SCRIPT_PATH=$(realpath "$0")

EVT=0
# Check if the user has provided enough argumments
if [ $# -eq 0 ]; then
  # if not show this message and
  echo "usage: monitor start [-p pid] [-u user] [-d x]"
  # exit as an error
  exit 1
fi

# Varables to store user define parameters and values
START_FLAG=0
STOP_FLAG=0
P_FLAG=0
U_FLAG=0
D_FLAG=0

USER_V=''
PID_V=''
D_TIME=1

# It will get all parameters of script
while [ $# -ne 0 ]; do
  # if with - there is not p u or d exit with anerror
  if [[ $1 =~ ^-([^pud]+) ]]; then
    MATCH=${BASH_REMATCH[1]}
    echo "monitor: -"${MATCH:0:1}": invalid option" 1>&2
    exit 1
  # If user give start parameter
  elif [[ $1 =~ ^start$ ]]; then
    # Set the start flag
    START_FLAG=1
  # If user give stop parameter
  elif [[ $1 =~ ^stop$ ]]; then
    # Set the stop flag
    STOP_FLAG=1
  # if -p argument is given
  elif [[ $1 =~ ^-p$ ]]; then
    # And any value is provided
    if [ $# -gt 1 ] && [[ ! $2 =~ ^- ]]; then
      # Give this value to PID_V
      PID_V=$2
      P_FLAG=1
      # Shif command with shift or slide the arrguments and remove the first argument
      shift
    else
      echo "monitor: no pid supplied" 1>&2
      exit 1
    fi
  # if -u argument is given
  elif [[ $1 =~ ^-u$ ]]; then
    # And any value is provided
    if [ $# -gt 1 ] && [[ ! $2 =~ ^- ]]; then
      # And that is a valid user
      if ! id $2 >/dev/null 2>&1; then
        # If not print this and exit
        echo "Please provide correct username!"
        exit 1
      fi
      USER_V=$2
      U_FLAG=1
      shift
    else
      echo "monitor: no user supplied" 1>&2
      exit 1
    fi
  elif [[ $1 =~ ^-d$ ]]; then
    if [ $# -gt 1 ] && [[ ! $2 =~ ^- ]]; then
      D_TIME=$2
      D_FLAG=1
      shift
    else
      echo "monitor: no pid supplied" 1>&2
      exit 1
    fi
  fi
  # Shif command with shift or slide the arrguments and remove the first argument
  shift
done

IFS=$'\n'
# Read all lines of dict.txt to lines array
read -d '' -r -a lines <"$DICT_FILE"
# Generate seatch query for grep command
search_query+="\(${lines[0]}\)"
for line in ${lines[@]:1}; do
  if ! [[ -z "$line" ]]; then
    search_query+="\|\($line\)"
    
  fi
done

# Function to log the lines
function logit() {
  local var=$1
  local name
  local group
  #get pid
      getpid=$(echo "$var" | awk '{print $2}')
  # Check if the line already exist
  if ! grep "$getpid" "$LOG_FILE" >/dev/null 2>&1; then
    # If not append it to the logfile
    if [[ "$var" =~ ^Date: ]]; then
      echo "$var" >>"$LOG_FILE"
    else
      ((EVT++))
      echo "Event $EVT" >>"$LOG_FILE"
      
      #get full name
      fullname=$(getent passwd $USER_V | cut -d ':' -f 5 | cut -d ',' -f 1)
      
      
      #get name of file
      name=$(lsof -X -u "$USER_V" | grep $getpid | (tail -n1) | awk '{print $NF}')
      #check state
      if [ "$(ps -o stat=$getpid)" == "T" ]; then
        state="suspended"
      else
        state="activated"
      fi
      #get root directory
      getdirectory=$(df $name | tail +2 | awk '{print $1}')
      #get the hard links
      synonyms=$(find $getdirectory -xdev -samefile $name)
      #get group name
      group=$(ps axfo pid,egroup | grep $getpid | awk '{print $NF}')
      command=$(echo "$var" | awk '{print $8, $9}')
      detail=$(echo "$var" | awk '{print "proc " $2 ", user " $1}')
      ddetail=$(echo ", group $group, command: $command, state $state, name: $name")
      echo  "     $detail" "("$fullname")" $ddetail ", synonyms: $synonyms"  >> "$LOG_FILE"
      
      
    fi
  fi
}

# Fuction to get all files and seacrch words in it
function get_files() {
  echo "Getting processes files..."
  # Get the files using by processess with ls command
  
  output=$(lsof -X -u "$USER_V" -p "$PID_V")
  
  # Check if the username is provided
  if ! [[ -z "$USER_V" ]]; then
    # If yes filter the result for that user
    output=$(echo "$output" | grep "$USER_V")
  fi
  # Check if PID is provided
  if ! [[ -z "$PID_V" ]]; then
    # If yes filter the result for that pid
    output=$(echo "$output" | grep "$PID_V")
  fi
  # Remove duplicate and binaary files
  output=$(echo "$output" | awk '{print $9}' | uniq)
  output=$(echo "$output" | grep "\(.log$\)\|\(.txt\)" | uniq)
  echo "Searching words in files..."
  # Initiat arrays
  files=()
  couter=0
  IFS=$'\n'
 
  # For every file in output
  for f in $output; do
    if [[ -f "$f" ]]; then
      # Check if any work is found
       
      if grep "$search_query" "$f">/dev/null; then
        # If yes print and log it
        echo "suspish  $f"
        logit "$f"
      
      
      fi
    fi
  done
}

# Function will search and log any suspisous command
function commmands() {
  # Get all processes
  output=$(ps -ef)
  # Check if the username is provided
  if ! [[ -z "$USER_V" ]]; then
    # If yes filter the result for that user
    output=$(echo "$output" | grep "$USER_V")
  fi
  # Check if PID is provided
  if ! [[ -z "$PID_V" ]]; then
    # If yes filter the result for that pid
    output=$(echo "$output" | grep "$PID_V")
  fi
  # Search for words in line
  echo "$output" | grep -i "$search_query"
}

# This function will log all lines one by one using logit fuction
function log_lines() {
  local var=$*
  # Set IFS to endline
  IFS=$'\n'
  # For every lines in line
  for line in $var; do
    # Send it to logit function
    logit "$line"
  done
}

# This fucntion will run the script forever
function run_me() {
  while true; do
    # Run command Function and log lines
    lines=$(commmands)
    log_lines "$lines"
    get_files "$lines"
    # ait for time provided by -d arrgument
    sleep $D_TIME
  done
}
# If stop flag is set
if [[ $STOP_FLAG -eq 1 ]]; then
 
  echo "Stopping $SCRIPT_PATH..."
  # Read the pid from pid file and kill the proccess
  if kill -9 $(cat "$PID_FILE") >/dev/null 2>&1; then
     rm monitor.pid
    echo "Stopped!"
  else
    echo "$SCRIPT_PATH is not running..."
  fi
  exit 0
# Else if start flag is set
elif [[ $START_FLAG -eq 1 ]]; then
  echo "Starting $SCRIPT_PATH..."
  logit "Date: $(date)"
  # run the run_me function as backgruoud process
  run_me >/dev/null &
  # Save the run_me process id to PID_FILE
  echo -en "$!" >"$PID_FILE"
  echo "Script is running..."
  
fi
