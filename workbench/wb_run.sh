#!/bin/bash
set -eu

if [ $# -ne 2 ]; then
    echo "Usage: $(basename $0) IMAGE_NAME CONTAINER_NAME"
    exit 1
fi

image_name=$1
container_name=$2
export_local_dir=${HOME}/Documents

docker run -d -v ${export_local_dir}:/home/developer/Documents --hostname=${container_name} --name=${container_name} ${image_name}
