#!/bin/bash
set -eux

local_ssh_port=12222
container_name=devenv
image_name=kiyoad/devenv
export_local_dir=/Users/kiyoad/Documents

docker run -d -p 127.0.0.1:${local_ssh_port}:22 -v ${export_local_dir}:/home/developer/Documents --name=${container_name} ${image_name}
