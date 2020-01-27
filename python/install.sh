#!/bin/bash -e

# Customize python installation.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Install inputrc (configuration for readline library).
install_file "$HOME/.inputrc" "$(pwd)/inputrc"

# Install pystartup.
install_file "$HOME/.pystartup" "$(pwd)/pystartup"

# Install the latest version of pip.
if ! command -v pip3 > /dev/null 2>&1; then
    eecho "pip3 not found. Please install it."
    exit 1
else
    # If pip is already installed, use it to update itself.
    pip3 install --upgrade pip
fi

# Install all the python packages we want.
pip3 install --upgrade $CFG_PYTHON_PACKAGES

cd - > /dev/null
