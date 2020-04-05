#!/bin/sh

level="$(cat /sys/class/power_supply/BAT1/capacity)"


color="$PRIMARY_COLOR"

[ "$level" -lt "60" ] && color="$ALERT_COLOR"
[ "$level" -lt "20" ] && color="$DANGER_COLOR"

printf "<span color='%s'>%s %%</span>" \
    "$color" \
    "$level"

