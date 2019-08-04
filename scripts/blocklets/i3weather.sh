#!/bin/sh
# set the location
# fork of https://github.com/LukeSmithxyz/voidrice/blob/archi3/.local/bin/statusbar/weather
location="Porto+alegre"

# check for internet connection
ping -q -c 3 1.1.1.1 > /dev/null || exit 1

# save wttr.in page to a cache file
curl -s http://wttr.in/$location > ~/.weatherreport

printf "%s" "$(sed '16q;d' ~/.weatherreport | grep -wo "[0-9]*%" | sort -n | sed -e '$!d' | sed -e "s/^/ /g" | tr -d '\n')"

printf "%s" "$(sed '13q;d' ~/.weatherreport | grep -o "m[0-9]\\+" | sort -n | sed -e 1b -e '$!d' | tr '\n|m' ' ' | awk '{print " ",$1 "","",$2 ""}')"

