#!/bin/bash
set -eux

container_name=devenv
image_name=kiyoad/devenv
export_local_dir=/home/kiyoad/Documents
id=$(date '+%Y%m%d')

docker run -d -v ${export_local_dir}:/home/developer/Documents --hostname=${container_name} --name=${container_name}_${id} ${image_name}_${id}
