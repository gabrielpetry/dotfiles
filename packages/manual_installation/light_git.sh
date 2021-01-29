#!/bin/bash
command -v light > /dev/null && exit 0

installPath="$HOME/Projects/github/"

mkdir -p $installPath
cd $installPath

# clone the repository
git clone --depth 1 https://github.com/haikarainen/light.git

cd light

./autogen.sh && ./configure && make -j"$(nproc)" && sudo make install

