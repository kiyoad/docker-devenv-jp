#!/bin/bash
set -eux

image_name=kiyoad/devenv
id=$(date '+%Y%m%d')

script -a docker_build_${id}.log docker build -t ${image_name}_${id} .
