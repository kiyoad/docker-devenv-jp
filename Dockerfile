FROM ubuntu:trusty
MAINTAINER KIYOHIRO ADACHI <kiyoad@da2.so-net.ne.jp>

ENV DEBIAN_FRONTEND noninteractive

RUN \
  echo "deb http://ftp.riken.jp/Linux/ubuntu/ trusty main multiverse" >> /etc/apt/sources.list && \
  echo "deb-src http://ftp.riken.jp/Linux/ubuntu/ trusty main multiverse" >> /etc/apt/sources.list && \
  apt-get update && apt-get upgrade -y && \
  apt-get install -qy openssh-server xz-utils && \
  apt-get install -qy gcc make && \
  apt-get install -qy libtinfo-dev libx11-dev libxaw7-dev libgif-dev libjpeg-turbo8-dev libpng12-dev libtiff5-dev libxml2-dev librsvg2-dev libxft-dev libxpm-dev libgpm-dev libsm-dev libice-dev libxrandr-dev libxinerama-dev libgnutls-dev libmagickwand-dev xaw3dg-dev libdbus-1-dev libgconf2-dev libotf-dev libm17n-dev && \
  apt-get install -qy aspell wamerican && \
  apt-get install -qy fonts-takao fonts-takao-gothic fonts-takao-mincho fonts-takao-pgothic && \
  apt-get install -qy language-pack-ja && \
  apt-get install -qy cmigemo libncurses5-dev exuberant-ctags && \
  apt-get install -qy sdic sdic-edict sdic-gene95 && \
  apt-get install -qy git libpython2.7-dev silversearcher-ag texinfo install-info && \
  apt-get install -qy libssl-dev libcurl4-openssl-dev tcl gettext && \
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
  export emacs=emacs-24.5 && \
  wget -q -O - http://ftpmirror.gnu.org/emacs/${emacs}.tar.xz | tar xJf - && \
  mv ${emacs} .build_emacs && \
  (cd .build_emacs && ./configure && make install && make clean && cd ..) && \
  echo 'export PATH=$PATH:~/.emacs.d/bin' >> .profile

RUN \
  export global=global-6.5.2 && \
  wget -q -O - http://ftpmirror.gnu.org/global/${global}.tar.gz | tar zxf - && \
  mv ${global} .build_global && \
  (cd .build_global && ./configure --with-exuberant-ctags=/usr/bin/ctags-exuberant && make install && make clean && cd ..) && \
  cp /usr/local/share/gtags/gtags.conf .globalrc

RUN \
  mkdir .build_pip && \
  (cd .build_pip && wget -q https://bootstrap.pypa.io/get-pip.py && python get-pip.py && cd ..) && \
  pip install grip virtualenv flake8 pygments

RUN \
  export golang=go1.5.2 && \
  wget -q -O - https://storage.googleapis.com/golang/${golang}.linux-amd64.tar.gz | tar -C /usr/local -zxf  - && \
  mkdir /opt/go && \
  echo 'export PATH=$PATH:/usr/local/go/bin:/opt/go/bin' >> .profile && \
  echo 'export GOPATH=/opt/go' >> .profile && \
  echo 'export PATH=$PATH:/usr/local/go/bin:/opt/go/bin' >> /root/.profile && \
  echo 'export GOPATH=/opt/go' >> /root/.profile && \
  export PATH=$PATH:/usr/local/go/bin && \
  export GOPATH=/opt/go && \
  go get -u github.com/rogpeppe/godef && \
  go get -u github.com/nsf/gocode && \
  go get -u github.com/dougm/goflymake && \
  go get -u github.com/jstemmer/gotags && \
  go get -u github.com/kisielk/errcheck && \
  go get -u golang.org/x/tools/cmd/goimports

RUN \
  export git=2.7.0 && \
  wget -q -O - https://github.com/git/git/archive/v${git}.tar.gz | tar zxf - && \
  mv git-${git} .build_git && \
  (cd .build_git && make prefix=/usr/local && make prefix=/usr/local install && make clean && cd ..)

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
EXPOSE 22

ENV REFRESHED_AT 2016-01-13
