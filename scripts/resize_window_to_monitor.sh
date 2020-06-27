#!/usr/bin/bash

## Get screen info
# screen1=($(xrandr | grep -w connected  | awk -F'[ +]' '{print $1,$3,$4}' | 
#     tail -n 1))
# screen2=($(xrandr | grep -w connected  | awk -F'[ +]' '{print $1,$4,$5}' | 
#     tail -n 2 | head -n 1))
# screen3=($(xrandr | grep -w connected  | awk -F'[ +]' '{print $1,$3,$4}' | 
#     head -n 1))

createLog() {
    if [ -n "$1" ]; then
        echo "$(date) ${*}" >> /tmp/resizeWindow.log & 
    fi
}

screens="$(xrandr | \
           grep -w connected | \
           sed 's/primary\ //g' | \
           awk -F'[ +]' '{print $1, $3, $4}' | \
           sort --key 3 --numeric-sort)"

eval $(xdotool getmouselocation --shell)
currentMousePosition=$X
monitorsOcupied=""

while read monitor; do
monitorRight="$(echo "$monitor" | awk '{print $3}' )"
    if [ "$currentMousePosition" -gt "$monitorRight" ]; then
        monitorsOcupied="$monitorsOcupied
        $monitor"
    fi
done <<< "$screens"

createLog "screens: " "$screens"
createLog "monitors ocupied: " "$monitorsOcupied"

if [ "$monitorsOcupied" != "" ]; then
    monitorWithTheWindow="$(echo "$monitorsOcupied" | tail -n 1)"
else
    monitorWithTheWindow="$(echo "$screens" | head -n 1)"
fi


createLog "Monitor with the window: $monitorWithTheWindow"

resolutions="$(echo $monitorWithTheWindow | awk '{print $2}')"
createLog "Resolutions $resolutions"
resolutionX="$(echo $resolutions | cut -dx -f1)"
resolutionY="$(echo $resolutions | cut -dx -f2)"


i3-msg scratchpad show

# scratchPadIsVisible="$(wmctrl -lp | grep -E "\0\x[0-9a-z]+?\s+-1")"

# if [ -z "$scratchPadIsVisible" ]; then
    createLog "scratchpad status $scratchPadIsVisible"
    if [[ "$resolutionX" -gt "1920" ]]; then 
        resolutionX=1920
    fi
    i3-msg "[con_mark=scratchpad] move position pointer"
    i3-msg "[con_mark=scratchpad] resize set $(expr $resolutionX - 100) $(expr $resolutionY - 100)" && \
    i3-msg move position center
# fi


createLog "====== EOE ======"

exit 0

