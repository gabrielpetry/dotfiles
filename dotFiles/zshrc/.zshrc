#!/usr/bin/zsh
# Main variables
CURRENT_SHELL=$0
# exports main repo to a variable
export PETRYFILES="$HOME/petryfiles"
# export cool docker files repo to a variable
if [ -z $cool_docker_images_path ]; then
    cool_docker_images_path="$HOME/Dockerfiles"
fi
# exports scripts folder to a variable
export SCRIPTS="$SCRIPTS_DIR"
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
## oh my zsh config 
ohMyZshConfig() {
  export ZSH=$HOME/.oh-my-zsh
  checkIfZsh || return 0
  ZSH_THEME="robbyrussell"
  plugins=(
    zsh-autosuggestions
  ) 
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
  # not listing virtual env in the top
  export VIRTUAL_ENV_DISABLE_PROMPT=yes

  source $ZSH/oh-my-zsh.sh
}
# Fix commoon CTRL bindings.
commonCtrlBind() {
  checkIfZsh || return 0
  # ctrl + a send to beginning of line
  bindkey "^a" beginning-of-line
  # ctrl + e send to end of line
  bindkey "^e" end-of-line
  # ctrl + b back on word
  bindkey "^b" backward-word
  # ctrl + k clear to EOL
  bindkey "^k" kill-line
  # ctrl + d delete one char
  bindkey "^d" delete-char
  # ctrl + y run the command and keep the line
  bindkey "^y" accept-and-hold
  # ctrl + w delete last world
  bindkey "^w" backward-kill-word
  # ctrl + u delete til start of line
  bindkey "^u" backward-kill-line
}
# less config
colorFullLess() {
  checkIfZsh || return 0
  export LESS='-F -i -J -M -R -W -x4 -X -z-4'
  export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
  export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
  export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
  export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
  export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
  export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
  export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
  if type lesspipe.sh >/dev/null 2>&1; then
    export LESSOPEN='|lesspipe.sh %s'
  fi
  if type pygmentize >/dev/null 2>&1; then
    export LESSCOLORIZER='pygmentize'
  fi
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
  export PATH="$PATH:$HOME/Protected/scripts"

  uname -a | \
    grep -q Microsoft && \
    loadWslDocker

  export TMOUT=14400 # timeout after 4h
}

loadWslDocker() {
  export DOCKER_HOST="tcp://localhost:2375"
}

setZshOpts() {
	# remove notification of background jobs
	setopt no_monitor
  zstyle ':completion:*'  matcher-list 'm:{a-z}={A-Z}'
}
load_nvm() {
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
}
nvm() {
  unset -f nvm # remove custom function
  # Only reloads if needed
  load_nvm
  nvm "$@" # run a command
}

node() {
  unset -f node
  load_nvm
  node "$@"
}

npm() {
  unset -f npm
  load_nvm
  npm "$@"
}

ng() {
  unset -f ng
  load_nvm
  ng "$@"
}


main() {
  setZshOpts
  ohMyZshConfig
  commonCtrlBind
  colorFullLess
  systemExports

  # Load custom configs
  sourceIfExists "$HOME/.aliases"
  sourceIfExists "$HOME/.functions"
  # sourceIfExists "$cool_docker_images_path/docker_functions.sh"
  # load private stuff
  sourceIfExists "$HOME/Protected/zsh/.aliases"
  sourceIfExists "$HOME/Protected/zsh/.functions"

  # ensure tmux
  [ -z "$TMUX"  ] && { tmux }
}


main

if [[ $PATH != */home/petry/Projects/Kinghost/hospedagem-compartilhada/dev-integracao-servicos/scripts/uteis* ]]; then
  PATH=${PATH}.":/home/petry/Projects/Kinghost/hospedagem-compartilhada/dev-integracao-servicos/scripts/uteis"
fi
if [[ $PATH != */home/petry/Projects/kinghost/hospedagem-compartilhada/dev-integracao-servicos/scripts/uteis* ]]; then
  PATH=${PATH}.":/home/petry/Projects/kinghost/hospedagem-compartilhada/dev-integracao-servicos/scripts/uteis"
fi
