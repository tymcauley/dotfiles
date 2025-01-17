# Easy-to-use neovim
alias vim="nvim"
alias vimdiff="nvim -d"

# Replace ls with eza
alias ls="eza --classify=automatic"
alias ll="ls --long --binary --group --icons=automatic"
alias llg="ll --git"
alias la="ll --all"
alias l="ls --oneline --all"
alias lr="ls --recurse"
alias llr="ll --recurse"
alias lt="ls --tree"
alias llt="ll --tree"
alias llst="ll --sort=newest" # Sort by modified time, most recent at the bottom
alias llss="ll --sort=size"   # Sort by size, largest at the bottom

# 'git status' in tree view
alias gwst="eza -l --tree --git --git-ignore \
  --no-filesize --no-permissions --no-user --no-time --color=always \
  | awk '\$1 !~ /--/ { print }'"

# Monitor a file with syntax highlighting
function tailf
  tail -f "$argv" | bat --paging=never -l log
end

#
# Git aliases
#

# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function git_current_branch
    set ref $(git --no-optional-locks symbolic-ref --quiet HEAD 2> /dev/null)
    set ret $status
    if test $ret != 0
        if test $ret = 128
            return  # no git repo.
        end
        set ref $(git --no-optional-locks rev-parse --short HEAD 2> /dev/null) || return
    end
    string replace 'refs/heads/' '' $ref
end

# Log
set _git_log_medium_format  '%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'
set _git_log_oneline_format '%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n'
set _git_log_brief_format   '%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'

# Git
alias g='git'

# Branch (b)
alias gb='git branch'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'
alias gbl='git branch -vv'
alias gbL='git branch --all -vv'
alias gbm='git branch --move'
alias gbM='git branch --move --force'
alias gbc='git switch --create'
alias gbs='git switch'

# Commit (c)
alias gc='git commit --verbose'
alias gcS='git commit --verbose --gpg-sign'
alias gca='git commit --verbose --all'
alias gcaS='git commit --verbose --all --gpg-sign'
alias gcm='git commit --message'
alias gcmS='git commit --message --gpg-sign'
alias gcam='git commit --all --message'
alias gco='git checkout'
alias gcO='git checkout --patch'
alias gcf='git commit --amend --reuse-message HEAD'
alias gcfS='git commit --amend --reuse-message HEAD --gpg-sign'
alias gcF='git commit --verbose --amend'
alias gcFS='git commit --verbose --amend --gpg-sign'
alias gcp='git cherry-pick --ff'
alias gcP='git cherry-pick --no-commit'
alias gcr='git revert'
alias gcR='git reset "HEAD^"'
alias gcs='git show'
alias gcsS='git show --pretty=short --show-signature'
alias gcy='git cherry --verbose --abbrev'
alias gcY='git cherry --verbose'

# Conflict (C)
alias gCl='git --no-pager diff --name-only --diff-filter=U'
alias gCa='git add $(gCl)'
alias gCe='git mergetool $(gCl)'
alias gCo='git checkout --ours --'
alias gCO='gCo $(gCl)'
alias gCt='git checkout --theirs --'
alias gCT='gCt $(gCl)'

# Data (d)
alias gd='git ls-files'
alias gdc='git ls-files --cached'
alias gdx='git ls-files --deleted'
alias gdm='git ls-files --modified'
alias gdu='git ls-files --other --exclude-standard'
alias gdk='git ls-files --killed'
alias gdi='git status --porcelain --short --ignored | sed -n "s/^!! //p"'

# Fetch (f)
alias gf='git fetch'
alias gfa='git fetch --all'
alias gfc='git clone'
alias gfcr='git clone --recurse-submodules'
alias gfm='git pull'
alias gfma='git pull --autostash'
alias gfr='git pull --rebase'
alias gfra='git pull --rebase --autostash'

# Grep (g)
alias gg='git grep'
alias ggi='git grep --ignore-case'
alias ggl='git grep --files-with-matches'
alias ggL='git grep --files-without-matches'
alias ggv='git grep --invert-match'
alias ggw='git grep --word-regexp'

# Index (i)
alias gia='git add'
alias giA='git add --patch'
alias giu='git add --update'
alias gid='git diff --no-ext-diff --cached'
alias giD='git diff --no-ext-diff --cached --word-diff'
alias gii='git update-index --assume-unchanged'
alias giI='git update-index --no-assume-unchanged'
alias gir='git restore --staged'
alias giR='git restore --staged --patch'
alias gix='git rm -r --cached'
alias giX='git rm -r --force --cached'

# Log (l)
alias gl='git log --topo-order --pretty=format:"$_git_log_medium_format"'
alias gls='git log --topo-order --stat --pretty=format:"$_git_log_medium_format"'
alias gld='git log --topo-order --stat --patch --full-diff --pretty=format:"$_git_log_medium_format"'
alias gldf='git log --topo-order --stat --patch --follow --pretty=format:"$_git_log_medium_format"'
alias glo='git log --topo-order --pretty=format:"$_git_log_oneline_format"'
alias glg='git log --topo-order --graph --pretty=format:"$_git_log_oneline_format"'
alias glb='git log --topo-order --pretty=format:"$_git_log_brief_format"'
alias glc='git shortlog --summary --numbered'
alias glS='git log --show-signature'

# Merge (m)
alias gm='git merge'
alias gmC='git merge --no-commit'
alias gmF='git merge --no-ff'
alias gma='git merge --abort'
alias gmt='git mergetool'

# Push (p)
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpF='git push --force'
alias gpa='git push --all'
alias gpA='git push --all && git push --tags'
alias gpt='git push --tags'
alias gpc='git push --set-upstream origin "$(git_current_branch)"'
alias gpp='git pull origin "$(git_current_branch)" && git push origin "$(git_current_branch)"'

# Rebase (r)
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gri='git rebase --interactive'
alias grs='git rebase --skip'

# Remote (R)
alias gR='git remote'
alias gRl='git remote --verbose'
alias gRa='git remote add'
alias gRx='git remote rm'
alias gRm='git remote rename'
alias gRu='git remote update'
alias gRp='git remote prune'
alias gRs='git remote show'

# Stash (s)
alias gs='git stash push'
alias gsa='git stash apply'
alias gsx='git stash drop'
alias gsl='git stash list'
alias gsd='git stash show --patch --stat'
alias gsp='git stash pop'
alias gss='git stash push --include-untracked'
alias gsS='git stash push --patch --no-keep-index'
alias gsw='git stash push --include-untracked --keep-index'

# Submodule (S)
alias gS='git submodule'
alias gSa='git submodule add'
alias gSf='git submodule foreach'
alias gSi='git submodule init'
alias gSI='git submodule update --init --recursive'
alias gSl='git submodule status'
alias gSs='git submodule sync'
alias gSu='git submodule update --remote --recursive'

# Tag (t)
alias gt='git tag'
alias gtl='git tag --list'
alias gts='git tag --sign'
alias gtv='git verify-tag'

# Working Copy (w)
alias gws='git status'
alias gwS='git status --short'
alias gwd='git diff --no-ext-diff'
alias gwD='git diff --no-ext-diff --word-diff'
alias gwr='git restore'
alias gwR='git restore --patch'
alias gwc='git clean --dry-run'
alias gwC='git clean --force'
alias gwx='git rm -r'
alias gwX='git rm -r --force'
