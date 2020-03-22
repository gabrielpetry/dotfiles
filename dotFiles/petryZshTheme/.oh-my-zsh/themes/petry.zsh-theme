# vim: ft=zsh

ZSH_THEME_PRIMARY_COLOR="cyan"
ZSH_THEME_USER_AND_HOST="$USER@%M"
ZSH_THEME_USER_AND_HOST="%{$fg[$ZSH_THEME_PRIMARY_COLOR]%}%{$USER%}@%M%{$reset_color%}"

function virtualenv_info { 
  [ $VIRTUAL_ENV ] && echo '( '$(basename $VIRTUAL_ENV)') '
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}("
ZSH_THEME_GIT_PROMPT_DIRTY=" ✗%{$fg[red]%})"
ZSH_THEME_GIT_PROMPT_CLEAN=")"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "

[ ZSH_THEME_DATE_FORMAT ] || ZSH_THEME_DATE_FORMAT="%H:%M:%S"

function get_date {
  echo "$(date +"%H:%M:%S")"
}

function exit_code {
  echo "%(?:%{$fg_bold[$ZSH_THEME_PRIMARY_COLOR]%}:%{$fg_bold[red]%})"
}

# hostname | path | git_status
# python_env | current_date
PROMPT='%{$ZSH_THEME_USER_AND_HOST%} %~ $(git_prompt_info)
$(virtualenv_info)$(get_date)$(exit_code) →%{$reset_color%} '