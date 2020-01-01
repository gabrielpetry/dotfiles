#!/bin/bash

# Update the pacman base
update_pacman() {
    # Update the mirrorlist
    sudo reflector --verbose --country 'Brazil' -l 10 --sort rate --save /etc/pacman.d/mirrorlist
    sudo pacman -Sy --noconfirm
}

install_packages() {
    PACKAGE_LIST_CSV="packages.csv"
    INSTALLED_PACKAGES="$(pacman -Q | awk '{print $1}')"

    # Iterate over the programs and create a list of the non installed ones
    while IFS=, read -r install_method program comment; do
        # If already installed, skip
        if echo "${INSTALLED_PACKAGES}" | grep -qo "${program}"; then
            # echo "${program} [INSTALLED]" 
            continue
        fi
        
        if [[ "${install_method}" =~ (pacman) ]]; then
            echo "Installing ${program} - wait"
            if pacman -S "${program}" --noconfirm >/dev/null; then
                echo "${program}(${install_method}) - ${comment} [SUCESS]" 
            fi
        elif [[ "${install_method}" =~ (aur) ]]; then
            continue
        fi
    done < "${PACKAGE_LIST_CSV}"

}

install_addons() {
    install ohmyzsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # zsh-autosugestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    # doom-emacs
    git clone https://github.com/hlissner/doom-emacs ~/.emacs.d && \
        ~/.emacs.d/bin/doom install
}

runPacman() {
    update_pacman && \
    install_packages
}

if [[ -z "$1" ]]; then
    echo "Usage $0 [pacman|addons]"
    exit 1
fi

if [[ "$1" == "pacman" ]]; then
    runPacman
fi

if [[ "$1" == "addons" ]]; then
    install_addons
fi

