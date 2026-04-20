#!/usr/bin/env bash
# Claude Code status line script
# ~/.claude/statusline-command.sh

input=$(cat)

# --- Extract fields from JSON ---
cwd=$(echo "$input"        | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input"      | jq -r '.model.display_name // ""')
used_pct=$(echo "$input"   | jq -r '.context_window.used_percentage // empty')
session_name=$(echo "$input" | jq -r '.session_name // empty')
vim_mode=$(echo "$input"   | jq -r '.vim.mode // empty')
output_style=$(echo "$input" | jq -r '.output_style.name // empty')
transcript=$(echo "$input" | jq -r '.transcript_path // empty')
cost=$(echo "$input"       | jq -r '.cost.total_cost_usd // empty')

# --- Colors (ANSI) ---
reset='\033[0m'
bold='\033[1m'
dim='\033[2m'

cyan='\033[36m'
yellow='\033[33m'
green='\033[32m'
blue='\033[34m'
magenta='\033[35m'
brblack='\033[90m'
white='\033[97m'
red='\033[31m'

# --- Working directory (shorten $HOME to ~) ---
home_dir="$HOME"
short_cwd="${cwd/#$home_dir/\~}"

# --- Git branch ---
git_branch=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
                 || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# --- Session duration (derived from transcript file mtime at creation) ---
duration_str=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
    # Use the transcript file's birth/creation time if available, else oldest mtime
    start_epoch=$(stat --format="%W" "$transcript" 2>/dev/null)
    # %W is birth time on Linux; 0 means unavailable, fall back to mtime
    if [ -z "$start_epoch" ] || [ "$start_epoch" = "0" ]; then
        start_epoch=$(stat --format="%Y" "$transcript" 2>/dev/null)
    fi
    if [ -n "$start_epoch" ] && [ "$start_epoch" != "0" ]; then
        now_epoch=$(date +%s)
        elapsed=$(( now_epoch - start_epoch ))
        h=$(( elapsed / 3600 ))
        m=$(( (elapsed % 3600) / 60 ))
        s=$(( elapsed % 60 ))
        if [ "$h" -gt 0 ]; then
            duration_str=$(printf "%dh%02dm" "$h" "$m")
        elif [ "$m" -gt 0 ]; then
            duration_str=$(printf "%dm%02ds" "$m" "$s")
        else
            duration_str=$(printf "%ds" "$s")
        fi
    fi
fi

# --- Context usage bar (10 chars wide) ---
ctx_str=""
if [ -n "$used_pct" ]; then
    pct_int=$(printf "%.0f" "$used_pct")
    # Color: green < 60%, yellow 60-85%, red >= 85%
    if [ "$pct_int" -ge 85 ]; then
        ctx_color="$red"
    elif [ "$pct_int" -ge 60 ]; then
        ctx_color="$yellow"
    else
        ctx_color="$green"
    fi
    ctx_str="${pct_int}%"
fi

# --- Session cost ---
cost_str=""
if [ -n "$cost" ]; then
    cost_str=$(printf "$%.2f" "$cost")
fi

# --- Current time ---
current_time=$(date "+%H:%M:%S")

# --- Assemble the status line ---
# Line 1:  <cwd>  <git branch>
# Line 2:  <model>  <ctx>  <time>  <duration>  [session]  [vim]  [style]

line1=""
printf -v line1 "${bold}${cyan}%s${reset}" "$short_cwd"
if [ -n "$git_branch" ]; then
    printf -v line1 "%s  ${bold}${yellow}%s${reset}" "$line1" "$git_branch"
fi

line2=""
printf -v line2 "${dim}${white}%s${reset}" "$model"

if [ -n "$ctx_str" ]; then
    printf -v line2 "%s  ${ctx_color}ctx:%s${reset}" "$line2" "$ctx_str"
fi

if [ -n "$cost_str" ]; then
    printf -v line2 "%s  ${green}%s${reset}" "$line2" "$cost_str"
fi

printf -v line2 "%s  ${brblack}%s${reset}" "$line2" "$current_time"

if [ -n "$duration_str" ]; then
    printf -v line2 "%s  ${brblack}%s${reset}" "$line2" "$duration_str"
fi

if [ -n "$session_name" ]; then
    printf -v line2 "%s  ${magenta}[%s]${reset}" "$line2" "$session_name"
fi

if [ -n "$vim_mode" ]; then
    if [ "$vim_mode" = "NORMAL" ]; then
        vim_color="$blue"
    else
        vim_color="$green"
    fi
    printf -v line2 "%s  ${vim_color}%s${reset}" "$line2" "$vim_mode"
fi

if [ -n "$output_style" ] && [ "$output_style" != "default" ]; then
    printf -v line2 "%s  ${brblack}style:%s${reset}" "$line2" "$output_style"
fi

printf "%b\n%b" "$line1" "$line2"
