#!/bin/bash
# shellcheck source=/dev/null

FUNCTIONS_FILE="$HOME/.functions"
REPOS_CSV="$HOME/petryfiles/packages/repositories_to_manage.csv"

SourceFunctionsFile() {
    if ! source "${FUNCTIONS_FILE}"; then
        echo "Functions file not found"
        exit 1
    fi
    return 0
}

AutoCommit() {
    OLDIFS=$IFS

    while IFS=, read -r commands url path comment; do
        # cd into the dir
        cd "${HOME}/${path}" || exit 1
        # Auto commit
        echo "${RED}--- Auto commiting repository ---${NC}"
        if [[ "${commands}" == "push-pull" ]]; then
            fastCommit --m="Auto commit $(date)"
        elif [[ "${commands}" == "pull" ]]; then
            fastCommit --m="Auto commit $(date)" nopush
        fi
        # print a message
        printf "Commited to repository:\n %s" \
            "${comment}"

    done < "${REPOS_CSV}"


    IFS=$OLDIFS
}

Main() {
    SourceFunctionsFile
    AutoCommit
}

Main
