#!/bin/bash -e

# Install packages for Python3.

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

# Install everything needed to:
#   -Build Python code from source
#   -Run Tk GUIs
#   -Install matplotlib
#   -Install numpy
# TODO: Maybe don't need any of this on mac...
if $MAC; then
    brew install python3
elif $UBUNTU; then
    sudo apt-get install python3-dev tcl8.6-dev tk8.6-dev tcl-dev tk-dev \
        python3-tk libjpeg-dev libjpeg-turbo8-dev libjpeg8-dev liblcms2-dev \
        libfreetype6-dev libpng12-dev zlib1g-dev libatlas-base-dev gfortran
fi

# sudo is not necessary on Mac.
if $MAC; then
    INSTALL_CMD="pip3"
elif $UBUNTU; then
    INSTALL_CMD="sudo pip3"
fi

# Install the latest version of pip.
if ! which pip3 >/dev/null 2>&1; then
    if $MAC; then
        echo "pip3 not found, it should be present on Mac platforms. Exiting."
        exit 1
    elif $UBUNTU; then
        # If pip isn't yet installed, then get the newest version.
        curl -O https://bootstrap.pypa.io/get-pip.py
        sudo python3 get-pip.py
        rm get-pip.py
    fi
else
    # If pip is already installed, use it to update itself.
    $INSTALL_CMD install -U pip
fi

# Install all the python packages we want.
$INSTALL_CMD install -U cython
$INSTALL_CMD install -U jupyter
$INSTALL_CMD install -U numpy
$INSTALL_CMD install -U matplotlib
$INSTALL_CMD install -U scipy
$INSTALL_CMD install -U flake8
