#!/bin/bash -e

# Install packages for Python3.

# Install everything needed to:
#   -Build Python code from source
#   -Run Tk GUIs
#   -Install matplotlib
#   -Install numpy
sudo apt-get install python3-dev tcl8.6-dev tk8.6-dev tcl-dev tk-dev \
    python3-tk libjpeg-dev libjpeg-turbo8-dev libjpeg8-dev liblcms2-dev \
    libfreetype6-dev libpng12-dev zlib1g-dev libatlas-base-dev gfortran

# Install the latest version of pip.
if ! which pip3 >/dev/null 2>&1; then
    # If pip isn't yet installed, then get the newest version.
    curl -O https://bootstrap.pypa.io/get-pip.py
    sudo python3 get-pip.py
    rm get-pip.py
else
    # If pip is already installed, use it to update itself.
    sudo pip3 install -U pip
fi

# Install all the python packages we want.
sudo pip3 install -U cython
sudo pip3 install -U jupyter
sudo pip3 install -U numpy
sudo pip3 install -U matplotlib
sudo pip3 install -U scipy
sudo pip3 install -U flake8
