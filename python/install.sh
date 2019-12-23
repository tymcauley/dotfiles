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

# If configured for it, install all python packages to a user-local site-packages directory.
if [[ "$OSTYPE" == darwin* ]] ; then
    if $CFG_PYTHON_USER_PACKAGES ; then
        PIP_INSTALL_CMD="pip3 install --user"
    else
        # When Homebrew is installed, sudo is not necessary on macOS for system-wide python package installation.
        PIP_INSTALL_CMD="pip3 install"
    fi
else
    PIP_INSTALL_CMD="sudo pip3 install"
    if $CFG_PYTHON_USER_PACKAGES ; then
        PIP_INSTALL_CMD="pip3 install --user"
    else
        PIP_INSTALL_CMD="sudo pip3 install"
    fi
fi

# Install the latest version of pip.
if ! command -v pip3 > /dev/null 2>&1; then
    eecho "pip3 not found. Please install it."
    exit 1
else
    # If pip is already installed, use it to update itself.
    $PIP_INSTALL_CMD --upgrade pip
fi

# Install all the python packages we want.
$PIP_INSTALL_CMD --upgrade $CFG_PYTHON_PACKAGES

cd - > /dev/null