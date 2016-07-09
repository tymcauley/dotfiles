#!/bin/bash -e


# If the user accidentally ran this as root, tell them that this might be
# wrong.
if [[ $EUID -eq 0 ]]; then
    echo "This script was not designed to run as root. All files will be"
    echo "installed using the following HOME directory: $HOME"

    # Give the user the option to exit and re-run the script as a non-root
    # user.
    read -p "Do you want to continue running this script as root? [y/n] " yn
    if [ "$yn" != "y" ]; then
        exit 0
    fi
fi


# Keep track of starting directory.
CWD=`pwd`

# Check OS.
OS=`uname -s`
MAC=false
UBUNTU=false
if [[ "$OS" == "Darwin" ]]; then
    MAC=true
elif [[ "$OS" == "Linux" ]]; then
    # This should really do a check to see what linux distribution is being
    # used.
    UBUNTU=true
else
    echo "Unknown operating system: $OS. Aborting."
    exit 1
fi


# Make sure the basic set of utilities are installed.
if $MAC; then
    brew install vim zsh git
elif $UBUNTU; then
    sudo apt-get install vim-gnome zsh git
fi


# Customize git installation.
./git/install_git.bash


# Customize subversion installation.
# ./svn/install_svn.bash


# Customize Python3 installation.
./python/install_python.bash


# Install Base16 Shell.
dest_dir="$HOME/.config/base16-shell"
if [ -d "$dest_dir" ]; then
    cd $dest_dir
    git pull
    cd $CWD
else
    git clone https://github.com/chriskempson/base16-shell.git $dest_dir
fi


# Customize vim installation.
./vim/install_vim.bash


# Clone zprezto repo and install that.
ZPREZTO_PATH="$HOME/.zprezto"
ZSH_PATH=`which zsh`

if [[ -d "$ZPREZTO_PATH" ]]; then
    cd "$ZPREZTO_PATH"
    git pull
    git submodule update --init --recursive
    cd $CWD
else
    # Clone ZSH configuration files.
    git clone --recursive https://github.com/tymcauley/prezto.git \
        "$ZPREZTO_PATH"

    # Install ZSH configuration.
    for rcfile in $ZPREZTO_PATH/runcoms/z*; do
        rcfile_name=${rcfile##*/}
        ln -s "$rcfile" "$HOME/.$rcfile_name"
    done

    # Change shell to ZSH.
    echo "Changing shell to $ZSH_PATH. Confirm that it is in /etc/shells"
    chsh -s $ZSH_PATH
fi
