#!/bin/bash
set -eu

if [ $# -ne 1 ]; then
    echo "Usage: $(basename $0) CONTAINER_NAME"
    exit 1
fi

container_name=$1
image_name=kiyoad/wb_centos7
export_local_dir=/home/kiyoad/Documents

docker run -d -v ${export_local_dir}:/home/developer/Documents --hostname=${container_name} --name=${container_name} ${image_name}
