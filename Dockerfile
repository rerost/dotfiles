FROM debian

RUN apt-get update && apt-get install -y \
  curl \
  git \
  sudo \
  build-essential

RUN useradd -m -s /bin/bash linuxbrew \
  && echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
USER linuxbrew

COPY . .

RUN ./install
