#!/bin/bash

# Update the pacman base
update_apt() {
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
            echo "Installing ${program} - wait"
            if sudo apt-get install -yq "${program}" > /dev/null; then
                echo "${program}(${install_method}) - ${comment} [SUCESS]" 
            fi
        fi

        if [[ "${install_method}" =~ (ruby) ]]; then
            echo "Installing ${program} - wait"
            if sudo gem install "${program}" > /dev/null; then
                echo "${program}(${install_method}) - ${comment} [SUCESS]" 
            fi
        fi

        if [[ "${install_method}" =~ (pip) ]]; then
            echo "Installing ${program} - wait"
            if sudo pip3 install "${program}" > /dev/null; then
                echo "${program}(${install_method}) - ${comment} [SUCESS]" 
            fi
        fi

    done < "${PACKAGE_LIST_CSV}"
}

install_addons() {
    install ohmyzsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # zsh-autosugestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

runApt() {
    update_apt && \
    install_packages
}

runManual() {
    scripts="$(dirname "$0")/manual_installation"

    $scripts/docker.sh

    $scripts/nvm.sh

    $scripts/nerd_fonts.sh

    $scripts/nvim.sh
}

[ -z "$1" ] && echo "Usage $0 [apt|addons|manual]" && exit 1

[ "$1" = "apt" ]    && runApt
[ "$1" = "manual" ] && runManual
[ "$1" = "addons" ] && install_addons
[ "$1" = "all" ] && runApt; runManual; install_addons

exit 0
