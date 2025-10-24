#!/usr/bin/env bash

cd() {
  builtin cd "$@" || return
  # no zellij
  [[ -z "$ZELLIJ" ]] && return

  local repo
  repo="$(git remote -v 2>/dev/null | grep fetch | awk '{print $2}' | cut -d: -f2- | sed -e 's/.git//' | tr '[:upper:]' '[:lower:]')"
  {
    if [[ -n "$repo" ]]; then
      zellij action rename-tab "repo: $repo"
    else
      zellij action rename-tab "$(basename "$PWD")"
    fi
  } >/dev/null 2>&1 &
  disown # avoid job complete notification
}
