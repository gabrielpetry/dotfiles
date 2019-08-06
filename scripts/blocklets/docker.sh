#!/bin/sh

docker_count() {
    docker_count="$(docker ps | wc -l)"
    echo $(( docker_count - 1 ))
}

docker_count

