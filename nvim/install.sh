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
install_file "$HOME/.config/nvim/init.lua" "$(pwd)/init.lua"

# Install lua config files.
install_dir "$HOME/.config/nvim/lua" "$(pwd)/lua"

# Install syntax override files.
install_dir "$HOME/.config/nvim/after/ftplugin" "$(pwd)/after/ftplugin"

cd - > /dev/null
