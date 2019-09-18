#!/bin/sh

color="$1"
code=""

case "$color" in
  "blue")
    code=12
    ;;
  "magenta")
    code=13
    ;;
  "red")
    code=9
    ;;
  "black")
    code=8
    ;;
  "green")
    code=10
    ;;
  "yellow")
    code=11
    ;;
  "cyan")
    code=14
    ;;
  *)
    code=15
esac

awk -v code="*.color${code}:" '$1== code {print $2}' "$HOME/.Xresources"
