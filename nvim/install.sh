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

# Install lua config files.
if [[ -d "lua" ]]; then
    install_dir "$HOME/.config/nvim/lua" "$(pwd)/lua"
fi

# Install syntax override files.
if [[ -d "after/ftplugin" ]]; then
    install_dir "$HOME/.config/nvim/after/ftplugin" "$(pwd)/after/ftplugin"
fi

cd - > /dev/null
