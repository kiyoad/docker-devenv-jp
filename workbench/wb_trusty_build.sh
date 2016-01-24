#!/bin/bash
set -eux

image_name=kiyoad/wb_trusty
id=$(date '+%Y%m%d')

script -ac "docker build -t ${image_name} -f Dockerfile.trusty ." docker_build_trusty_${id}.log
