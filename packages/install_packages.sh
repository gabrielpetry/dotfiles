#!/bin/bash

PACKAGE_LIST_CSV="packages.csv"
INSTALLED_PACKAGES="$(pacman -Q | awk '{print $1}')"

programsToInstallPacman=""
programsToInstallAur=""

# Iterate over the programs and create a list of the non installed ones
while IFS=, read -r install_method program comment; do
    # If already installed, skip
    if echo "${INSTALLED_PACKAGES}" | grep -qo "${program}"; then
        continue
    fi
    
    if [[ "${install_method}" =~ (pacman) ]]; then
        programsToInstallPacman="${programsToInstallPacman} ${program}"
    elif [[ "${install_method}" =~ (aur) ]]; then
        programsToInstallAur="${programsToInstallAur} ${program}"
    fi
    echo "${program}(${install_method}) - ${comment} está na fila para instalação"
done < "${PACKAGE_LIST_CSV}"

sudo pacman -Sy --noconfirm
main() {
    sudo pacman -S --noconfirm "${programsToInstallPacman}"
    yay -S --noconfirm "${programsToInstallAur}"
}

main
