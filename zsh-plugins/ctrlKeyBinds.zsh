# Fix commoon CTRL bindings.

checkIfZsh || exit 0
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
# ctrl + Right Arrow
bindkey "^[[1;5C" forward-word
# ctrl + Left Arrow
bindkey "^[[1;5D" backward-word
