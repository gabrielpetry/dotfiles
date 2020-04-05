#!/bin/bash

installPath="$HOME/Projects/github/"

mkdir -p $installPath
cd $installPath

# clone the repository
git clone --depth 1 https://github.com/haikarainen/light.git

cd light

./autogen.sh && ./configure && make -j"$(nproc)" && sudo make install

