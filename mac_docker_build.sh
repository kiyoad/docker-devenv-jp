#!/bin/bash
set -eux

image_name=kiyoad/devenv

script docker_build.log docker build -t ${image_name} .
