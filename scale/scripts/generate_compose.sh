#!/bin/bash

set -euo pipefail
num=${1}

cat <<EOF
version: '3.2'
networks:
  habitat:
services:
  bastion:
    image: \${IMAGE}
    command:
      - "run"
      - "--listen-ctl=0.0.0.0:9632"
      - "--permanent-peer"
    hostname: bastion
    domainname: habitat.dev
    volumes:
      - type: bind
        source: ./data/bastion/hab-sup-default
        target: /hab/sup/default/
        read_only: false
    environment:
      - HAB_NONINTERACTIVE=1
    networks:
      habitat:
        aliases:
          - bastion.habitat.dev
EOF

for i in $(seq 1 ${num}); do
    name="srv_${i}"
cat  <<EOF
  ${name}:
    image: \${IMAGE}
    command:
      - "run"
      - "--listen-ctl=0.0.0.0:9632"
      - "--peer=bastion.habitat.dev"
    hostname: ${name}
    domainname: habitat.dev
    volumes:
      - type: bind
        source: ./data/${name}/hab-sup-default
        target: /hab/sup/default/
        read_only: false
    environment:
      - HAB_NONINTERACTIVE=1
    networks:
      habitat:
        aliases:
          - ${name}.habitat.dev
EOF
done

cat <<EOF
  console:
    image: \${IMAGE}
    command: sh
    volumes:
      - type: bind
        source: ./data/console/hab-sup-default
        target: /hab/sup/default/
        read_only: false
    environment:
      - HAB_NONINTERACTIVE=1
    networks:
      habitat:
        aliases:
          - console.habitat.dev
EOF
