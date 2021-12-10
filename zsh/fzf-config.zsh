export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git --color=always"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

export FZF_DEFAULT_OPTS="
--ansi \
--reverse \
"

source ~/.fzf.zsh

# Search history with fzf if it is present
bindkey -M vicmd "/" fzf-history-widget

# Use fzf to find files/directories
bindkey -M vicmd "gf" fzf-file-widget
bindkey -M vicmd "gd" fzf-cd-widget

fzf() {
  # stdin is not a tty means data has been piped into fzf
  if [ ! -t 0 ]; then
    command fzf "$@"
    return $?
  fi

  local qry key sel mod res

  __fd() {
    FZF_DEFAULT_COMMAND='fd --color=always --type file --follow' \
      command fzf \
      --preview='case $(file -bL --mime-type {}) in
                   text/troff) man {} ;;
                   text/*)     bat --style=numbers --color=always {} ;;
                   *)          hexyl --bytes=4KiB --color=always --border=none {} ;;
                 esac' \
      --preview-window='right,65%' \
      --prompt="fd> " \
      --header=" " \
      --no-multi \
      --expect=enter,alt-enter,ctrl-c,esc,tab \
      --print-query \
      --query="$1"
  }

  __rg() {
    local rg_prefix
    rg_prefix="rg --color=always --ignore-case --line-number"

    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_FANCY_OPTS" \
    FZF_DEFAULT_COMMAND="$rg_prefix '$1' || true" \
      command fzf \
      --delimiter=: \
      --preview='case $(file -bL --mime-type {1}) in
                   text/troff) man {1} ;;
                   text/*)     bat --style=numbers --color=always --highlight-line {2} {1} ;;
                   *)          hexyl --bytes=4KiB --color=always --border=none {1} ;;
                 esac' \
      --preview-window='right,65%,+{2}/4' \
      --disabled \
      --prompt="rg> " \
      --header=" " \
      --bind "change:reload:$rg_prefix {q} || true" \
      --no-multi \
      --expect=enter,alt-enter,ctrl-c,esc,tab \
      --print-query \
      --query="$1"
  }

  mod="__fd"
  qry="$@"

  while true; do
    res=$(eval '$mod' '$qry')
    qry=$(echo "$res" | sed -n 1p)
    key=$(echo "$res" | sed -n 2p)
    sel=$(echo "$res" | sed -n 3p)

    [ "$key" != "tab" ] && break

    if [ "$mod" = "__rg" ]; then
      mod="__fd"
    else
      mod="__rg"
    fi
  done

  case "$key" in
    enter)
      if [ -z "$sel" ]; then
        $EDITOR "${qry#\'}"
      elif [ "$mod" = "__fd" ]; then
        $EDITOR "$sel"
      else
        $EDITOR $(echo "$sel" | cut -f1,2 -d':' | sed 's/:/ \+/g')
      fi
      ;;
    alt-enter)
      echo "${sel:-$qry}"
      ;;
    ctrl-c | esc | *)
      return 0
      ;;
  esac
}
