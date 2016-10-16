#!/bin/bash -e

# If the SVN configuration directory doesn't exist, then don't bother running
# this script.
SVN_CONFIG_DIR="$HOME/.subversion"
if [ ! -d $SVN_CONFIG_DIR ]; then
    echo "No subversion installation detected, skipping subversion config file"
    echo "edits."
    exit 0
fi

# Install 
sed -i 's/^# password-stores =$/password-stores = gnome-keyring/' \
    $SVN_CONFIG_DIR/config
sed -i 's/^# store-passwords = no$/store-passwords = yes/' \
    $SVN_CONFIG_DIR/servers
sed -i 's/^# store-plaintext-passwords = no$/store-plaintext-passwords = no/' \
    $SVN_CONFIG_DIR/servers
