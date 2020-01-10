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
    isOrg="$2"

    while read repo_url; do
        destination_dir="${folder}"

        if [[ -n "$isOrg" ]]; then
            destination_dir="${folder}/${isOrg}"
        fi

        mkdir -p "$destination_dir"

        repo_name="$(echo $repo_url | cut -d'/' -f2 | cut -d'.' -f1)"
        destination_dir="${destination_dir}/$repo_name"
        if [[ -d "${destination_dir}" ]]; then
            echo "Repository already cloned"
        else
            git clone "${repo_url}" "$destination_dir"
        fi
    done

}



# getRepos gabrielpetry
getOrgRepos Songgyy | \
    cloneRepos "$HOME/Projetos" Songgyy

getRepos gabrielpetry | \
    cloneRepos "$HOME/Projetos"
