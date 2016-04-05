#!/bin/bash
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $(basename $0) CONTAINER_NAME"
    exit 1
fi

IP=$(docker inspect --format="{{ .NetworkSettings.Networks.bridge.IPAddress }}" $1)
ssh -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' -o 'ForwardX11 yes' developer@${IP}
