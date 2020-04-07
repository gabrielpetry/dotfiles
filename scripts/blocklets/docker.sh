#!/bin/bash



color="$PRIMARY_COLOR"

docker_count="$(docker ps -q 2>/dev/null | wc -l)"

docker ps -q 2> /dev/null || docker_count=-1

[ "$docker_count" -gt "5" ] && color="$ALERT_COLOR"
[[ "$docker_count" = "-1" || "$docker_count" -gt "7" ]] && color="$DANGER_COLOR"

printf "<span color='%s'> %s</span>" \
    "$color" \
    "$docker_count"

