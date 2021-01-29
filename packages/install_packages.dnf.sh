#!/bin/bash

find_difs_apt_Dnf() {
    PACKAGE_LIST_CSV="packages.dnf.csv"
    while IFS=, read -r install_method program comment; do
        if [[ "${install_method}" =~ (dnf) ]]; then
            (dnf search ${program} 2>&1 | grep -qo "Correspondeu Exatamente") || echo "$program não existe"
        fi
    done < "${PACKAGE_LIST_CSV}"
}

# Update the pacman base
update_dnf() {
    sudo dnf update
}


install_packages() {
    PACKAGE_LIST_CSV="packages.dnf.csv"
    INSTALLED_PACKAGES="$(dnf list installed | cut -d' ' -f1)"

    # Iterate over the programs and create a list of the non installed ones
    while IFS=, read -r install_method program comment; do
        # If already installed, skip
        if echo "${INSTALLED_PACKAGES}" | grep -qo "${program}"; then
            continue
        fi
        
        if [[ "${install_method}" =~ (dnf) ]]; then
            echo "Installing ${program} - wait"
            if sudo dnf install -y "${program}" > /dev/null; then
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

runDnf() {
    update_dnf && \
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

[ "$1" = "dnf" ]    && runDnf
[ "$1" = "manual" ] && runManual
[ "$1" = "addons" ] && install_addons
[ "$1" = "all" ] && runDnf; runManual; install_addons

exit 0
