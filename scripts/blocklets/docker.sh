#!/bin/sh

docker_count() {
    docker_count="$(docker ps -q | wc -l)"
    echo " " $docker_count
}

docker_count

