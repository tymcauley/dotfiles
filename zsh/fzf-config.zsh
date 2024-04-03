export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git --color=always"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

export FZF_DEFAULT_OPTS="
--ansi \
--reverse \
"

eval "$(fzf --zsh)"

# Search history with fzf if it is present
bindkey -M vicmd "/" fzf-history-widget

# Use fzf to find files/directories
bindkey -M vicmd "gf" fzf-file-widget
bindkey -M vicmd "gd" fzf-cd-widget
