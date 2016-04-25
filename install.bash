#!/bin/bash -e

# Keep track of starting directory.
CWD=`pwd`


# Install Base16 Shell.
dest_dir="$HOME/.config/base16-shell"
if [ -d "$dest_dir" ]; then
    cd $dest_dir
    git pull
    cd $CWD
else
    git clone https://github.com/chriskempson/base16-shell.git $dest_dir
fi


# Prompt user to ask if they want to build vim with python3 support (this takes
# ~5 minutes).
read -p "Do you want to install/update vim with Python3 support? [y/n] " yn
if [ "$yn" == "y" ]; then
    vim_src_dir="vim_src"
    git clone https://github.com/vim/vim.git $vim_src_dir
    cd $vim_src_dir
    python3_config_dir=`python3-config --configdir`
    ./configure \
        --enable-perlinterp=yes \
        --enable-python3interp=yes \
        --enable-rubyinterp=yes \
        --enable-cscope \
        --enable-gui=auto \
        --enable-gnome-check=yes \
        --with-features=huge \
        --enable-multibyte \
        --with-x \
        --with-python3-config-dir=$python3_config_dir
    make
    sudo make install
    cd ..

    # Clean up.
    rm -rf $vim_src_dir
fi


# Customize vim installation.
./vim/install_vim.bash


# Clone zprezto repo and install that.
ZPREZTO_PATH="$HOME/.zprezto"

if [[ -d "$ZPREZTO_PATH" ]]; then
    cd "$ZPREZTO_PATH"
    git pull
    git submodule update --init --recursive
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
    chsh -s /bin/zsh
fi
