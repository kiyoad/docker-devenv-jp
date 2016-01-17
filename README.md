# docker-devenv-jp
My Development environment for using Emacs by docker

## How to use
### Linux

1. Prepare `docker 1.9.1` and `jq 1.5`. This is the version at the time of operation check.
1. Copy your `id_rsa.pub` to the same directory as `Dockerfile`.
1. Run `./docker_build.sh`.
1. Change `export_local_dir` in `docker_run.sh` to your working directory.
1. Run `./docker_run.sh`.
1. Check the container names using `docker ps`. For example, it is a name like `devenv_20160116`.
1. Run `./login_cntr.sh CONTAINER_NAME`. For example, `./login_cntr.sh devenv_20160116`.
1. This is the login completion.
1. Please do `docker stop CONTAINER_NAME` after your work ends, and do `docker start CONTAINER_NAME` before your work start again. You do not need to do `./docker_run.sh` repeatedly.

### MacOSX

1. Prepare `docker 1.9.1`, `docker-machine 0.5.6` and `jq 1.5`. This is the version at the time of operation check. I used the `brew` to install.
1. Copy your `id_rsa.pub` to the same directory as `Dockerfile`.
1. Run `./mac_docker_build.sh`.
1. Change `export_local_dir` in `mac_docker_run.sh` to your working directory.
1. Run `./mac_docker_run.sh`.
1. Run `./mac_login_cntr.sh`. The container name can not be specified.
1. This is the login completion.
1. Please do `docker stop CONTAINER_NAME` after your work ends, and do `docker start CONTAINER_NAME` before your work start again. You do not need to do `./mac_docker_run.sh` repeatedly.

## Description of the variables in the scripts

<dl>
<dt>image_name</dt>
<dd>Image name.(Ex.: 'kiyoad/devenv')</dd>

<dt>container_name</dt>
<dd>Container name.(Ex.: 'devenv')</dd>

<dt>export_local_dir</dt>
<dd>Your working directory that uses it in the container.(Ex.: '/home/kiyoad/Documents') This directory is mounted in the container.</dd>

<dt>devenv_ssh_port</dt>
<dd>A free ssh redirection port in the docker-machine's VM.(Ex.: '12222')</dd>

</dl>

## Tips

* You can change the container name using `docker rename`.
* UID(Currently 1000) of `developer` can be modified to the same as your UID, to avoid the problem of permission. But you don't have to worry about it if you are using in MacOSX.
