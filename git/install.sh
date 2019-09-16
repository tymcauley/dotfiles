#!/bin/bash -e

# Customize git installation.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Install git config file.
install_file "$HOME/.gitconfig" "$(pwd)/gitconfig"

# Install global git ignore file.
install_file "$HOME/.gitignore_global" "$(pwd)/gitignore_global"

cd - > /dev/null
