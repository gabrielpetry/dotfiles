#!/bin/bash

command -v docker > /dev/null && exit 0

release="$(cat /etc/*-release | grep 'NAME')"


if echo $release | grep -iq 'fedora'; then
    echo Fedora does not like default docker
    echo "https://fedoramagazine.org/docker-and-fedora-32/"
    exit 
fi




curl -Ss https://get.docker.com | bash -
