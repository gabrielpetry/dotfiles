#!/bin/bash

LABEL=""

color=""
wifi_card_name="$(ip a | grep -Eo "wlp[0-9]s[0-9]" | tail -n 1)"

wifi_info="$(iwconfig "${wifi_card_name}")"
wifi_quality="$(echo "${wifi_info}" | \
    grep -Eo "([Qq]uality=)[0-9]{2}\/[0-9]{1,2}" | \
    cut -d "=" -f2)"

wifi_connection_name="$(echo "${wifi_info}" | \
    grep -Eo "ESSID:.*" | \
    grep -Eo "\"([0-9a-zA-Z ])+\"")"

if [[ "$(echo "${wifi_quality}" | cut -d '/' -f1 )" -lt "51" ]]; then
    background_color="#$(grep "color12" "${HOME}/.Xresources" | \
		      cut -d "#" -f2)"
    color="color='${background_color}'"
fi

printf "<span %s>%s %s %s</span>" \
    "${color}" \
    "${LABEL}" \
    "${wifi_quality}" \
    "${wifi_connection_name//\"/}"
