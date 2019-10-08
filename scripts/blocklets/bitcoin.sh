#!/bin/bash

last_sell="$(curl -Ss https://www.mercadobitcoin.net/api/BTC/ticker)"


value="$(echo "$last_sell" | jq ".ticker.sell" | tr -d '\"' | cut -d"." -f1)"


color="#e2e2e2"
if [[ "$value" -gt "40000" ]]; then
    color="$("$SCRIPTS_DIR"/getColor.sh magenta)"
fi
printf "<span color='%s'> R$ %s</span>\n" \
    "$color" \
    "$value"
 
