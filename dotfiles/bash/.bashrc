#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC1091

# If not running interactively, don't do anything
case $- in
*i*) ;;
*)
    echo exiting
    return
    ;;
esac

shopt -s autocd                      # cd without typing cd, just the dir name
shopt -s cdspell                     # case INsentive cd
bind 'set completion-ignore-case on' # case insensitive tab completion

HISTCONTROL=ignoreboth
HISTSIZE=20000
HISTFILESIZE=4000

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s checkwinsize

source /etc/environment

# Overengineered bashrc caching mechanism to speed up shell startup time
# shm is ram, so reloading bashrc from there is faster (from 0.42s to 0.18s)
# benchmarked with `time bash -i -c exit`
export BASHRC_CACHE="/dev/shm/bashrc_cache"

bashrc_md5() {
    md5sum "$HOME/.bashrc" | awk '{print $1}'
}

# if the ~/.bashrc has changed since last cache, remove the cache
[[ "$(bashrc_md5)" != "$(cat "${BASHRC_CACHE}_md5" 2>/dev/null)" ]] &&
    rm -f "${BASHRC_CACHE}" "${BASHRC_CACHE}_md5"

[[ -f "${BASHRC_CACHE}" ]] &&
    source "$HOME/.config/bash/plugins/abbr.bash" &&
    source "${BASHRC_CACHE}" &&
    return

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export MAGENTA='\033[0;35m'
export CYAN='\033[0;36m'
export WHITE='\033[0;37m'
export NC='\033[0m'
export EDITOR="nvim"
export unix_configs="$HOME/unix-configs"
export SCRIPTS="$unix_configs/scripts"
export CACHE_DIR="$HOME/.cache"

function clear_bash_cache {
    rm -f "$BASHRC_CACHE"
    source ~/.bashrc
    source ~/.bashrc
}

function add_to_path {
    export PATH="$1:$PATH"
}

[ -x /usr/bin/lesspipe ] &&
    eval "$(/usr/bin/lesspipe)"

[ -x /usr/bin/dircolors ] &&
    eval "$(dircolors -b)"

add_to_path "$HOME/.bun/bin"

test -f ~/.config/bash/aliases &&
    source ~/.config/bash/aliases

if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

for plugin in "$HOME"/.config/bash/plugins/**; do
    source "$plugin"
done

for comp in "$HOME"/.config/bash/completions/**; do
    source "$comp"
done

add_to_path "$HOME/.asdf/installs/golang/1.24.1/packages/bin"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.meteor"
source ~/.config/bash/aliases.bash
add_to_path "/home/gabriel/.fly/bin"
add_to_path "$HOME/.cargo/bin"
add_to_path "$HOME/bin"
add_to_path "$HOME/.asdf/shims"

if [[ -d /home/linuxbrew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    add_to_path "/home/linuxbrew/.linuxbrew/bin"
    add_to_path "/home/linuxbrew/.linuxbrew/sbin"
    for f in /home/linuxbrew/.linuxbrew/etc/bash_completion.d/*; do
        source "$f"
    done
fi

add_to_path "$HOME/.krew"
add_to_path "$HOME/repos/gabrielpetry/homelab/bin"
add_to_path "${KREW_ROOT:-$HOME/.krew}/bin"

for comp in "$HOME"/.config/bash/functions/**; do
    source "$comp"
done

[ -z "${KUBECONFIG:-}" ] &&
    export KUBECONFIG="$HOME/.kube/config"
# for f in "$HOME/repos/gabrielpetry/homelab/kubeconfig"/*; do
#     export KUBECONFIG="$KUBECONFIG:$f"
# done

export PNPM_HOME="/home/gabriel/.local/share/pnpm"

export ASDF_DATA_DIR="$HOME/.asdf"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME=/.tool-versions

first_boot=0
if [[ "$first_boot" == 0 ]]; then
    if [[ "$PWD" == "/mnt/c/Users/gabriel" ]]; then
        cd "$HOME" || false
        alias code="/mnt/c/Users/gabriel/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code"
    fi
fi

source ~/.config/bash/aliases.bash
source ~/.config/bash/plugins/theme.bash

[[ -z "${ZELLIJ}" ]] && zellij

{
    echo "#/!usr/bin/env bash"
    echo "# shellcheck disable=all"
    shopt -p
    alias
    declare -p | grep -E -v '^declare -[a-zA-Z-]* (BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID|GROUPS|BASHPID)'
    declare -f
    abbr-alias
} >"${BASHRC_CACHE}"

bashrc_md5 >"${BASHRC_CACHE}_md5"

cd .
