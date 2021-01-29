#!/bin/sh

command -v alacritty > /dev/null && exit 0

sudo add-apt-repository -y ppa:mmstick76/alacritty
sudo apt -y install alacritty
