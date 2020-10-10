#!/bin/bash
curl -Ss -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

source ~/.bashrc
# v12.18.3   (LTS: Erbium)
# v12.18.4   (LTS: Erbium)
# v12.19.0   (Latest LTS: Erbium)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install $(nvm ls-remote | grep -i lts | tail -n 1 | cut -d' ' -f 2)