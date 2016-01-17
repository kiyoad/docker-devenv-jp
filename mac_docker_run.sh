#!/bin/bash
set -eux

local_ssh_port=12222
container_name=devenv
image_name=kiyoad/devenv
export_local_dir=/Users/kiyoad/Documents
id=$(date '+%Y%m%d')

docker run -d -p 127.0.0.1:${local_ssh_port}:22 -v ${export_local_dir}:/home/developer/Documents --hostname=${container_name} --name=${container_name}_${id} ${image_name}_${id}
