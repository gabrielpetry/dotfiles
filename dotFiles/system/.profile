export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=nvim
export TERMINAL=kitty
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export BROWSER=/usr/bin/firefox
export SCRIPTS_DIR=$HOME/petryfiles/scripts
export PATH="$PATH:/var/lib/snapd/snap/bin"

export RED=$'\e[1;31m'
export GREEN=$'\e[1;32m'
export YELLOW=$'\e[1;33m'
export BLUE=$'\e[1;34m'
export MAGENTA=$'\e[1;35m'
export CYAN=$'\e[1;36m'
export NC=$'\e[0m'

export PRIMARY_COLOR="$($SCRIPTS_DIR/getColor.sh magenta)"
export ALERT_COLOR="$($SCRIPTS_DIR/getColor.sh yellow)"
export DANGER_COLOR="$($SCRIPTS_DIR/getColor.sh red)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
