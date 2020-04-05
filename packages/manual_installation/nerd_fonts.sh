#!/bin/bash

exit
installPath="$HOME/Projects/github/"

mkdir -p $installPath
cd $installPath

# clone the repository
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git

cd nerd-fonts


./install.sh
