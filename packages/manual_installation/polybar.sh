#!/bin/bash

echo "I3 blocks is better"
exit
installPath="$HOME/Projects/github/"

mkdir -p $installPath
cd $installPath

# clone the repository
git clone --depth 1 https://github.com/polybar/polybar


sudo apt-get install cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev libxcb-composite0-dev xcb libxcb-ewmh2 libjsoncpp-dev -y 

cd polybar

# ./build.sh

mkdir build
cd build

cmake .. && \
    make -j"$(nproc)" && \
    sudo make install
