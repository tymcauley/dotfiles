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
CENTOS=false
UBUNTU=false
if [[ "$OS" == "Darwin" ]]; then
    MAC=true
elif [[ "$OS" == "Linux" ]]; then
    if cat /etc/system-release | grep -iq centos; then
        CENTOS=true
    elif cat /etc/system-release | grep -iq ubuntu; then
        UBUNTU=true
    else
        echo "In Linux, unknown distro: $OS. Aborting."
        exit 1
    fi
else
    echo "Unknown operating system: $OS. Aborting."
    exit 1
fi


# Make sure the basic set of utilities are installed.
if $MAC; then
    # If homebrew isn't installed, install it.
    if ! which brew >/dev/null 2>&1; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew install vim zsh git htop

    # NOTE: To get htop to be able to see all processes not owned by the
    # current user (basically, to get around having to run `sudo htop`), you
    # have to do this:
    #   cd /usr/local/Cellar/htop/<VERSION_NUMBER>/bin/
    #   chmod 6555 htop
    #   sudo chown root htop

    # Update to the most recent version of Homebrew.
    brew update

    # Update all installed Homebrew packages.
    brew upgrade
elif $CENTOS; then
    echo "Nothing to install for CentOS."
elif $UBUNTU; then
    sudo apt-get install vim-gnome zsh git
fi


# Customize git installation.
./git/install_git.bash


# Customize subversion installation.
# ./svn/install_svn.bash


# Customize Python3 installation.
./python/install_python.bash $MAC $CENTOS $UBUNTU


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

    # Before updating our local repo, update this repo from the parent that we
    # forked from.

    # Check if we have an upstream remote configured. If we don't then
    # configure one.
    if ! git remote -v | grep -s '^upstream' >/dev/null 2>&1; then
        git remote add upstream https://github.com/sorin-ionescu/prezto.git
    fi

    # Fetch everything in the remote that we don't have yet.
    git fetch upstream

    # Make sure we're currently in the master branch of the local repo.
    git checkout master

    # Rewrite the master branch so that any commits in the upstream that we don't
    # have get played over. The alternative is using `git merge upstream/master`,
    # but that adds in an extra 'merged branches' commit.
    git rebase upstream/master

    # Now we can update.
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

    # If the users's shell is already ZSH, don't both changing it.
    if ! echo $SHELL | grep -iq zsh; then
        echo "Changing shell to $ZSH_PATH. Confirm that it is in /etc/shells"
        chsh -s $ZSH_PATH
    else
        echo "Shell set to $SHELL. No change necessary."
    fi
fi
