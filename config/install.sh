#!/bin/bash -e

# Install dotfiles configuration file.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB


# Check to see if the user has a configuration file yet.
if [[ ! -e $USER_CONFIG_FILE ]] ; then
    iecho "You're missing a dotfiles configuration file: $USER_CONFIG_FILE"
    if [[ "$OSTYPE" == darwin* ]] ; then
        iecho "Creating a new configuration for your macOS system"
        cp -v "$DOTFILES_DIR/config/dotfiles.macos.cfg" "$USER_CONFIG_FILE"
    else
        iecho "Creating a new configuration for your Linux system"
        cp -v "$DOTFILES_DIR/config/dotfiles.linux.cfg" "$USER_CONFIG_FILE"
    fi
    iecho "Please review this file and make any necessary edits to configure your system."
    iecho "Afterwards, you can rerun the installation script."
    exit 1
fi

cd - > /dev/null
