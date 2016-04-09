FROM ubuntu:trusty
MAINTAINER KIYOHIRO ADACHI <kiyoad@da2.so-net.ne.jp>

ADD id_rsa.pub /tmp/authorized_keys

ENV DEBIAN_FRONTEND noninteractive
RUN \
  echo "deb http://ftp.riken.jp/Linux/ubuntu/ trusty main multiverse" >> /etc/apt/sources.list && \
  echo "deb-src http://ftp.riken.jp/Linux/ubuntu/ trusty main multiverse" >> /etc/apt/sources.list && \
  apt-get update && apt-get upgrade -y && \
  apt-get install -qy openssh-server && \
  apt-get install -qy language-pack-ja man-db manpages-ja manpages-ja-dev && \
  apt-get install -qy gcc make xz-utils && \
  apt-get install -qy libtinfo-dev libx11-dev libxaw7-dev libgif-dev libjpeg-turbo8-dev libpng12-dev libtiff5-dev libxml2-dev librsvg2-dev libxft-dev libxpm-dev libgpm-dev libsm-dev libice-dev libxrandr-dev libxinerama-dev libgnutls-dev libmagickwand-dev xaw3dg-dev libdbus-1-dev libgconf2-dev libotf-dev libm17n-dev && \
  apt-get install -qy aspell wamerican && \
  apt-get install -qy fonts-takao fonts-takao-gothic fonts-takao-mincho fonts-takao-pgothic && \
  apt-get install -qy cmigemo libncurses5-dev exuberant-ctags && \
  apt-get install -qy sdic sdic-edict sdic-gene95 && \
  apt-get install -qy libpython2.7-dev silversearcher-ag texinfo install-info && \
  apt-get install -qy libssl-dev libcurl4-openssl-dev tcl gettext

ENV INSTALL_USER developer
RUN \
  mkdir /var/run/sshd && \
  adduser --disabled-password --gecos "Developer" --uid 1000 ${INSTALL_USER} && \
  mkdir /home/${INSTALL_USER}/.ssh && \
  mv /tmp/authorized_keys /home/${INSTALL_USER}/.ssh/authorized_keys && \
  echo "lang en_US" > /home/${INSTALL_USER}/.aspell.conf && \
  chown -R ${INSTALL_USER}:${INSTALL_USER} /home/${INSTALL_USER} && \
  echo "${INSTALL_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${INSTALL_USER} && \
  chmod 0440 /etc/sudoers.d/${INSTALL_USER} && \
  update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" && \
  cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  echo "Asia/Tokyo" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

RUN \
  apt-get install -qy supervisor && \
  echo_supervisord_conf | sed -e 's/^nodaemon=false/nodaemon=true/' > /etc/supervisord.conf && \
  echo "[program:sshd]" >> /etc/supervisord.conf && \
  echo "command=/usr/sbin/sshd -D" >> /etc/supervisord.conf

EXPOSE 22
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

WORKDIR /home/${INSTALL_USER}
RUN \
  export emacs=emacs-24.5 && \
  wget -q -O - http://ftpmirror.gnu.org/emacs/${emacs}.tar.xz | tar xJf - && \
  mv ${emacs} .build_emacs && \
  (cd .build_emacs && ./configure && make install && make clean) && \
  echo 'export PATH=$PATH:~/.emacs.d/bin' >> .profile

RUN \
  export global=global-6.5.4 && \
  wget -q -O - http://ftpmirror.gnu.org/global/${global}.tar.gz | tar zxf - && \
  mv ${global} .build_global && \
  (cd .build_global && ./configure --with-exuberant-ctags=/usr/bin/ctags-exuberant && make install && make clean) && \
  cp /usr/local/share/gtags/gtags.conf .globalrc

RUN \
  mkdir .build_pip && \
  (cd .build_pip && wget -q https://bootstrap.pypa.io/get-pip.py && python get-pip.py) && \
  pip install grip virtualenv flake8 pygments

RUN \
  export git=2.8.1 && \
  wget -q -O - https://github.com/git/git/archive/v${git}.tar.gz | tar zxf - && \
  mv git-${git} .build_git && \
  (cd .build_git && make prefix=/usr/local && make prefix=/usr/local install && make clean)

RUN \
  export golang=go1.6 && \
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
  go get -u github.com/alecthomas/gometalinter && \
  /opt/go/bin/gometalinter --install --update

ENV REFRESHED_AT 2016-04-09
