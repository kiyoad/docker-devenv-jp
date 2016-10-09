#!/bin/bash
set -eux

image_name=kiyoad/wb_xenial
id=$(date '+%Y%m%d')

script -ac "docker build -t ${image_name} -f Dockerfile.xenial ." docker_build_xenial_${id}.log
