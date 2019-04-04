FROM ubuntu:16.04
MAINTAINER PIN SHIH WANG <wpsteak@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
 git autoconf automake build-essential gperf bison flex texinfo libtool-bin libncurses5-dev wget gawk libc6-dev python2.7-dev python-serial unzip libtool screen tmux vim nano help2man

WORKDIR /opt/Espressif

RUN git clone --recursive https://github.com/pfalcon/esp-open-sdk.git
RUN git clone https://github.com/wpsteak/esp_open_sdk_dockerfile.git
RUN cp -f /opt/Espressif/esp_open_sdk_dockerfile/140-mpc.sh /opt/Espressif/esp-open-sdk/crosstool-NG/scripts/build/companion_libs/

# https://stackoverflow.com/questions/17466017/how-to-solve-you-must-not-be-root-to-run-crosstool-ng-when-using-ct-ng
ENV CT_EXPERIMENTAL=y
ENV CT_ALLOW_BUILD_AS_ROOT=y
ENV CT_ALLOW_BUILD_AS_ROOT_SURE=y
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
