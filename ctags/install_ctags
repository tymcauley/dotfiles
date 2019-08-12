#!/bin/bash -e

# Customize ctags installation.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Install ctags config file.
install_file "$HOME/.ctags" "$(pwd)/ctags"

cd - > /dev/null
