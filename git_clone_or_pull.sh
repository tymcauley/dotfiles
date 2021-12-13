#!/bin/bash -e

# If a local git repo exists, update it. If it doesn't exist,
# clone a new repo in the expected location.
#
# Inputs:
#   $1 : path to remote git repository to clone/pull.
#   $2 : path to local git repository

URL="$1"
DIR="$2"

if [[ -d "$DIR" ]] ; then
    git -C "$DIR" pull
else
    git clone "$URL" "$DIR"
fi
