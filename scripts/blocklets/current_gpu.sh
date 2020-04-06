#!/bin/sh
exit

optimus_manager="$(command -v optimus-manager)"

if [ -z "$optimus_manager" ]; then
    exit
fi

# optimus-manager --print-mode
status="$($optimus_manager --print-mode | \
            cut -d':' -f2 | \
            tr -d '\n ')"

color="purple"
color="$("$SCRIPTS_DIR"/getColor.sh red)"
if [ "$status" = "nvidia" ]; then
    color="$("$SCRIPTS_DIR"/getColor.sh magenta)"
fi

printf "<span color='%s'>%s</span>\n" \
    "$color" \
    "$status"
