#!/bin/sh

date="$(date "+%H:%M:%S %d/%m")"

color="$PRIMARY_COLOR"

printf "<span color='%s'>%s</span>\n" \
    "$color" \
    "$date"
