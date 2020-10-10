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

npx() {
  unset -f npm
  load_nvm
  npm "$@"
}

ng() {
  unset -f ng
  load_nvm
  ng "$@"
}