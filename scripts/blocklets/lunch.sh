#!/bin/sh

echo "<span>Lunch</span>"


if [[ -n "$BUTTON" ]]; then
    notify-send $button
fi
