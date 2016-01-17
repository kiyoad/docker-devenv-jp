#!/bin/bash
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 CONTAINER_NAME"
    exit 1
fi

IP=$(docker inspect $1 | jq -r '.[]|.NetworkSettings|.Networks|.bridge.IPAddress')
ssh -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' -o 'ForwardX11 yes' developer@${IP}
