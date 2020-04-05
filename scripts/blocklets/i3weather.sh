#!/bin/sh
# set the location
# fork of https://github.com/LukeSmithxyz/voidrice/blob/archi3/.local/bin/statusbar/weather
location="Porto+alegre"

# save wttr.in page to a cache file
cache_file="$HOME/.cache/weatherreport"

[ "$(stat -c %y $cache_file | cut -d' ' -f1)" != "$(date +'%Y-%m-%d')" ] && curl -s http://wttr.in/$location > $cache_file

printf "%s" "$(sed '16q;d' ~/.weatherreport | grep -wo "[0-9]*%" | sort -n | sed -e '$!d' | sed -e "s/^/ /g" | tr -d '\n')"

printf "%s" "$(sed '13q;d' ~/.weatherreport | grep -o "m[0-9]\\+" | sort -n | sed -e 1b -e '$!d' | tr '\n|m' ' ' | awk '{print " ",$1 "","",$2 ""}')"

