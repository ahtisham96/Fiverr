#!/bin/bash

tar -cvzf /tmp/backup_file.tgz $1

# Run the following commands to schedule this script in cron
# crontab -e
# Go to the last line of the file that will open
# add the following entry
# 0 1 * * 0 tar -cvzf /tmp/backup_home.tgz 2>> /tmp/backup_error.log
# save and exit from the editor. Before exiting from the editor, make sure your script is executable