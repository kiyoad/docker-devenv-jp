#!/bin/bash
set -eux

devenv_ssh_port=12222

IP=`echo $DOCKER_HOST | sed -e 's|tcp://||' -e 's|:.*$||'`
ssh -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' -o 'ForwardX11 yes' -p ${devenv_ssh_port} developer@${IP}
