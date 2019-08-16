#!/bin/bash

set -e

# checkChromiumIsInUse() {
#   players="$(playerctl --list-all)"
# }

main() {
  if playerctl --player=chromium status | grep -q "Playing\|Paused"; then
    artist="$(playerctl --player=chromium metadata artist | cut -c 1-15 )"
    title="$(playerctl --player=chromium metadata title | cut -c 1-20)"
    icon=""
    status=$(playerctl --player=chromium status)
  else
    icon=""
    artist="$(playerctl metadata artist | cut -c 1-15 )"
    title="$(playerctl metadata title | cut -c 1-20)"
    status=$(playerctl status)
  fi
  # icon=""
  background_color="#$(grep "color12" "${HOME}/.Xresources" | \
		      cut -d "#" -f2)"
  text_background="color='${background_color}'"
  if [ "$status" != "Playing" ]; then
    icon=""
    text_background=""
  fi
  if [ $? ] && [ -n "$artist$title" ]; then
    printf "<span %s>%s %s - %s</span>" \
      "${text_background}" \
      "${icon}" \
      "${artist}" \
      "$(echo "${title}" | tr -cs '[[a-zA-Z0-9]]' ' ')"
  fi
}
# case $BLOCK_BUTTON in
#     1) 
#       if playerctl --player=chromium status | grep -q "Playing\|Paused"; then
# 	playerctl -p chromium play-pause
# 	main "$@" 2>/dev/null
#       else 
# 	playerctl play-pause 
#       fi
#       ;;
#     2) playerctl play-pause ;;
# esac


main "$@" 2>/dev/null

