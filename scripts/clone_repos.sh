#!/bin/bash

github_api="https://api.github.com"

getRepos() {
    username="$1"
    repos="$(curl -Ss "${github_api}/users/${username}/repos")"
    echo "$repos" | \
        grep ssh_url | \
        cut -d'"' -f4
}


getOrgRepos() {
    org="$1"
    repos="$(curl -Ss "${github_api}/orgs/${org}/repos")"
    echo "$repos" | \
        grep ssh_url | \
        cut -d '"' -f4
}

cloneRepos() {
    folder="$1"
    [[ -z "$folder" ]] && echo  "Can't proced without an destination folder" && exit
    # destination="$2"
    repo_url="$2"

    destination_dir="${folder}"

    # if [[ -n "$destination" ]]; then
    #     destination_dir="${folder}/${destination}"
    # fi

    # mkdir -p "$destination_dir"

    repo_name="$(echo $repo_url | cut -d':' -f2 | cut -d'.' -f1 )"
    destination_dir="${destination_dir}/$repo_name"
    if [[ -d "${destination_dir}" ]]; then
        echo "Repository already cloned"
    else
        echo -n "Clonning repo $repo_url"
        git clone "${repo_url}" "$destination_dir"
    fi

}

export -f cloneRepos

preferDirectory="$1" # ./script 'Projetos'

[ -z "$preferDirectory" ] && preferDirectory="Projects/github"

getOrgRepos Songgyy | \
    parallel -n $(nproc) -I{} cloneRepos "${HOME}/${preferDirectory}" {}

getRepos gabrielpetry | \
    parallel -n $(nproc) -I{} cloneRepos "${HOME}/${preferDirectory}" {}
