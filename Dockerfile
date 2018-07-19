FROM ubuntu:16.04
MAINTAINER PIN SHIH WANG <wpsteak@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
 DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
 DEBIAN_FRONTEND=noninteractive apt-get install -y \
 git autoconf automake build-essential gperf bison flex texinfo libtool-bin libncurses5-dev wget gawk libc6-dev python2.7-dev python-serial unzip libtool screen tmux vim nano help2man

 RUN \
  mkdir /home/wp4 && \
  groupadd -r wp4 -g 433  && \
  useradd -u 431 -r -g wp4 -d /home/wp4 -s /sbin/nologin -c "Docker image user" wp4  && \
  chown -R wp4:wp4 /home/wp4 && \
  adduser wp4 sudo && \
  adduser wp4 dialout && \
  echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


WORKDIR /opt/Espressif
RUN chown -R wp4 /opt/Espressif
USER wp4

RUN git clone --recursive https://github.com/pfalcon/esp-open-sdk.git
RUN git clone https://github.com/wpsteak/esp_open_sdk_dockerfile.git
RUN cp -f /opt/Espressif/esp_open_sdk_dockerfile/140-mpc.sh /opt/Espressif/esp-open-sdk/crosstool-NG/scripts/build/companion_libs/
RUN cd /opt/Espressif/esp-open-sdk && make STANDALONE=n

ENV PATH /opt/Espressif/esp-open-sdk/xtensa-lx106-elf/bin:/opt/Espressif/esp-open-sdk/esptool/:$PATH
ENV XTENSA_TOOLS_ROOT /opt/Espressif/esp-open-sdk/xtensa-lx106-elf/bin
ENV SDK_BASE /opt/Espressif/esp-open-sdk/sdk

RUN git clone https://github.com/esp8266/source-code-examples.git \
  && git clone --recursive https://github.com/Superhouse/esp-open-rtos.git

# Getting a USB device to show up in a Docker container on OS X
# https://gist.github.com/stonehippo/e33750f185806924f1254349ea1a4e68

# VirtualBox 5.0.16 Oracle VM VirtualBox Extension Pack
# http://download.virtualbox.org/virtualbox/5.0.16/Oracle_VM_VirtualBox_Extension_Pack-5.0.16-105871.vbox-extpack
