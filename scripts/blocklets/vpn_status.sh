#!/bin/bash


color='white'

[ -n "$(pgrep openvpn && echo 1)" ] && color='green'

printf "<span color='%s'>%s</span>\n" \
    "${color}" \
    " "
