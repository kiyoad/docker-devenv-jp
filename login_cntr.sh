#!/bin/bash
set -euo pipefail
IP=$(docker inspect $1 | jq -r '.[]|.NetworkSettings|.Networks|.bridge.IPAddress')
ssh -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' -o 'ForwardX11 yes' developer@${IP}
