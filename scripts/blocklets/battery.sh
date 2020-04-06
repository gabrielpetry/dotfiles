#!/bin/bash

level="$(cat /sys/class/power_supply/BAT?/capacity)"


color="$PRIMARY_COLOR"

[[ "$level" -lt "60" ]] && color="$ALERT_COLOR"
[[ "$level" -lt "20" ]] && color="$DANGER_COLOR"

printf "<span color='%s'>%s %%</span>\n" \
    "$color" \
    "$level"

