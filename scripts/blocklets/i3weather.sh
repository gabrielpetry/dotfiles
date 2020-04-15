#!/bin/bash
# set the location
# fork of https://github.com/LukeSmithxyz/voidrice/blob/archi3/.local/bin/statusbar/weather
location="Porto+alegre"

# save wttr.in page to a cache file
cache_file="$HOME/.cache/weatherreport"
rain_icon="  "
minimum_icon=" "
maximum_icon=" "
current_icon="  "

color="$PRIMARY_COLOR"

[ $(command -v jq) ] || (echo "jq not installed" && exit 1) || exit

update_weather_info() {
    ping -q -c 3 1.1.1.1 > /dev/null || exit 1
    weather_info="$(curl -s http://wttr.in/$location?format=j1)"
    chanceofrain="$(echo $weather_info | \
        jq '.weather[0].hourly[] | .chanceofrain' | \
        sort | \
        tail -n 1 | sed 's/\"//g')"
    currenttemperature="$(echo $weather_info | jq '.current_condition[0] | .temp_C+"/"+.FeelsLikeC' | sed 's/\"//g')"
    mintemperature="$(echo $weather_info | jq '.weather[0].mintempC' | sed 's/\"//g')"
    maxtemperature="$(echo $weather_info | jq '.weather[0].maxtempC' | sed 's/\"//g')"

    [[ "$maxtemperature" -gt "30" ]] && color="$DANGER_COLOR"
    [[ "$mintempC" -lt "10" ]] && color="$ALERT_COLOR"
    [[ "$chanceofrain" -gt "50" ]] && color="$ALERT_COLOR"
    [[ "$chanceofrain" -gt "88" ]] && color="$DANGER_COLOR"
    
    info="$(printf "<span color='%s'>%s  %s  %s  %s  %s  %s  %s  %s</span>" \
        "$color" \
        "$rain_icon"    "$chanceofrain" \
        "$minimum_icon" "$mintemperature" \
        "$maximum_icon" "$maxtemperature" \
        "$current_icon" "$currenttemperature")"
    echo $info > $cache_file
}

# [ "$(stat -c %y $cache_file | cut -d' ' -f1)" != "$(date +'%Y-%m-%d')" ] && update_weather_info
update_weather_info
cat $cache_file


