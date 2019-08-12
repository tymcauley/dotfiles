#!/bin/bash -e

# Customize tmux installation.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Install tmux config file.
install_file "$HOME/.tmux.conf" "$(pwd)/tmux.conf"

# Install Tmux Plugin Manager
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -e "$TPM_DIR" ]] ; then
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

cd - > /dev/null
