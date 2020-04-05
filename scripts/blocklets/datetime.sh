#!/bin/sh

date="$(date "+%H:%M %d/%m")"

color="$PRIMARY_COLOR"

printf "<span color='%s'>%s</span>\n" \
    "$color" \
    "$date"
