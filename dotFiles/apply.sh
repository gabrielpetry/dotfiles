#!/bin/bash

checkFileAndremove() {
  if [[ -d "$1" || -f "$1"  ]]; then
    rm -rf $1
    return 0
  fi

  return 1
}

checkFileAndremove "$HOME/.config/dunst"
checkFileAndremove "$HOME/.config/compton"
checkFileAndremove "$HOME/.config/fusuma"
checkFileAndremove "$HOME/.config/i3"
checkFileAndremove "$HOME/.config/i3blocks"
checkFileAndremove "$HOME/.config/kitty"
checkFileAndremove "$HOME/.config/nvim"
checkFileAndremove "$HOME/.config/polybar"
checkFileAndremove "$HOME/.config/ranger"
checkFileAndremove "$HOME/.config/sxhkd"
checkFileAndremove "$HOME/.profile"
checkFileAndremove "$HOME/.config/termite"
checkFileAndremove "$HOME/.vimrc"
checkFileAndremove "$HOME/.config/Code - Oss"
checkFileAndremove "$HOME/.Xmodmap"
checkFileAndremove "$HOME/.Xprofile"
checkFileAndremove "$HOME/.Xresources"
checkFileAndremove "$HOME/.zshrc"
checkFileAndremove "$HOME/.doom.d"

echo "All original files removed"

stow compton -v -t ~
stow dunst -v -t ~
stow firefox -v -t ~
stow fusuma -v -t ~
stow i3 -v -t ~
stow i3blocks -v -t ~
stow kitty -v -t ~
stow nvim -v -t ~
stow petryZshTheme -v -t ~
stow polybar -v -t ~
stow ranger -v -t ~
stow sxhkd -v -t ~
stow system -v -t ~
stow termite -v -t ~
stow vim -v -t ~
stow vscode -v -t ~
stow xorg -v -t ~
stow zshrc -v -t ~
stow doomEmacs -v -t ~
