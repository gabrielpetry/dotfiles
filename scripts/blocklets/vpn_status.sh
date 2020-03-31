#!/bin/bash


color='white'

[ -n "$(pgrep openvpn && echo 1)" ] && color="$($SCRIPTS_DIR/getColor.sh magenta)"
printf "<span color='%s'>%s</span>\n" \
    "${color}" \
    " "
