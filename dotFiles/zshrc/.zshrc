#!/usr/bin/zsh
source ~/.zplug/init.zsh
# Main variables
CURRENT_SHELL=$0
# exports main repo to a variable
export PETRYFILES="$HOME/petryfiles"

# function 
sourceIfExists() {
    if [[ -e $1 ]]; then
      source $1
    fi
}

checkIfZsh() {
  if [[ $CURRENT_SHELL =~ "[zsh]" ]]; then
    return 0
  fi
  return 1
}

# system config
systemExports() {
  export ANDROID_HOME=~/Android/Sdk
  export PATH=$PATH:$ANDROID_HOME/tools
  export PATH=$PATH:$ANDROID_HOME/platform-tools

  export PATH="$PATH:$HOME/flutter/bin"
  export PATH="$PATH:$HOME/.composer/vendor/bin"

  export LANG="en_US.UTF-8"
  export LC_ALL="en_US.UTF-8"
  export VISUAL=nvim
  export EDITOR=nvim
  # Append ruby gems to path
  export PATH="/home/petry/.gem/ruby/2.6.0/bin:$PATH"

  export PATH="$PATH:/var/lib/snapd/snap/bin"
  export PATH="$PATH:$HOME/go/bin"
  export PATH="$PATH:$HOME/petryfiles/bin"

  uname -a | \
    grep -iq Microsoft && \
    loadWslDocker
}

loadWslDocker() {
  export DOCKER_HOST="tcp://localhost:2375"
}

setZshOpts() {
	# remove notification of background jobs
	setopt no_monitor
  # history
  export SAVEHIST=10000
  export SAVEHIST=10000
  export HISTFILE=~/.zsh_history
  bindkey '\e[A' history-beginning-search-backward
  bindkey '\e[B' history-beginning-search-forward
  # Appends every command to the history file once it is executed
  setopt inc_append_history
  # Reloads the history whenever you use it
  setopt share_history
}

setZshOpts
# ohMyZshConfig
# commonCtrlBind
# colorFullLess
systemExports

# Load custom configs
sourceIfExists "$HOME/.aliases"
sourceIfExists "$HOME/.functions"
# sourceIfExists "$cool_docker_images_path/docker_functions.sh"
# load private stuff
sourceIfExists "$HOME/Protected/zsh/.aliases"
sourceIfExists "$HOME/Protected/zsh/.functions"

zplug "gabrielpetry/dotfiles", use:"zsh-plugins/*.zsh"
zplug "b4b4r07/httpstat", \
    as:command, \
    use:'(*).sh', \
    rename-to:'$1'

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2

# Define the theme
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zstyle :prompt:pure:git:stash show yes
PURE_CMD_MAX_EXEC_TIME=10
fpath+=$HOME/.zplug/repos/sindresorhus/pure

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Check if there's plugins to be installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load # --verbose
# ensure tmux
[ -z "$TMUX"  ] && { tmux }
