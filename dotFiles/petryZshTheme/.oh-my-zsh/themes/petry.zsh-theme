# vim: ft=zsh
local ret_status="%(?:%{$fg_bold[green]%} :%{$fg_bold[red]%} )"
local host="$USER@%M"

function virtualenv_info { 
 [ $VIRTUAL_ENV ] && echo '( '$(basename $VIRTUAL_ENV)') ' 
}

PROMPT='
 %{$fg[cyan]%}[$(hostname)]%{$reset_color%}\
 %~ $(git_prompt_info)
 %{$fg[cyan]%}$(date +%H:%M)%{$reset_color%}\
 %{$fg[green]%}$(virtualenv_info)%{$reset_color%}%\
 → '

ZSH_THEME_GIT_PROMPT_PREFIX="| %{$fg_bold[blue]%}%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}|"
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%} %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%} %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}"

