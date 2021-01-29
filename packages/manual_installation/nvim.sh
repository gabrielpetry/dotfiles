#!/bin/sh

command -v nvim > /dev/null && exit 0

git clone --depth 1 https://github.com/neovim/neovim.git

sudo apt install -y \
  gperf \
  libluajit-5.1-dev \
  libunibilium-dev \
  libmsgpack-dev \
  libtermkey-dev \
  libvterm-dev \
  libjemalloc-dev \
  lua5.1 \
  lua-lpeg \
  lua-mpack \
  lua-bitop
