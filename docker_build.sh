#!/bin/bash
set -eux

image_name=kiyoad/devenv
id=$(date '+%Y%m%d')

sudo bash -c "echo 0 > /proc/sys/kernel/randomize_va_space"
script -ac "docker build -t ${image_name}_${id} ." docker_build_${id}.log
