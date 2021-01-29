#!/bin/zsh

gclone() {
  repo_url="$1"
  prefix="$(echo $repo_url | grep -Eo "github|gitlab|local")"
  root_folder="${2:-$HOME/Projects/}/$prefix"

  if [[ -z "$1" ]]; then
    echo "Empty repo url"
    exit 1
  fi



  repo_mainterner="$(echo $repo_url | \
    sed 's/\.git//g' | \
    rev | \
    cut -d'/' -f2 | \
    rev | \
    sed -E 's/git@((github)|(gitlab))\.com\://g')"

  repo_name="$(echo $repo_url | sed 's/\.git//g' | rev | cut -d'/' -f1 | rev)"

  mainter_dir="${root_folder}/$repo_mainterner"
  destination_dir="${root_folder}/$repo_mainterner/$repo_name"

  test -d "$mainter_dir" || mkdir -p "$mainter_dir"

  if [[ -d "${destination_dir}" ]]; then
      echo -ne "Repository already cloned\n"
  else
      echo -ne "Clonning repo $repo_url\n"
      git clone "${repo_url}" "$destination_dir"
  fi

  cd "${destination_dir}" #&& git fetch && git pull
}


export -f gclone