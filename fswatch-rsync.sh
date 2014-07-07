#!/bin/bash

# @author Clemens Westrup
# @date 03.07.2014

# This script synchronizes a local project folder to a remote folder on the 
# triton cluster of Aalto University (or a similar setup).

# For setup and usage see README.md

################################################################################

MIDDLE="james.hut.fi" # middle ssh server
TARGET="triton.aalto.fi." # target ssh server

PROJECT="fswatch-rsync"
VERSION="0.1"

# check color support
colors=$(tput colors)
if (($colors >= 8)); then
    red='\033[0;31m'
    green='\033[0;32m'
    nocolor='\033[00m'
else
  red=
  green=
  nocolor=
fi

# Welcome
echo      ""
echo -e   "${green}Moikka! This is $PROJECT v$VERSION.${nocolor}" 
echo      "Local source path:  \"$1\""
echo      "Remote target path: \"$2\" on target server \"$TARGET\" via \"$MIDDLE\""
echo      "User:               \"$3"\"
echo      ""
echo -n   "Performing initial complete synchronization "
echo -n   "(Warning: Target directory will be overwritten "
echo      "with local version if differences occur)."

# Perform initial complete sync
read -n1 -r -p "Press any key to continue (or abort with Ctrl-C)... " key
echo      ""
echo -n   "Synchronizing... "
rsync -avzr -q --delete --force -e "ssh $3@$MIDDLE ssh" $1 $TARGET:$2 
echo      "done."
echo      ""

# Watch for changes and sync
echo    "Watching for changes. Quit anytime with Ctrl-C."
fswatch -0  -r $1 | while read -d "" event 
  do 
    echo $event > .tmp_files
    echo -en "${green}" `date` "${nocolor}\"$event\" changed. Synchronizing... "
    rsync -avzr -q --delete --force --include-from=.tmp_files -e "ssh $3@$MIDDLE ssh" $1 $TARGET:$2 
  echo "done."
    rm -rf .tmp_files
  done