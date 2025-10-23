#!/usr/bin/env bash

alias c="ps aux | grep -v grep | grep --color -i"

# git
abbrev-alias gitclean="git clean -fd; git reset --hard"
abbrev-alias gd="git diff"
abbrev-alias ga="git add"
abbrev-alias gsw="git switch"
abbrev-alias push="git push origin \$(git branch --show-current)"

alias kubectl="kubecolor"

alias grep='grep --color=auto'

# ls
alias ls='ls --color=auto'
alias sl="ls"
alias ll="ls -lh"
alias la="ls -lah"
alias tree="tree -C"

abbrev-alias pull="git fetch --prune; git pull origin \$(git branch --show-current)"

abbrev-alias -g G="| grep"
abbrev-alias -g T="| tail -n "
abbrev-alias -g W='| wc -l'
abbrev-alias -g 2null=' 2>/dev/null 3>&1'
abbrev-alias -g G='| grep --color -i '
abbrev-alias -g Ga='| grep --color=always -e "^" -i -e '
abbrev-alias -g C="| fcut"
abbrev-alias -g S="| sort"
abbrev-alias -g U="| uniq"
abbrev-alias -g X="| xargs"
abbrev-alias -g XX="| xargs -I{}"
abbrev-alias -g A="| fawk"
abbrev-alias -g W="| wc -l"
abbrev-alias -g XC="| wl-copy"
abbrev-alias -g kubesecret="| base64 -w 0| xclip -selection clipboard"
abbrev-alias k='kubectl'
alias kubectl="kubectl-cache"
alias kubectl-raw="kubecmd"

alias repo="source ~/repos/gabrielpetry/homelab/bin/repo"
alias cat=bat
