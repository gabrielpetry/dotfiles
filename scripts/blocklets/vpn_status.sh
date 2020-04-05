#!/bin/bash


color='white'

[ -n "$(pgrep openvpn && echo 1)" ] && color="$PRIMARY_COLOR"
printf "<span color='%s' font-family='Font Awesome 5 Free'>%s</span>\n" \
    "${color}" \
    " "
