#!/bin/bash

date=$(date '+%Y-%m-%d')
mkdir $date 2>/dev/null 
if [ -z "$1" ]   #checking the  if the user passed the folder path or name
then
      echo "Path of folder is misssing"
else

     name=`echo "$1" | awk -F'/' '{print $(NF-0)}'`  #getting the folder name 
     tar vfcz "$date"/"""$name"".tar.gz" --absolute-names $1     #taking the backup or making the  tar.gz
     aws s3api put-object --bucket backupsfolder --key "$date"/"""$name"".tar.gz" --body "$date"/"""$name"".tar.gz" ##Replace "backupsfolder" with your S3 Bucket
     rm -r $date
fi
