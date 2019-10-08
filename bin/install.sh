#!/bin/bash -e

# Install local bin scripts.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

LOCAL_BIN=$HOME/.local/bin

# Install all executable files in the `./bin/` folder.
for absolute_source_f in $(find $(pwd)/bin -type f -depth 1 -perm +u+x) ; do
    f_name=$(basename $absolute_source_f)
    install_file "$LOCAL_BIN/$f_name" "$absolute_source_f"
done

cd - > /dev/null
