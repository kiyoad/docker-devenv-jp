# docker-devenv-jp
My Development environment for using Emacs by docker

## How to use

<dl>
<dt>IMAGE_NAME</dt>
<dd>Image name.(Ex.: 'kiyoad/devenv')</dd>

<dt>LOCAL_PORT</dt>
<dd>A free ssh redirection port.(Ex.: '12222')</dd>

<dt>LOCAL_DOC_DIR</dt>
<dd>Your working directory that uses it in docker.(Ex.: '/home/kiyoad/Documents')</dd>

<dt>MOUNT_POINT</dt>
<dd>A mount point for your working directory.(Ex.: 'Documents')</dd>

<dt>CONTAINER_NAME</dt>
<dd>Your container name.(Ex.: 'devenv')</dd>

<dt>DOCKER_HOST</dt>
<dd>Boot2Docker VM IP address when you are using it.(Ex.: '192.168.59.103')</dd>

</dl>

1. Copy your `id_rsa.pub` to the same directory as `Dockerfile`.
1. Run `docker build -t <IMAGE_NAME> .`
1. Run `docker run -d -p 127.0.0.1:<LOCAL_PORT>:22 -v <LOCAL_DOC_DIR>:/home/developer/<MOUNT_POINT> --name=<CONTAINER_NAME> <IMAGE_NAME>`
1. If you are using the Boot2Docker in MacOSX, you should do 'port forwarding' like this `ssh -N -L <LOCAL_PORT>:127.0.0.1:<LOCAL_PORT> docker@<DOCKER_HOST> -i ~/.ssh/id_boot2docker`
1. Add `Host` definition in your `~/.ssh/config` like this.

```
Host docker-devenv
  User      developer
  Port      <LOCAL_PORT>
  HostName  127.0.0.1
  ForwardX11 yes
```

1. Run `ssh docker-devenv` and enter your development environment!
1. Please do `docker stop <CONTAINER_NAME>` after your work ends, and do `docker start <CONTAINER_NAME>` before your work start again. You do not need to do `docker run` repeatedly.

## Tips

* UID(Currently 1000) of `developer` can be modified to the same as your UID, to avoid the problem of permission. But you don't have to worry about it if you using the Boot2Docker 1.5(or higher).
