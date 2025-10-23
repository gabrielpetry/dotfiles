# bash completion for k3d                                  -*- shell-script -*-

__k3d_debug()
{
    if [[ -n ${BASH_COMP_DEBUG_FILE:-} ]]; then
        echo "$*" >> "${BASH_COMP_DEBUG_FILE}"
    fi
}

# Homebrew on Macs have version 1.3 of bash-completion which doesn't include
# _init_completion. This is a very minimal version of that function.
__k3d_init_completion()
{
    COMPREPLY=()
    _get_comp_words_by_ref "$@" cur prev words cword
}

__k3d_index_of_word()
{
    local w word=$1
    shift
    index=0
    for w in "$@"; do
        [[ $w = "$word" ]] && return
        index=$((index+1))
    done
    index=-1
}

__k3d_contains_word()
{
    local w word=$1; shift
    for w in "$@"; do
        [[ $w = "$word" ]] && return
    done
    return 1
}

__k3d_handle_go_custom_completion()
{
    __k3d_debug "${FUNCNAME[0]}: cur is ${cur}, words[*] is ${words[*]}, #words[@] is ${#words[@]}"

    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local out requestComp lastParam lastChar comp directive args

    # Prepare the command to request completions for the program.
    # Calling ${words[0]} instead of directly k3d allows handling aliases
    args=("${words[@]:1}")
    # Disable ActiveHelp which is not supported for bash completion v1
    requestComp="K3D_ACTIVE_HELP=0 ${words[0]} __completeNoDesc ${args[*]}"

    lastParam=${words[$((${#words[@]}-1))]}
    lastChar=${lastParam:$((${#lastParam}-1)):1}
    __k3d_debug "${FUNCNAME[0]}: lastParam ${lastParam}, lastChar ${lastChar}"

    if [ -z "${cur}" ] && [ "${lastChar}" != "=" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go method.
        __k3d_debug "${FUNCNAME[0]}: Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __k3d_debug "${FUNCNAME[0]}: calling ${requestComp}"
    # Use eval to handle any environment variables and such
    out=$(eval "${requestComp}" 2>/dev/null)

    # Extract the directive integer at the very end of the output following a colon (:)
    directive=${out##*:}
    # Remove the directive
    out=${out%:*}
    if [ "${directive}" = "${out}" ]; then
        # There is not directive specified
        directive=0
    fi
    __k3d_debug "${FUNCNAME[0]}: the completion directive is: ${directive}"
    __k3d_debug "${FUNCNAME[0]}: the completions are: ${out}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        # Error code.  No completion.
        __k3d_debug "${FUNCNAME[0]}: received error from custom completion go code"
        return
    else
        if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
            if [[ $(type -t compopt) = "builtin" ]]; then
                __k3d_debug "${FUNCNAME[0]}: activating no space"
                compopt -o nospace
            fi
        fi
        if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
            if [[ $(type -t compopt) = "builtin" ]]; then
                __k3d_debug "${FUNCNAME[0]}: activating no file completion"
                compopt +o default
            fi
        fi
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local fullFilter filter filteringCmd
        # Do not use quotes around the $out variable or else newline
        # characters will be kept.
        for filter in ${out}; do
            fullFilter+="$filter|"
        done

        filteringCmd="_filedir $fullFilter"
        __k3d_debug "File filtering command: $filteringCmd"
        $filteringCmd
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        # Use printf to strip any trailing newline
        subdir=$(printf "%s" "${out}")
        if [ -n "$subdir" ]; then
            __k3d_debug "Listing directories in $subdir"
            __k3d_handle_subdirs_in_dir_flag "$subdir"
        else
            __k3d_debug "Listing directories in ."
            _filedir -d
        fi
    else
        while IFS='' read -r comp; do
            COMPREPLY+=("$comp")
        done < <(compgen -W "${out}" -- "$cur")
    fi
}

__k3d_handle_reply()
{
    __k3d_debug "${FUNCNAME[0]}"
    local comp
    case $cur in
        -*)
            if [[ $(type -t compopt) = "builtin" ]]; then
                compopt -o nospace
            fi
            local allflags
            if [ ${#must_have_one_flag[@]} -ne 0 ]; then
                allflags=("${must_have_one_flag[@]}")
            else
                allflags=("${flags[*]} ${two_word_flags[*]}")
            fi
            while IFS='' read -r comp; do
                COMPREPLY+=("$comp")
            done < <(compgen -W "${allflags[*]}" -- "$cur")
            if [[ $(type -t compopt) = "builtin" ]]; then
                [[ "${COMPREPLY[0]}" == *= ]] || compopt +o nospace
            fi

            # complete after --flag=abc
            if [[ $cur == *=* ]]; then
                if [[ $(type -t compopt) = "builtin" ]]; then
                    compopt +o nospace
                fi

                local index flag
                flag="${cur%=*}"
                __k3d_index_of_word "${flag}" "${flags_with_completion[@]}"
                COMPREPLY=()
                if [[ ${index} -ge 0 ]]; then
                    PREFIX=""
                    cur="${cur#*=}"
                    ${flags_completion[${index}]}
                    if [ -n "${ZSH_VERSION:-}" ]; then
                        # zsh completion needs --flag= prefix
                        eval "COMPREPLY=( \"\${COMPREPLY[@]/#/${flag}=}\" )"
                    fi
                fi
            fi

            if [[ -z "${flag_parsing_disabled}" ]]; then
                # If flag parsing is enabled, we have completed the flags and can return.
                # If flag parsing is disabled, we may not know all (or any) of the flags, so we fallthrough
                # to possibly call handle_go_custom_completion.
                return 0;
            fi
            ;;
    esac

    # check if we are handling a flag with special work handling
    local index
    __k3d_index_of_word "${prev}" "${flags_with_completion[@]}"
    if [[ ${index} -ge 0 ]]; then
        ${flags_completion[${index}]}
        return
    fi

    # we are parsing a flag and don't have a special handler, no completion
    if [[ ${cur} != "${words[cword]}" ]]; then
        return
    fi

    local completions
    completions=("${commands[@]}")
    if [[ ${#must_have_one_noun[@]} -ne 0 ]]; then
        completions+=("${must_have_one_noun[@]}")
    elif [[ -n "${has_completion_function}" ]]; then
        # if a go completion function is provided, defer to that function
        __k3d_handle_go_custom_completion
    fi
    if [[ ${#must_have_one_flag[@]} -ne 0 ]]; then
        completions+=("${must_have_one_flag[@]}")
    fi
    while IFS='' read -r comp; do
        COMPREPLY+=("$comp")
    done < <(compgen -W "${completions[*]}" -- "$cur")

    if [[ ${#COMPREPLY[@]} -eq 0 && ${#noun_aliases[@]} -gt 0 && ${#must_have_one_noun[@]} -ne 0 ]]; then
        while IFS='' read -r comp; do
            COMPREPLY+=("$comp")
        done < <(compgen -W "${noun_aliases[*]}" -- "$cur")
    fi

    if [[ ${#COMPREPLY[@]} -eq 0 ]]; then
        if declare -F __k3d_custom_func >/dev/null; then
            # try command name qualified custom func
            __k3d_custom_func
        else
            # otherwise fall back to unqualified for compatibility
            declare -F __custom_func >/dev/null && __custom_func
        fi
    fi

    # available in bash-completion >= 2, not always present on macOS
    if declare -F __ltrim_colon_completions >/dev/null; then
        __ltrim_colon_completions "$cur"
    fi

    # If there is only 1 completion and it is a flag with an = it will be completed
    # but we don't want a space after the =
    if [[ "${#COMPREPLY[@]}" -eq "1" ]] && [[ $(type -t compopt) = "builtin" ]] && [[ "${COMPREPLY[0]}" == --*= ]]; then
       compopt -o nospace
    fi
}

# The arguments should be in the form "ext1|ext2|extn"
__k3d_handle_filename_extension_flag()
{
    local ext="$1"
    _filedir "@(${ext})"
}

__k3d_handle_subdirs_in_dir_flag()
{
    local dir="$1"
    pushd "${dir}" >/dev/null 2>&1 && _filedir -d && popd >/dev/null 2>&1 || return
}

__k3d_handle_flag()
{
    __k3d_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    # if a command required a flag, and we found it, unset must_have_one_flag()
    local flagname=${words[c]}
    local flagvalue=""
    # if the word contained an =
    if [[ ${words[c]} == *"="* ]]; then
        flagvalue=${flagname#*=} # take in as flagvalue after the =
        flagname=${flagname%=*} # strip everything after the =
        flagname="${flagname}=" # but put the = back
    fi
    __k3d_debug "${FUNCNAME[0]}: looking for ${flagname}"
    if __k3d_contains_word "${flagname}" "${must_have_one_flag[@]}"; then
        must_have_one_flag=()
    fi

    # if you set a flag which only applies to this command, don't show subcommands
    if __k3d_contains_word "${flagname}" "${local_nonpersistent_flags[@]}"; then
      commands=()
    fi

    # keep flag value with flagname as flaghash
    # flaghash variable is an associative array which is only supported in bash > 3.
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        if [ -n "${flagvalue}" ] ; then
            flaghash[${flagname}]=${flagvalue}
        elif [ -n "${words[ $((c+1)) ]}" ] ; then
            flaghash[${flagname}]=${words[ $((c+1)) ]}
        else
            flaghash[${flagname}]="true" # pad "true" for bool flag
        fi
    fi

    # skip the argument to a two word flag
    if [[ ${words[c]} != *"="* ]] && __k3d_contains_word "${words[c]}" "${two_word_flags[@]}"; then
        __k3d_debug "${FUNCNAME[0]}: found a flag ${words[c]}, skip the next argument"
        c=$((c+1))
        # if we are looking for a flags value, don't show commands
        if [[ $c -eq $cword ]]; then
            commands=()
        fi
    fi

    c=$((c+1))

}

__k3d_handle_noun()
{
    __k3d_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    if __k3d_contains_word "${words[c]}" "${must_have_one_noun[@]}"; then
        must_have_one_noun=()
    elif __k3d_contains_word "${words[c]}" "${noun_aliases[@]}"; then
        must_have_one_noun=()
    fi

    nouns+=("${words[c]}")
    c=$((c+1))
}

__k3d_handle_command()
{
    __k3d_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    local next_command
    if [[ -n ${last_command} ]]; then
        next_command="_${last_command}_${words[c]//:/__}"
    else
        if [[ $c -eq 0 ]]; then
            next_command="_k3d_root_command"
        else
            next_command="_${words[c]//:/__}"
        fi
    fi
    c=$((c+1))
    __k3d_debug "${FUNCNAME[0]}: looking for ${next_command}"
    declare -F "$next_command" >/dev/null && $next_command
}

__k3d_handle_word()
{
    if [[ $c -ge $cword ]]; then
        __k3d_handle_reply
        return
    fi
    __k3d_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"
    if [[ "${words[c]}" == -* ]]; then
        __k3d_handle_flag
    elif __k3d_contains_word "${words[c]}" "${commands[@]}"; then
        __k3d_handle_command
    elif [[ $c -eq 0 ]]; then
        __k3d_handle_command
    elif __k3d_contains_word "${words[c]}" "${command_aliases[@]}"; then
        # aliashash variable is an associative array which is only supported in bash > 3.
        if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
            words[c]=${aliashash[${words[c]}]}
            __k3d_handle_command
        else
            __k3d_handle_noun
        fi
    else
        __k3d_handle_noun
    fi
    __k3d_handle_word
}

_k3d_cluster_create()
{
    last_command="k3d_cluster_create"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--agents=")
    two_word_flags+=("--agents")
    two_word_flags+=("-a")
    local_nonpersistent_flags+=("--agents")
    local_nonpersistent_flags+=("--agents=")
    local_nonpersistent_flags+=("-a")
    flags+=("--agents-memory=")
    two_word_flags+=("--agents-memory")
    local_nonpersistent_flags+=("--agents-memory")
    local_nonpersistent_flags+=("--agents-memory=")
    flags+=("--api-port=")
    two_word_flags+=("--api-port")
    local_nonpersistent_flags+=("--api-port")
    local_nonpersistent_flags+=("--api-port=")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__k3d_handle_filename_extension_flag yaml|yml")
    two_word_flags+=("-c")
    flags_with_completion+=("-c")
    flags_completion+=("__k3d_handle_filename_extension_flag yaml|yml")
    local_nonpersistent_flags+=("--config")
    local_nonpersistent_flags+=("--config=")
    local_nonpersistent_flags+=("-c")
    flags+=("--env=")
    two_word_flags+=("--env")
    two_word_flags+=("-e")
    local_nonpersistent_flags+=("--env")
    local_nonpersistent_flags+=("--env=")
    local_nonpersistent_flags+=("-e")
    flags+=("--gpus=")
    two_word_flags+=("--gpus")
    local_nonpersistent_flags+=("--gpus")
    local_nonpersistent_flags+=("--gpus=")
    flags+=("--host-alias=")
    two_word_flags+=("--host-alias")
    local_nonpersistent_flags+=("--host-alias")
    local_nonpersistent_flags+=("--host-alias=")
    flags+=("--host-pid-mode")
    local_nonpersistent_flags+=("--host-pid-mode")
    flags+=("--image=")
    two_word_flags+=("--image")
    two_word_flags+=("-i")
    local_nonpersistent_flags+=("--image")
    local_nonpersistent_flags+=("--image=")
    local_nonpersistent_flags+=("-i")
    flags+=("--k3s-arg=")
    two_word_flags+=("--k3s-arg")
    local_nonpersistent_flags+=("--k3s-arg")
    local_nonpersistent_flags+=("--k3s-arg=")
    flags+=("--k3s-node-label=")
    two_word_flags+=("--k3s-node-label")
    local_nonpersistent_flags+=("--k3s-node-label")
    local_nonpersistent_flags+=("--k3s-node-label=")
    flags+=("--kubeconfig-switch-context")
    local_nonpersistent_flags+=("--kubeconfig-switch-context")
    flags+=("--kubeconfig-update-default")
    local_nonpersistent_flags+=("--kubeconfig-update-default")
    flags+=("--lb-config-override=")
    two_word_flags+=("--lb-config-override")
    local_nonpersistent_flags+=("--lb-config-override")
    local_nonpersistent_flags+=("--lb-config-override=")
    flags+=("--network=")
    two_word_flags+=("--network")
    local_nonpersistent_flags+=("--network")
    local_nonpersistent_flags+=("--network=")
    flags+=("--no-image-volume")
    local_nonpersistent_flags+=("--no-image-volume")
    flags+=("--no-lb")
    local_nonpersistent_flags+=("--no-lb")
    flags+=("--no-rollback")
    local_nonpersistent_flags+=("--no-rollback")
    flags+=("--port=")
    two_word_flags+=("--port")
    two_word_flags+=("-p")
    local_nonpersistent_flags+=("--port")
    local_nonpersistent_flags+=("--port=")
    local_nonpersistent_flags+=("-p")
    flags+=("--registry-config=")
    two_word_flags+=("--registry-config")
    flags_with_completion+=("--registry-config")
    flags_completion+=("__k3d_handle_filename_extension_flag yaml|yml")
    local_nonpersistent_flags+=("--registry-config")
    local_nonpersistent_flags+=("--registry-config=")
    flags+=("--registry-create=")
    two_word_flags+=("--registry-create")
    local_nonpersistent_flags+=("--registry-create")
    local_nonpersistent_flags+=("--registry-create=")
    flags+=("--registry-use=")
    two_word_flags+=("--registry-use")
    local_nonpersistent_flags+=("--registry-use")
    local_nonpersistent_flags+=("--registry-use=")
    flags+=("--runtime-label=")
    two_word_flags+=("--runtime-label")
    local_nonpersistent_flags+=("--runtime-label")
    local_nonpersistent_flags+=("--runtime-label=")
    flags+=("--runtime-ulimit=")
    two_word_flags+=("--runtime-ulimit")
    local_nonpersistent_flags+=("--runtime-ulimit")
    local_nonpersistent_flags+=("--runtime-ulimit=")
    flags+=("--servers=")
    two_word_flags+=("--servers")
    two_word_flags+=("-s")
    local_nonpersistent_flags+=("--servers")
    local_nonpersistent_flags+=("--servers=")
    local_nonpersistent_flags+=("-s")
    flags+=("--servers-memory=")
    two_word_flags+=("--servers-memory")
    local_nonpersistent_flags+=("--servers-memory")
    local_nonpersistent_flags+=("--servers-memory=")
    flags+=("--subnet=")
    two_word_flags+=("--subnet")
    local_nonpersistent_flags+=("--subnet")
    local_nonpersistent_flags+=("--subnet=")
    flags+=("--timeout=")
    two_word_flags+=("--timeout")
    local_nonpersistent_flags+=("--timeout")
    local_nonpersistent_flags+=("--timeout=")
    flags+=("--token=")
    two_word_flags+=("--token")
    local_nonpersistent_flags+=("--token")
    local_nonpersistent_flags+=("--token=")
    flags+=("--volume=")
    two_word_flags+=("--volume")
    two_word_flags+=("-v")
    local_nonpersistent_flags+=("--volume")
    local_nonpersistent_flags+=("--volume=")
    local_nonpersistent_flags+=("-v")
    flags+=("--wait")
    local_nonpersistent_flags+=("--wait")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_k3d_cluster_delete()
{
    last_command="k3d_cluster_delete"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    flags+=("-a")
    local_nonpersistent_flags+=("--all")
    local_nonpersistent_flags+=("-a")
    flags+=("--config=")
    two_word_flags+=("--config")
    flags_with_completion+=("--config")
    flags_completion+=("__k3d_handle_filename_extension_flag yaml|yml")
    two_word_flags+=("-c")
    flags_with_completion+=("-c")
    flags_completion+=("__k3d_handle_filename_extension_flag yaml|yml")
    local_nonpersistent_flags+=("--config")
    local_nonpersistent_flags+=("--config=")
    local_nonpersistent_flags+=("-c")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_cluster_edit()
{
    last_command="k3d_cluster_edit"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--port-add=")
    two_word_flags+=("--port-add")
    local_nonpersistent_flags+=("--port-add")
    local_nonpersistent_flags+=("--port-add=")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_cluster_list()
{
    last_command="k3d_cluster_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--no-headers")
    local_nonpersistent_flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--token")
    local_nonpersistent_flags+=("--token")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_cluster_start()
{
    last_command="k3d_cluster_start"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    flags+=("-a")
    local_nonpersistent_flags+=("--all")
    local_nonpersistent_flags+=("-a")
    flags+=("--timeout=")
    two_word_flags+=("--timeout")
    local_nonpersistent_flags+=("--timeout")
    local_nonpersistent_flags+=("--timeout=")
    flags+=("--wait")
    local_nonpersistent_flags+=("--wait")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_cluster_stop()
{
    last_command="k3d_cluster_stop"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    flags+=("-a")
    local_nonpersistent_flags+=("--all")
    local_nonpersistent_flags+=("-a")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_cluster()
{
    last_command="k3d_cluster"

    command_aliases=()

    commands=()
    commands+=("create")
    commands+=("delete")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("del")
        aliashash["del"]="delete"
        command_aliases+=("rm")
        aliashash["rm"]="delete"
    fi
    commands+=("edit")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("update")
        aliashash["update"]="edit"
    fi
    commands+=("list")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("get")
        aliashash["get"]="list"
        command_aliases+=("ls")
        aliashash["ls"]="list"
    fi
    commands+=("start")
    commands+=("stop")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_k3d_completion()
{
    last_command="k3d_completion"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")
    local_nonpersistent_flags+=("--help")
    local_nonpersistent_flags+=("-h")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    must_have_one_noun+=("bash")
    must_have_one_noun+=("fish")
    must_have_one_noun+=("powershell")
    must_have_one_noun+=("zsh")
    noun_aliases=()
    noun_aliases+=("psh")
}

_k3d_config_init()
{
    last_command="k3d_config_init"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--force")
    flags+=("-f")
    local_nonpersistent_flags+=("--force")
    local_nonpersistent_flags+=("-f")
    flags+=("--output=")
    two_word_flags+=("--output")
    flags_with_completion+=("--output")
    flags_completion+=("__k3d_handle_filename_extension_flag yaml|yml")
    two_word_flags+=("-o")
    flags_with_completion+=("-o")
    flags_completion+=("__k3d_handle_filename_extension_flag yaml|yml")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_k3d_config_migrate()
{
    last_command="k3d_config_migrate"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_k3d_config()
{
    last_command="k3d_config"

    command_aliases=()

    commands=()
    commands+=("init")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("create")
        aliashash["create"]="init"
    fi
    commands+=("migrate")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("update")
        aliashash["update"]="migrate"
    fi

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_k3d_help()
{
    last_command="k3d_help"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_image_import()
{
    last_command="k3d_image_import"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--cluster=")
    two_word_flags+=("--cluster")
    flags_with_completion+=("--cluster")
    flags_completion+=("__k3d_handle_go_custom_completion")
    two_word_flags+=("-c")
    flags_with_completion+=("-c")
    flags_completion+=("__k3d_handle_go_custom_completion")
    local_nonpersistent_flags+=("--cluster")
    local_nonpersistent_flags+=("--cluster=")
    local_nonpersistent_flags+=("-c")
    flags+=("--keep-tarball")
    flags+=("-k")
    local_nonpersistent_flags+=("--keep-tarball")
    local_nonpersistent_flags+=("-k")
    flags+=("--keep-tools")
    flags+=("-t")
    local_nonpersistent_flags+=("--keep-tools")
    local_nonpersistent_flags+=("-t")
    flags+=("--mode=")
    two_word_flags+=("--mode")
    two_word_flags+=("-m")
    local_nonpersistent_flags+=("--mode")
    local_nonpersistent_flags+=("--mode=")
    local_nonpersistent_flags+=("-m")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_k3d_image()
{
    last_command="k3d_image"

    command_aliases=()

    commands=()
    commands+=("import")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("load")
        aliashash["load"]="import"
    fi

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_k3d_kubeconfig_get()
{
    last_command="k3d_kubeconfig_get"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    flags+=("-a")
    local_nonpersistent_flags+=("--all")
    local_nonpersistent_flags+=("-a")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_kubeconfig_merge()
{
    last_command="k3d_kubeconfig_merge"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    flags+=("-a")
    local_nonpersistent_flags+=("--all")
    local_nonpersistent_flags+=("-a")
    flags+=("--kubeconfig-merge-default")
    flags+=("-d")
    local_nonpersistent_flags+=("--kubeconfig-merge-default")
    local_nonpersistent_flags+=("-d")
    flags+=("--kubeconfig-switch-context")
    flags+=("-s")
    local_nonpersistent_flags+=("--kubeconfig-switch-context")
    local_nonpersistent_flags+=("-s")
    flags+=("--output=")
    two_word_flags+=("--output")
    flags_with_completion+=("--output")
    flags_completion+=("_filedir")
    two_word_flags+=("-o")
    flags_with_completion+=("-o")
    flags_completion+=("_filedir")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--overwrite")
    local_nonpersistent_flags+=("--overwrite")
    flags+=("--update")
    flags+=("-u")
    local_nonpersistent_flags+=("--update")
    local_nonpersistent_flags+=("-u")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_kubeconfig()
{
    last_command="k3d_kubeconfig"

    command_aliases=()

    commands=()
    commands+=("get")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("print")
        aliashash["print"]="get"
        command_aliases+=("show")
        aliashash["show"]="get"
    fi
    commands+=("merge")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("write")
        aliashash["write"]="merge"
    fi

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_k3d_node_create()
{
    last_command="k3d_node_create"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--cluster=")
    two_word_flags+=("--cluster")
    flags_with_completion+=("--cluster")
    flags_completion+=("__k3d_handle_go_custom_completion")
    two_word_flags+=("-c")
    flags_with_completion+=("-c")
    flags_completion+=("__k3d_handle_go_custom_completion")
    local_nonpersistent_flags+=("--cluster")
    local_nonpersistent_flags+=("--cluster=")
    local_nonpersistent_flags+=("-c")
    flags+=("--image=")
    two_word_flags+=("--image")
    two_word_flags+=("-i")
    local_nonpersistent_flags+=("--image")
    local_nonpersistent_flags+=("--image=")
    local_nonpersistent_flags+=("-i")
    flags+=("--k3s-arg=")
    two_word_flags+=("--k3s-arg")
    local_nonpersistent_flags+=("--k3s-arg")
    local_nonpersistent_flags+=("--k3s-arg=")
    flags+=("--k3s-node-label=")
    two_word_flags+=("--k3s-node-label")
    local_nonpersistent_flags+=("--k3s-node-label")
    local_nonpersistent_flags+=("--k3s-node-label=")
    flags+=("--memory=")
    two_word_flags+=("--memory")
    local_nonpersistent_flags+=("--memory")
    local_nonpersistent_flags+=("--memory=")
    flags+=("--network=")
    two_word_flags+=("--network")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--network")
    local_nonpersistent_flags+=("--network=")
    local_nonpersistent_flags+=("-n")
    flags+=("--replicas=")
    two_word_flags+=("--replicas")
    local_nonpersistent_flags+=("--replicas")
    local_nonpersistent_flags+=("--replicas=")
    flags+=("--role=")
    two_word_flags+=("--role")
    flags_with_completion+=("--role")
    flags_completion+=("__k3d_handle_go_custom_completion")
    local_nonpersistent_flags+=("--role")
    local_nonpersistent_flags+=("--role=")
    flags+=("--runtime-label=")
    two_word_flags+=("--runtime-label")
    local_nonpersistent_flags+=("--runtime-label")
    local_nonpersistent_flags+=("--runtime-label=")
    flags+=("--runtime-ulimit=")
    two_word_flags+=("--runtime-ulimit")
    local_nonpersistent_flags+=("--runtime-ulimit")
    local_nonpersistent_flags+=("--runtime-ulimit=")
    flags+=("--timeout=")
    two_word_flags+=("--timeout")
    local_nonpersistent_flags+=("--timeout")
    local_nonpersistent_flags+=("--timeout=")
    flags+=("--token=")
    two_word_flags+=("--token")
    two_word_flags+=("-t")
    local_nonpersistent_flags+=("--token")
    local_nonpersistent_flags+=("--token=")
    local_nonpersistent_flags+=("-t")
    flags+=("--wait")
    local_nonpersistent_flags+=("--wait")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_k3d_node_delete()
{
    last_command="k3d_node_delete"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    flags+=("-a")
    local_nonpersistent_flags+=("--all")
    local_nonpersistent_flags+=("-a")
    flags+=("--registries")
    flags+=("-r")
    local_nonpersistent_flags+=("--registries")
    local_nonpersistent_flags+=("-r")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_node_edit()
{
    last_command="k3d_node_edit"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--port-add=")
    two_word_flags+=("--port-add")
    local_nonpersistent_flags+=("--port-add")
    local_nonpersistent_flags+=("--port-add=")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_node_list()
{
    last_command="k3d_node_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--no-headers")
    local_nonpersistent_flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_node_start()
{
    last_command="k3d_node_start"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_node_stop()
{
    last_command="k3d_node_stop"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_node()
{
    last_command="k3d_node"

    command_aliases=()

    commands=()
    commands+=("create")
    commands+=("delete")
    commands+=("edit")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("update")
        aliashash["update"]="edit"
    fi
    commands+=("list")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("get")
        aliashash["get"]="list"
        command_aliases+=("ls")
        aliashash["ls"]="list"
    fi
    commands+=("start")
    commands+=("stop")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_k3d_registry_create()
{
    last_command="k3d_registry_create"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--default-network=")
    two_word_flags+=("--default-network")
    local_nonpersistent_flags+=("--default-network")
    local_nonpersistent_flags+=("--default-network=")
    flags+=("--delete-enabled")
    local_nonpersistent_flags+=("--delete-enabled")
    flags+=("--image=")
    two_word_flags+=("--image")
    two_word_flags+=("-i")
    local_nonpersistent_flags+=("--image")
    local_nonpersistent_flags+=("--image=")
    local_nonpersistent_flags+=("-i")
    flags+=("--no-help")
    local_nonpersistent_flags+=("--no-help")
    flags+=("--port=")
    two_word_flags+=("--port")
    two_word_flags+=("-p")
    local_nonpersistent_flags+=("--port")
    local_nonpersistent_flags+=("--port=")
    local_nonpersistent_flags+=("-p")
    flags+=("--proxy-password=")
    two_word_flags+=("--proxy-password")
    local_nonpersistent_flags+=("--proxy-password")
    local_nonpersistent_flags+=("--proxy-password=")
    flags+=("--proxy-remote-url=")
    two_word_flags+=("--proxy-remote-url")
    local_nonpersistent_flags+=("--proxy-remote-url")
    local_nonpersistent_flags+=("--proxy-remote-url=")
    flags+=("--proxy-username=")
    two_word_flags+=("--proxy-username")
    local_nonpersistent_flags+=("--proxy-username")
    local_nonpersistent_flags+=("--proxy-username=")
    flags+=("--volume=")
    two_word_flags+=("--volume")
    two_word_flags+=("-v")
    local_nonpersistent_flags+=("--volume")
    local_nonpersistent_flags+=("--volume=")
    local_nonpersistent_flags+=("-v")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_k3d_registry_delete()
{
    last_command="k3d_registry_delete"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    flags+=("-a")
    local_nonpersistent_flags+=("--all")
    local_nonpersistent_flags+=("-a")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_registry_list()
{
    last_command="k3d_registry_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--no-headers")
    local_nonpersistent_flags+=("--no-headers")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_k3d_registry()
{
    last_command="k3d_registry"

    command_aliases=()

    commands=()
    commands+=("create")
    commands+=("delete")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("del")
        aliashash["del"]="delete"
        command_aliases+=("rm")
        aliashash["rm"]="delete"
    fi
    commands+=("list")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("get")
        aliashash["get"]="list"
        command_aliases+=("ls")
        aliashash["ls"]="list"
    fi

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_k3d_version_list()
{
    last_command="k3d_version_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--exclude=")
    two_word_flags+=("--exclude")
    two_word_flags+=("-e")
    local_nonpersistent_flags+=("--exclude")
    local_nonpersistent_flags+=("--exclude=")
    local_nonpersistent_flags+=("-e")
    flags+=("--format=")
    two_word_flags+=("--format")
    two_word_flags+=("-f")
    local_nonpersistent_flags+=("--format")
    local_nonpersistent_flags+=("--format=")
    local_nonpersistent_flags+=("-f")
    flags+=("--include=")
    two_word_flags+=("--include")
    two_word_flags+=("-i")
    local_nonpersistent_flags+=("--include")
    local_nonpersistent_flags+=("--include=")
    local_nonpersistent_flags+=("-i")
    flags+=("--limit=")
    two_word_flags+=("--limit")
    two_word_flags+=("-l")
    local_nonpersistent_flags+=("--limit")
    local_nonpersistent_flags+=("--limit=")
    local_nonpersistent_flags+=("-l")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--sort=")
    two_word_flags+=("--sort")
    two_word_flags+=("-s")
    local_nonpersistent_flags+=("--sort")
    local_nonpersistent_flags+=("--sort=")
    local_nonpersistent_flags+=("-s")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    must_have_one_noun+=("k3d")
    must_have_one_noun+=("k3d-proxy")
    must_have_one_noun+=("k3d-tools")
    must_have_one_noun+=("k3s")
    noun_aliases=()
}

_k3d_version()
{
    last_command="k3d_version"

    command_aliases=()

    commands=()
    commands+=("list")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("ls")
        aliashash["ls"]="list"
    fi

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_k3d_root_command()
{
    last_command="k3d"

    command_aliases=()

    commands=()
    commands+=("cluster")
    commands+=("completion")
    commands+=("config")
    commands+=("help")
    commands+=("image")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("images")
        aliashash["images"]="image"
    fi
    commands+=("kubeconfig")
    commands+=("node")
    commands+=("registry")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("reg")
        aliashash["reg"]="registry"
        command_aliases+=("registries")
        aliashash["registries"]="registry"
    fi
    commands+=("version")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--timestamps")
    flags+=("--trace")
    flags+=("--verbose")
    flags+=("--version")
    local_nonpersistent_flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

__start_k3d()
{
    local cur prev words cword split
    declare -A flaghash 2>/dev/null || :
    declare -A aliashash 2>/dev/null || :
    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion -s || return
    else
        __k3d_init_completion -n "=" || return
    fi

    local c=0
    local flag_parsing_disabled=
    local flags=()
    local two_word_flags=()
    local local_nonpersistent_flags=()
    local flags_with_completion=()
    local flags_completion=()
    local commands=("k3d")
    local command_aliases=()
    local must_have_one_flag=()
    local must_have_one_noun=()
    local has_completion_function=""
    local last_command=""
    local nouns=()
    local noun_aliases=()

    __k3d_handle_word
}

if [[ $(type -t compopt) = "builtin" ]]; then
    complete -o default -F __start_k3d k3d
else
    complete -o default -o nospace -F __start_k3d k3d
fi

# ex: ts=4 sw=4 et filetype=sh
