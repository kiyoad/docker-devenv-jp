#!/bin/bash
set -eux

image_name=kiyoad/wb_centos6
id=$(date '+%Y%m%d')

script -ac "docker build -t ${image_name} -f Dockerfile.centos6 ." docker_build_centos6_${id}.log
