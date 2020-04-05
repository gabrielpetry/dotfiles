#!/usr/bin/env bash
# Finds the active sink for pulse audio and increments the volume.
# Useful when you have multiple audio outputs and have a key bound to vol-up and down
# Fork from http://customlinux.blogspot.com/2013/02/pavolumesh-control-active-sink-volume.html 

inc='2'
capvol='no'
maxvol='200'
autosync='yes'

# Muted status
# yes: muted
# no : not muted
curStatus="no"
active_sink=""
alert_danger=90;
alert_warning=70;
icon=" "

red="$($SCRIPTS_DIR/getColor.sh red)"
orange="$($SCRIPTS_DIR/getColor.sh yellow)"
normal="$($SCRIPTS_DIR/getColor.sh magenta)"

getActiveSink() {
    active_sink=$(pacmd list-sinks | awk '/* index:/{print $3}')
}

function volUp {
    pactl set-sink-volume "$active_sink" +5%
}

function volDown {
    pactl set-sink-volume "$active_sink" -5%
}

function getCurVol {
    curVol=$(pacmd list-sinks | grep -A 15 "index: $active_sink$" | grep 'volume:' | grep -E -v 'base volume:' | awk -F : '{print $3}' | grep -o -P '.{0,3}%'| sed s/.$// | tr -d ' ')
}

function volMute {
    pactl set-sink-mute "$active_sink" toggle
}

function volMuteStatus {
    curStatus=$(pacmd list-sinks | grep -A 15 "index: $active_sink$" | awk '/muted/{ print $2}')
}

function output() {
    getCurVol
    volMuteStatus
    color="$normal"
    if [ "${curStatus}" = 'yes' ]; then
        color="$red"
        curVol="muted"
        icon=" "
    fi

    if [[ ${curVol} -gt 69 ]]; then
        color="$orange"
    fi

    if [[ "${curVol}" -gt 89 ]]; then
        color="$red"
    fi


    printf "<span color='%s'>%s%s</span>\n" \
        "${color}" \
        "${icon}" \
        "${curVol}"
} 

getActiveSink
case "$1" in
    --up)
        volUp
        ;;
    --down)
        volDown
        ;;
    --togmute)
        volMute    
        ;;
    *)
        ;;
esac
output
pkill -RTMIN+10 i3blocks
