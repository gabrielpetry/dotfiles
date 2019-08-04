#!/bin/bash

options="1-PlayPause\n2-Next\n3-Previous"

if [[ -z "$1" ]]; then
	chosen=$(echo -e $options | dmenu -i)
else
	chosen="$1"
fi

chosen=$(echo "$chosen" | cut -d - -f 1)

playerCtlFunction() {
	if playerctl --player=chromium status | grep -q "Playing\|Paused"; then
		# Pause spotify when chrome is playing ;) 
		playerctl --player=spotify pause
		playerctl --player=chromium "${1}"
	else
		playerctl "${1}"
	fi
}

case $chosen in
	1)
		playerCtlFunction play-pause
		;;
	2)
		playerCtlFunction next
		;;
	3)
		playerCtlFunction previous
		;;
esac
