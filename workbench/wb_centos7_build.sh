#!/bin/bash
set -eux

image_name=kiyoad/wb_centos7
id=$(date '+%Y%m%d')

script -ac "docker build -t ${image_name} -f Dockerfile.centos7 ." docker_build_centos7_${id}.log
