#!/bin/bash -e

# Customize zsh installation.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Make sure there's a zsh executable installed.
ZSH_PATH=$(which zsh)
if [[ ! -x "$ZSH_PATH" ]] ; then
    eecho "Could not detect a zsh executable (ZSH_PATH='$ZSH_PATH')"
    exit 1
fi

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

if $CFG_CHANGE_SHELL_TO_ZSH ; then
    # If necessary, change the user's shell to zsh.
    if [[ "$SHELL" != "$ZSH_PATH" ]] ; then
        iecho "Changing shell from '$SHELL' to '$ZSH_PATH'"
        # Only the root user is allowed to use a shell that is not in /etc/shells.
        if [[ "$(id -u)" != "0" ]] ; then
            SHELLS_FILE=/etc/shells
            # Make sure $ZSH_PATH is in $SHELLS_FILE.
            if ! grep -q "$ZSH_PATH" $SHELLS_FILE ; then
                eecho "Since you aren't the super-user, '$ZSH_PATH' must be in '$SHELLS_FILE'"
                eecho "Execute this command to fix that:"
                echo "  sudo echo $ZSH_PATH >> $SHELLS_FILE"
                exit 1
            fi
        fi
        chsh -s $ZSH_PATH
    fi
fi

cd - > /dev/null
