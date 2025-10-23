#!/usr/bin/env bash
fawk() {
  awk "{print \$$*}"
}

fcut() {

  if [ "$#" -ne 2 ]; then
    echo "Usage: fcut <delimiter> <position>"
    exit 1
  fi

  delimiter="$1"
  position="$2"

  echo

  cut -d"$delimiter" -f"$position"
}

ff() {

  file_name="$1"
  shift
  find . -name "$file_name" "$@"
}

fw() {
  interval="$1"
  shift

  while true; do
    "$@"
    sleep "$interval"
  done
}
