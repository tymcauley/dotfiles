# XDG
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME   "$HOME/.local/share"
set -gx XDG_CACHE_HOME  "$HOME/.cache"

# Set default text editor
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"

# Use bat for man pager
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# pager
set -gx PAGER "less"
set -gx LESS "-i -M -R -S -w -X -z-4"

# fzf
set -gx FZF_DEFAULT_COMMAND "fd --type file --follow --hidden --exclude .git --color=always"
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_DEFAULT_OPTS "\
--ansi \
--reverse \
"

# Other software
set -gx COURSIER_BIN_DIR "$XDG_DATA_HOME/coursier/bin"
set -gx BAT_THEME "tokyonight_storm"

if status is-interactive
    # Prepend a directory to the PATH if it exists.
    function __path_prepend
        if test -d $argv
            fish_add_path -gP $argv
        end
    end

    # Use vi key bindings
    fish_vi_key_bindings

    #
    # Path additions
    #

    # Load system-specific modifications
    if test -r $__fish_config_dir/config.local.fish
        source $__fish_config_dir/config.local.fish
    end

    if test -x /opt/homebrew/bin/brew
        eval $(/opt/homebrew/bin/brew shellenv)
    end

    __path_prepend $COURSIER_BIN_DIR # Scala
    __path_prepend ~/.cargo/bin      # Rust
    __path_prepend ~/.ghcup/bin      # Haskell
    __path_prepend ~/.cabal/bin      # Haskell
    __path_prepend ~/.elan/bin       # Lean

    if set -q HOMEBREW_PREFIX
        __path_prepend "$HOMEBREW_PREFIX/opt/llvm/bin"            # LLVM utilities
        __path_prepend "$HOMEBREW_PREFIX/opt/ruby/bin"            # Ruby
        __path_prepend "$HOMEBREW_PREFIX/lib/ruby/gems/3.3.0/bin" # Ruby gems
        __path_prepend "$HOMEBREW_PREFIX/opt/make/libexec/gnubin" # make

        if test -d "$HOMEBREW_PREFIX/Cellar/riscv-gnu-toolchain/main"
            set -gx RISCV "$HOMEBREW_PREFIX/Cellar/riscv-gnu-toolchain/main"
        end
    end

    __path_prepend ~/.local/nvim-macos-$(uname -m)/bin # macOS installation of neovim
    __path_prepend ~/.local/bin                        # Local tools

    #
    # Aliases
    #

    source $__fish_config_dir/aliases.fish

    #
    # SSH
    #

    source $__fish_config_dir/ssh.fish

    #
    # fzf
    #

    fzf --fish | source

    #
    # direnv
    #

    if type -q direnv
        direnv hook fish | source
    end

    #
    # prompt
    #

    set -g hydro_color_pwd cyan --bold
    set -g hydro_color_git yellow --bold
    set -g hydro_color_error red --bold
    set -g hydro_color_prompt green --bold
    set -g hydro_color_duration brblack
    set -g hydro_color_time brblack

    set -g hydro_multiline true

    function fish_right_prompt
        # Show the time in HH:MM:SS format
        set_color $hydro_color_time
        date "+%H:%M:%S"
        set_color normal
    end

    #
    # Cleanup
    #

    functions -e __path_prepend
end
