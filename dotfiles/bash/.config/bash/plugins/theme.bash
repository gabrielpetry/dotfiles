#!/usr/bin/env bash

function get_username_hostname {
    local hostname
    hostname="$HOSTNAME"
    [[ "$hostname" == "cachyos" ]] && hostname="work"
    echo -e "${BLUE}${USER}@${hostname}${NC}"
}

function get_working_dir {
    echo -e "${NC}$PWD${NC}" | sed 's|'$HOME'|~|g'
}

function timer_start {
    export TIMER=${TIMER:-$SECONDS}
}

function last_command_status {
    if [ "$?" -eq 0 ]; then
        echo -e "$GREEN+$NC"
    else
        echo -e "$RED-$NC"
    fi
}

function last_command_time {
    if [ "$LAST_COMMAND_TIME" -ge "10" ]; then
        echo -e "[${RED}${LAST_COMMAND_TIME}s${NC}]"
    else
        echo -e "[${GREEN}${LAST_COMMAND_TIME}s${NC}]"
    fi
}

function timer_stop {
    export LAST_COMMAND_TIME=$((SECONDS - TIMER))
    unset TIMER
}

function add_ps1_block {
    export PS1="${PS1}${1}"
}

function git_branch {
    git_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [ -n "$git_branch" ]; then
        dirty="$(git status --porcelain 2>/dev/null | wc -l)"
        if [ "$dirty" -gt 0 ]; then
            echo -e " on ${RED}${git_branch}*${NC}"
        else
            echo -e " on ${GREEN}${git_branch}${NC}"
        fi
    fi
}

trap 'timer_start' DEBUG
PROMPT_COMMAND=timer_stop
PS1=""
add_ps1_block "\$(last_command_status)"
add_ps1_block " \$(last_command_time)"
add_ps1_block " \$(get_username_hostname) \$(get_working_dir)"
add_ps1_block " \$(git_branch)"
add_ps1_block " ${BLUE}󱃾 \$(kubernetes_context)${NC} |\$(kubernetes_namespace)"
add_ps1_block " \n"
add_ps1_block "\$(date +'%H:%M:%S')   ~> "
