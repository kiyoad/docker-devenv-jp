#!/bin/bash
set -eux

local_ssh_port=12222
devenv_ssh_port=12222
devenv_ssh_host=`echo $DOCKER_HOST | sed -e 's|tcp://||' -e 's|:.*$||'`

ssh -N -L ${local_ssh_port}:127.0.0.1:${devenv_ssh_port} docker@${devenv_ssh_host} -i ~/.ssh/id_boot2docker
