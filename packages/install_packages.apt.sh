#!/bin/bash

# Update the pacman base
update_apt() {
    sudo sed -i 's/main$/main contrib/g' /etc/apt/sources.list && \
      sudo apt-get update -y
}


install_packages() {
    PACKAGE_LIST_CSV="packages.apt.csv"
    INSTALLED_PACKAGES="$(apt list --installed | cut -d'/' -f1)"

    # Iterate over the programs and create a list of the non installed ones
    while IFS=, read -r install_method program comment; do
        # If already installed, skip
        if echo "${INSTALLED_PACKAGES}" | grep -qo "${program}"; then
            continue
        fi
        
        if [[ "${install_method}" =~ (apt) ]]; then
            if sudo apt-get install -yq "${program}" > /dev/null; then
                echo "${program}(${install_method}) - ${comment} [SUCESS]"
            else
                echo "${program}(${install_method}) - ${comment} [ERROR]"
            fi
        fi

        if [[ "${install_method}" =~ (ruby) ]]; then
            if sudo gem install "${program}" > /dev/null; then
                echo "${program}(${install_method}) - ${comment} [SUCESS]" 
            else
                echo "${program}(${install_method}) - ${comment} [ERROR]" 
            fi
        fi

        if [[ "${install_method}" =~ (pip) ]]; then
            if sudo pip3 install "${program}" > /dev/null; then
                echo "${program}(${install_method}) - ${comment} [SUCESS]" 
            else
                echo "${program}(${install_method}) - ${comment} [ERRORsudo]" 
            fi
        fi

    done < "${PACKAGE_LIST_CSV}"
}

install_addons() {
    install ohmyzsh
    # sh -c "$()"
    sh -c "$(curl \
      -fsSL \
      https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh \
        | sed 's:exec zsh -l::g' \
        | sed 's:chsh -s .*$::g')"
      git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

runApt() {
    update_apt && \
    install_packages
}

runManual() {
    scripts="$(dirname "$0")/manual_installation"

    # run this only IF NOT in wsl
    if [[ ! $(grep -i Microsoft /proc/version) ]]; then
      $scripts/docker.sh
      $scripts/i3_gaps_next.sh
      $scripts/light_git.sh
      $scripts/nerd_fonts.sh
    fi

    $scripts/chromium_widevine.sh

    $scripts/nvm.sh

    $scripts/nvim.sh
}

[ -z "$1" ] && echo "Usage $0 [apt|addons|manual]" && exit 1

[ "$1" = "apt" ]    && runApt
[ "$1" = "manual" ] && runManual
[ "$1" = "addons" ] && install_addons
[ "$1" = "all" ] && runApt; runManual; install_addons

exit 0
