#!/bin/bash

level="$(cat /sys/class/power_supply/BAT?/capacity)"
status="$(cat /sys/class/power_supply/BAT?/status)"

discharging_icon=""
charging_icon=""
unknown_icon=""

color="$PRIMARY_COLOR"

[[ "$level" -lt "60" ]] && color="$ALERT_COLOR"
[[ "$level" -lt "20" ]] && color="$DANGER_COLOR"

status="$(echo $status | sed "s/Full/$charging_icon/g;s/Charging/$charging_icon/g")"
status="$(echo $status | sed "s/Discharging/$discharging_icon/g")"
status="$(echo $status | sed "s/Unknown/$unknown_icon/g")"

printf "<span color='%s'>%s %%</span>\n" \
    "$color" \
    "$status $level"

