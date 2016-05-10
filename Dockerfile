FROM ubuntu:14.04
MAINTAINER PIN SHIH WANG <wpsteak@gmail.com>

RUN \
 apt-get update && \
 apt-get dist-upgrade -y && \
 apt-get install -y git autoconf build-essential gperf bison flex texinfo libtool libncurses5-dev wget gawk libc6-dev python-serial libexpat-dev unzip libtool screen tmux vim nano

 RUN \
  mkdir /home/wpsteak && \
  groupadd -r wpsteak -g 433  && \
  useradd -u 431 -r -g wpsteak -d /home/wpsteak -s /sbin/nologin -c "Docker image user" wpsteak  && \
  chown -R wpsteak:wpsteak /home/wpsteak && \
  adduser wpsteak sudo && \
  adduser wpsteak dialout && \
  echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


WORKDIR /opt/Espressif
RUN chown -R wpsteak /opt/Espressif
USER wpsteak

RUN git clone --recursive https://github.com/pfalcon/esp-open-sdk.git \
  && git clone https://github.com/esp8266/source-code-examples.git \
  && git clone --recursive https://github.com/Superhouse/esp-open-rtos.git \
  && cd /opt/Espressif/esp-open-sdk && make STANDALONE=n

ENV PATH /opt/Espressif/esp-open-sdk/xtensa-lx106-elf/bin:/opt/Espressif/esp-open-sdk/esptool/:$PATH
ENV XTENSA_TOOLS_ROOT /opt/Espressif/esp-open-sdk/xtensa-lx106-elf/bin
ENV SDK_BASE /opt/Espressif/esp-open-sdk/sdk

# Getting a USB device to show up in a Docker container on OS X
# https://gist.github.com/stonehippo/e33750f185806924f1254349ea1a4e68

# VirtualBox 5.0.16 Oracle VM VirtualBox Extension Pack
# http://download.virtualbox.org/virtualbox/5.0.16/Oracle_VM_VirtualBox_Extension_Pack-5.0.16-105871.vbox-extpack
