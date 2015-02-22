#!/bin/bash
set -eux

image_name=kiyoad/devenv

script -c "docker build -t ${image_name} ." docker_build.log
