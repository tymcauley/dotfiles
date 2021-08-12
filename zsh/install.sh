#!/bin/bash -e

# Customize zsh installation.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Make sure the custom fpath directory exists. This directory holds completion scripts for zsh that the user can
# install.
ZFUNC_PATH="$HOME/.zfunc"
if [[ ! -e "$ZFUNC_PATH" ]] ; then
    mkdir ~/.zfunc
fi

# Install powerline10k config file.
install_file "$HOME/.p10k.zsh" "$(pwd)/p10k.zsh"

# Clone zprezto repo and install it.
ZPREZTO_PATH="$HOME/.zprezto"

if [[ -d "$ZPREZTO_PATH" ]] ; then
    cd "$ZPREZTO_PATH"

    # Check if we have an upstream remote configured. If we don't then
    # configure one.
    if ! git remote -v | grep -q '^upstream' > /dev/null 2>&1 ; then
        git remote add upstream https://github.com/sorin-ionescu/prezto.git
    fi

    iecho "To update prezto from upstream:"
    echo "  cd $ZPREZTO_PATH"
    echo "  git fetch upstream"
    echo "  git checkout master"
    echo "  git rebase upstream/master"
    echo "  git push -f origin master"

    cd - > /dev/null
else
    # Clone ZSH configuration files.
    git clone --recursive https://github.com/tymcauley/prezto.git "$ZPREZTO_PATH"

    # Install ZSH configuration.
    for rcfile in $ZPREZTO_PATH/runcoms/z* ; do
        rcfile_name=$(basename $rcfile)
        ln -s -v "$rcfile" "$HOME/.$rcfile_name"
    done
fi

cd - > /dev/null
