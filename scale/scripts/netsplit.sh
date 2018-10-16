#!/bin/bash

# set -euo pipefail

i=${1}
name=srv_${i}
network=scale_habitat
container=scale_${name}_1
seconds=8

echo "Disconnecting ${container} from ${network}"
docker network disconnect ${network} ${container}
for x in $(seq 1 ${seconds}); do
    echo "Waiting ${x} of ${seconds} seconds..."
    sleep 1
done
echo "Reconnecting ${container} to ${network}"
docker network connect \
       --alias=${name}.habitat.dev \
       ${network} \
       ${container}
