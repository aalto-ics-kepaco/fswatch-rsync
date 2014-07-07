#!/bin/bash

# @author Clemens Westrup
# @date 07.07.2014

# This is a script to automatically synchronize a local project folder to a 
# folder on a cluster server via a middle server. 
# It watches the local folder for changes and recreates the local state on the 
# target machine as soon as a change is detected.

# For setup and usage see README.md

################################################################################

PROJECT="fswatch-rsync"
VERSION="0.2.0"

# Set up your path to fswatch here if you don't want to / can't add it 
# globally to your PATH variable (default is "fswatch" when specified in PATH). 
# e.g. FSWATCH_PATH="/Users/you/builds/fswatch/fswatch" 
FSWATCH_PATH="/Users/cwestrup/extracted_source_builds/fswatch/fswatch"

# Sync latency / speed in seconds
LATENCY="3"

# default server setup
MIDDLE="james.hut.fi" # middle ssh server
TARGET="triton.aalto.fi" # target ssh server

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

# Check compulsory arguments
if [[ "$1" = "" || "$2" = "" || "$3" = "" ]]; then
  echo -e "${red}Error: $PROJECT takes 3 compulsory arguments.${nocolor}"
  echo -n "Usage: fswatch-rsync.sh /local/path /targetserver/path ssh_user " 
  echo    "[middleserver] [targetserver] [target_ssh_user]"
  exit
else
  LOCAL_PATH="$1"
  TARGET_PATH="$2"
  SSH_USER="$3"
fi

# Check optional arguments
if [[ "$4" != "" ]]; then
  MIDDLE="$4"
fi
if [[ "$5" != "" ]]; then
  TARGET="$5"
fi
if [[ "$6" != "" ]]; then
  TARGET_SSH_USER="$6"
else
  TARGET_SSH_USER="$SSH_USER"
fi

# Welcome
echo      ""
echo -e   "${green}Hei! This is $PROJECT v$VERSION.${nocolor}" 
echo      "Local source path:  \"$LOCAL_PATH\""
echo      "Remote target path: \"$TARGET_PATH\""
echo      "Via middle server:  \"$SSH_USER@$MIDDLE\""
echo      "To target server:   \"$TARGET_SSH_USER@$TARGET\""
echo      ""
echo -n   "Performing initial complete synchronization "
echo -n   "(Warning: Target directory will be overwritten "
echo      "with local version if differences occur)."

# Perform initial complete sync
read -n1 -r -p "Press any key to continue (or abort with Ctrl-C)... " key
echo      ""
echo -n   "Synchronizing... "
rsync -avzr -q --delete --force --exclude=".*" \
-e "ssh $SSH_USER@$MIDDLE ssh" $LOCAL_PATH $TARGET_SSH_USER@$TARGET:$TARGET_PATH 
echo      "done."
echo      ""

# Watch for changes and sync (exclude hidden files)
echo    "Watching for changes. Quit anytime with Ctrl-C."
${FSWATCH_PATH} -0 -r -l $LATENCY $LOCAL_PATH --exclude="/\.[^/]*$" \
| while read -d "" event 
  do 
    echo $event > .tmp_files
    echo -en "${green}" `date` "${nocolor}\"$event\" changed. Synchronizing... "
    rsync -avzr -q --delete --force \
    --include-from=.tmp_files \
    -e "ssh $SSH_USER@$MIDDLE ssh" \
    $LOCAL_PATH $TARGET_SSH_USER@$TARGET:$TARGET_PATH 
  echo "done."
    rm -rf .tmp_files
  done