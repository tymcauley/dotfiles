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

    if set -q HOMEBREW_PREFIX
        __path_prepend "$HOMEBREW_PREFIX/opt/llvm/bin"            # LLVM utilities
        __path_prepend "$HOMEBREW_PREFIX/opt/ruby/bin"            # Ruby
        __path_prepend "$HOMEBREW_PREFIX/lib/ruby/gems/3.3.0/bin" # Ruby gems
        __path_prepend "$HOMEBREW_PREFIX/opt/make/libexec/gnubin" # make
    end

    __path_prepend ~/.local/bin # Local tools

    #
    # Aliases
    #

    source $__fish_config_dir/aliases.fish

    #
    # fzf
    #

    fzf --fish | source

    #
    # prompt
    #

    function setup_prompt
        tide configure --auto \
            --style=Classic \
            --prompt_colors='True color' \
            --classic_prompt_color=Light \
            --show_time='24-hour format' \
            --classic_prompt_separators=Slanted \
            --powerline_prompt_heads=Slanted \
            --powerline_prompt_tails=Flat \
            --powerline_prompt_style='Two lines, character' \
            --prompt_connection=Solid \
            --powerline_right_prompt_frame=No \
            --prompt_connection_andor_frame_color=Light \
            --prompt_spacing=Sparse \
            --icons='Few icons' \
            --transient=Yes
    end

    #
    # Cleanup
    #

    functions -e __path_prepend
end
