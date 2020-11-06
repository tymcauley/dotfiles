#!/bin/bash -e

# Customize neovim installation.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Install neovim config file.
install_file "$HOME/.config/nvim/init.vim" "$(pwd)/init.vim"

cd - > /dev/null
