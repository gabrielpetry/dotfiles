#!/bin/bash

curl -Ss -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

source ~/.bashrc
# v12.18.3   (LTS: Erbium)
# v12.18.4   (LTS: Erbium)
# v12.19.0   (Latest LTS: Erbium)
nvm install $(nvm ls-remote | grep -i lts | tail -n 1 | cut -d'(' -f 1)