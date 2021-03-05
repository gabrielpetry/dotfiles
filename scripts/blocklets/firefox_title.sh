#!/bin/bash

color="white"

title="$(wmctrl -l | grep '\- Mozilla Firefox' | awk '{$1=$2=$3=""}1'  | sed 's/\-\ Mozilla\ Firefox//g;s/^\s*//g')"

echo $title | grep -Eq "\([0-9]+\)" && color=$PRIMARY_COLOR
printf "<span color='%s' font-family='Font Awesome 5 Free'>%s</span>\n" \
    "${color}" \
    "$title"
