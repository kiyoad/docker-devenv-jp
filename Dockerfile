FROM ubuntu:trusty
MAINTAINER KIYOHIRO ADACHI <kiyoad@da2.so-net.ne.jp>

ENV REFRESHED_AT 2015-02-22

ENV DEBIAN_FRONTEND noninteractive

RUN \
  echo "deb http://ftp.riken.jp/Linux/ubuntu/ trusty main multiverse" >> /etc/apt/sources.list && \
  echo "deb-src http://ftp.riken.jp/Linux/ubuntu/ trusty main multiverse" >> /etc/apt/sources.list && \
  apt-get update && apt-get upgrade -y && \
  apt-get install -qy openssh-server && \
  apt-get install -qy gcc make && \
  apt-get install -qy libtinfo-dev libx11-dev libxaw7-dev libgif-dev libjpeg-turbo8-dev libpng12-dev libtiff5-dev libxml2-dev librsvg2-dev libxft-dev libxpm-dev libgpm-dev libsm-dev libice-dev libxrandr-dev libxinerama-dev && \
  apt-get install -qy aspell wamerican && \
  apt-get install -qy fonts-takao fonts-takao-gothic fonts-takao-mincho fonts-takao-pgothic && \
  apt-get install -qy language-pack-ja-base language-pack-ja && \
  apt-get install -qy cmigemo libncurses5-dev exuberant-ctags && \
  apt-get install -qy sdic sdic-edict sdic-gene95 && \
  apt-get install -qy git libpython2.7-dev silversearcher-ag && \
  rm -rf /var/lib/apt/lists/*

RUN \
  mkdir /var/run/sshd && \
  adduser --disabled-password --gecos "Developer" --uid 1000 developer && \
  mkdir /home/developer/.ssh
ADD id_rsa.pub /home/developer/.ssh/authorized_keys
RUN \
  echo "lang en_US" > /home/developer/.aspell.conf && \
  chown -R developer:developer /home/developer && \
  echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
  chmod 0440 /etc/sudoers.d/developer && \
  update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" && \
  cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  echo "Asia/Tokyo" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
ENV LANG ja_jp.UTF-8

WORKDIR /home/developer
RUN \
  export emacs=emacs-24.4 && \
  wget -q -O - http://ftpmirror.gnu.org/emacs/${emacs}.tar.gz | tar zxf - && \
  mv ${emacs} .build_emacs && \
  (cd .build_emacs && ./configure && make install && make clean && cd ..)

RUN \
  export global=global-6.4 && \
  wget -q -O - http://ftpmirror.gnu.org/global/${global}.tar.gz | tar zxf - && \
  mv ${global} .build_global && \
  (cd .build_global && ./configure --with-exuberant-ctags=/usr/bin/ctags-exuberant && make install && make clean && cd ..) && \
  cp /usr/local/share/gtags/gtags.conf .globalrc && \
  export ecgtags_path=/usr/local/bin/ecgtags && \
  echo '#!/bin/bash' > ${ecgtags_path} && \
  echo 'gtags --gtagslabel=exuberant-ctags $*' >> ${ecgtags_path} && \
  chmod a+x ${ecgtags_path}

RUN \
  mkdir .build_pip && \
  (cd .build_pip && wget -q https://bootstrap.pypa.io/get-pip.py && python get-pip.py && cd ..)

RUN \
  pip install grip virtualenv flake8 && \
  export markdown_path=/usr/local/bin/markdown && \
  echo '#!/bin/bash' > ${markdown_path} && \
  echo 'set -eu' >> ${markdown_path} && \
  echo 'grip --gfm --export ${1} > /dev/null' >> ${markdown_path} && \
  echo 'cat ${1%.*}.html' >> ${markdown_path} && \
  chmod a+x ${markdown_path}

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
EXPOSE 22
