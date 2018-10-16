#!/bin/bash

set -xeuo pipefail
for container in $(docker-compose images | tail --lines=+3 | awk '{print $1}'); do
    docker logs "${container}" > "data/${container}_stdout.txt"
done
