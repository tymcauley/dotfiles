#!/bin/bash -e

# Setup/update Homebrew/Linuxbrew packages.

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB


# If Homebrew/Linuxbrew isn't installed, give the user some directions and then exit.
if ! command -v brew > /dev/null 2>&1 ; then
    if [[ "$OSTYPE" == darwin* ]] ; then
        eecho "Looks like Homebrew isn't installed. Please install it before continuing:"
        echo "  /usr/bin/ruby -e \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\""
    else
        eecho "Looks like Linuxbrew isn't installed. Please install it before continuing:"

        LINUX_DISTRO="$(grep -E '^ID=([a-zA-Z]*)' /etc/os-release | cut -d '=' -f 2)"
        case $LINUX_DISTRO in
            *debian*|*ubuntu*)
                echo "  sudo apt install build-essential curl file git"
                ;;
            *centos*)
                echo "  sudo yum groupinstall 'Development Tools'"
                echo "  sudo yum install curl file git"
                ;;
            *)
                echo "I don't recognize Linux distribution '$LINUX_DISTRO'. See https://linuxbrew.sh/#dependencies for Linuxbrew dependencies."
                ;;
        esac

        echo "  sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)\""
        echo "  test -d ~/.linuxbrew && PATH=\"\$HOME/.linuxbrew/bin:\$HOME/.linuxbrew/sbin:\$PATH\""
        echo "  test -d /home/linuxbrew/.linuxbrew && PATH=\"/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:\$PATH\""
        echo "  echo \"\$(brew --prefix)/bin:\$(brew --prefix)/sbin\""
        echo "Add the output of this last command to the beginning of your PATH."
    fi
    exit 1
fi

# Update to the most recent version of Homebrew/Linuxbrew.
iecho "Updating Homebrew"
brew update

# Update all installed packages and casks.
iecho "Upgrading Homebrew packages and casks"
brew upgrade

# Make sure the default programs are installed.
INSTALLED_PROGRAMS=$(brew list --formula -1)
for program_name in $CFG_BREW_PROGRAMS ; do
    if ! echo "$INSTALLED_PROGRAMS" | grep -q "^$program_name\$" > /dev/null 2>&1 ; then
        brew install $program_name
    fi
done
