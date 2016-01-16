#!/bin/bash
set -eux

image_name=kiyoad/devenv
id=$(date '+%Y%m%d')

script -ac "docker build -t ${image_name}_${id} ." docker_build_${id}.log
