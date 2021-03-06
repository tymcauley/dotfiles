#!/bin/bash -e

is_app_installed() {
    command -v "$1" >/dev/null 2>&1
}

# Get data either from stdin or from file.
buf=$(cat "$@")

# Resolve copy backend: pbcopy (macOS), reattach-to-user-namespace (macOS), xclip/xsel (Linux).
# Only use Linux `xsel`/`xclip` backends if the session isn't over SSH.
copy_backend=""
if is_app_installed pbcopy; then
    copy_backend="pbcopy"
elif is_app_installed reattach-to-user-namespace; then
    copy_backend="reattach-to-user-namespace pbcopy"
elif [ -n "${DISPLAY-}" ] && is_app_installed xsel; then
    copy_backend="xsel -i --clipboard"
elif [ -n "${DISPLAY-}" ] && is_app_installed xclip; then
    copy_backend="xclip -i -f -selection primary | xclip -i -selection clipboard"
fi

# If copy backend is resolved, copy and exit.
if [ -n "$copy_backend" ]; then
    printf "%s" "$buf" | eval "$copy_backend"
    exit
fi

# If none of the copy backends resolved, then fall back to using OSC 52 escape
# sequences. In theory, these should work very well, and transmit across remote
# connections. In practice, not many shells support them.

# Copy via OSC 52 ANSI escape sequence to controlling terminal
buflen=$(printf %s "$buf" | wc -c)

# https://sunaku.github.io/tmux-yank-osc52.html
# The maximum length of an OSC 52 escape sequence is 100_000 bytes, of which
# 7 bytes are occupied by a "\033]52;c;" header, 1 byte by a "\a" footer, and
# 99_992 bytes by the base64-encoded result of 74_994 bytes of copyable text
maxlen=74994

# warn if exceeds maxlen
if [ "$buflen" -gt "$maxlen" ]; then
    printf "input is %d bytes too long" "$((buflen - maxlen))" >&2
fi

# build up OSC 52 ANSI escape sequence
esc="\033]52;c;$(printf %s "$buf" | head -c $maxlen | base64 | tr -d '\r\n')\a"
esc="\033Ptmux;\033$esc\033\\"

# resolve target terminal to send escape sequence
# if we are on remote machine, send directly to SSH_TTY to transport escape sequence
# to terminal on local machine, so data lands in clipboard on our local machine
pane_active_tty=$(tmux list-panes -F "#{pane_active} #{pane_tty}" | awk '$1=="1" { print $2 }')
target_tty="${SSH_TTY:-$pane_active_tty}"

printf "$esc" >"$target_tty"
