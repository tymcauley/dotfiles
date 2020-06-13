#!/bin/bash -e

# Customize terminal configuration.
#   Alacritty: https://github.com/jwilm/alacritty
#   Kitty: https://sw.kovidgoyal.net/kitty/index.html

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Install alacritty config file.
install_file "$HOME/.config/alacritty/alacritty.yml" "$(pwd)/alacritty.yml"

# Install kitty config file.
install_file "$HOME/.config/kitty/kitty.conf" "$(pwd)/kitty.conf"

cd - > /dev/null
