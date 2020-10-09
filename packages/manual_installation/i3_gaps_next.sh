#!/bin/bash

installPath="$HOME/Projects/github/"
mkdir -p $installPath
cd $installPath

CPU_CORES="$(expr $(grep processor /proc/cpuinfo | wc -l) + 1)"

# clone the repository

testd -d i3-gaps || git clone -b gaps-next --depth 1 https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
git pull

# sudo apt install git libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev -y
sudo dnf install -y libxcb-devel xcb-util-keysyms-devel xcb-util-devel xcb-util-wm-devel xcb-util-xrm-devel yajl-devel libXrandr-devel startup-notification-devel libev-devel xcb-util-cursor-devel libXinerama-devel libxkbcommon-devel libxkbcommon-x11-devel pcre-devel pango-devel git gcc automake i3status i3lock make

# compile & install
autoreconf --force --install
rm -rf build/
mkdir -p build

cd build/

# Disabling sanitizers is important for release versions!
# The prefix and sysconfdir are, obviously, dependent on the distribution.
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make -j"$CPU_CORES" && \
    sudo make install

