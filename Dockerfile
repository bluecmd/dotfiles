FROM ubuntu:21.10

RUN apt-get update && apt-get -y install \
  build-essential \
  autoconf \
  curl \
  apt-utils
RUN curl -L https://go.dev/dl/go1.17.6.linux-amd64.tar.gz | tar -zxvf - -C /usr/local/

RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Europe/Stockholm apt-get -y install \
  zsh \
  iproute2 \
  sudo \
  python3 \
  python3-venv \
  python3-pip \
  vim \
  dialog \
  terminfo \
  locales \
  tini \
  nmap \
  iputils-ping

RUN locale-gen --purge en_US.UTF-8
RUN useradd -u 1000 bluecmd -m
RUN chsh bluecmd -s /usr/bin/zsh
RUN gpasswd -a bluecmd sudo
RUN sed -i '/%sudo/d' /etc/sudoers && \
  echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
COPY .zshrc .vimrc  /home/bluecmd/
COPY .vim /home/bluecmd/.vim
COPY zshrc.local.docker /home/bluecmd/.zshrc.local

ENTRYPOINT ["/usr/bin/tini", "--"]
