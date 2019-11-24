#!/usr/bin/env sh

## Get screen info
# screen1=($(xrandr | grep -w connected  | awk -F'[ +]' '{print $1,$3,$4}' | 
#     tail -n 1))
# screen2=($(xrandr | grep -w connected  | awk -F'[ +]' '{print $1,$4,$5}' | 
#     tail -n 2 | head -n 1))
# screen3=($(xrandr | grep -w connected  | awk -F'[ +]' '{print $1,$3,$4}' | 
#     head -n 1))

screens="$(xrandr | \
           grep -w connected | \
           sed 's/primary\ //g' | \
           awk -F'[ +]' '{print $1, $3, $4}' | \
           sort --key 3 --numeric-sort)"

currentWindowPosition=$(xwininfo -id $(xdotool getactivewindow) | \
                grep "Absolute upper-left X" | \
                awk '{print $NF}')

monitorsOcupied=""

while read monitor; do
monitorRight="$(echo "$monitor" | awk '{print $3}' )"
    if [ "$currentWindowPosition" -gt "$monitorRight" ]; then
        monitorsOcupied="$monitorsOcupied
        $monitor"
    fi
done <<< "$screens"

echo "screens: " "$screens"
echo "monitors ocupied: " "$monitorsOcupied"

if [ "$monitorsOcupied" != "" ]; then
    monitorWithTheWindow="$(echo "$monitorsOcupied" | tail -n 1)"
else
    monitorWithTheWindow="$(echo "$screens" | head -n 1)"
fi



echo "Monitor with the window: $monitorWithTheWindow"

resolutions="$(echo $monitorWithTheWindow | awk '{print $2}')"
resolutionX="$(echo $resolutions | cut -dx -f1)"
resolutionY="$(echo $resolutions | cut -dx -f2)"

if [  ]
i3-msg resize set $(expr $resolutionX - 100) $(expr $resolutionY - 100) && \
i3-msg move position center

exit


## Figure out which screen is to the right of which
# if [ ${screen1[2]} -eq 0  ]
# then
#     right=(${screen2[@]});
#     left=(${screen1[@]});
# else
#     right=(${screen1[@]});
#     left=(${screen2[@]});
# fi

## Get window position
pos=$(xwininfo -id $(xdotool getactivewindow) | grep "Absolute upper-left X" | 
      awk '{print $NF}')

## Which screen is this window displayed in? If $pos
## is greater than the offset of the rightmost screen,
## then the window is on the right hand one
current_monitor=""

if [ "$pos" -gt "${right" ]

# if [ "$pos" -gt "${right[2]}" ]
# then
#     echo "${right[0]} : ${right[1]}"    
# else
#     echo "${left[0]} : ${left[1]}"    
# fi