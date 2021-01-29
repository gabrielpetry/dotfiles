#!/bin/bash

installPath="$HOME/Projects/github/"
mkdir -p $installPath
cd $installPath

CPU_CORES="$(expr $(grep processor /proc/cpuinfo | wc -l) + 1)"

# clone the repository

test -d i3-gaps || git clone -b gaps-next --depth 1 https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps

sudo apt install git libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev meson ninja-build -y

# compile & install
autoreconf --force --install
rm -rf build/
mkdir -p build

cd build/
meson ..
ninja
meson install

