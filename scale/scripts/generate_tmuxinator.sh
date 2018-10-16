#!/bin/bash

set -euo pipefail
num=${1}

cat <<EOF
name: scale

# Ensure the network is created first; otherwise they ALL try to do it
# at once and it's not good.
on_project_start: docker network create scale_habitat && sleep 3
on_project_stop: ../scripts/capture_logs.sh && docker-compose down

windows:
  - bastion:
      layout: even-vertical
      panes:
        - logs:
          - docker-compose up bastion
        - ps:
          - sleep 5
          - docker-compose exec bastion sh
          - hab pkg install core/procps-ng -b -f
          - while true; do ps --no-headers -o rss,vsz,comm -q \$(pgrep hab-sup); sleep 1; done
  - console:
    - docker-compose run console
  - workstation:
  - network:
    - sleep 10
    - docker-compose up
  - sups:
      layout: tiled
      panes:
EOF

for i in $(seq 1 ${num}); do
    name="srv_${i}"
cat  <<EOF
        - ${name}:
          - sleep 20
          - docker-compose exec ${name} sh
          - hab pkg install core/procps-ng -b -f
          - while true; do ps --no-headers -o rss,vsz,comm -q \$(pgrep hab-sup); sleep 1; done
EOF

done
