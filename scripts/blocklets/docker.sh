#!/bin/bash



color="$PRIMARY_COLOR"

docker_count="$(docker ps -q 2>/dev/null | wc -l)"



docker ps -q > /dev/null || docker_count=-1

[ "$docker_count" -gt "5" ] && color="$ALERT_COLOR"
[[ "$docker_count" = "-1" || "$docker_count" -gt "7" ]] && color="$DANGER_COLOR"


echo "<span color='$color' font='monospaced'>  $docker_count</span>"
