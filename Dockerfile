FROM gliderlabs/alpine
MAINTAINER PIN SHIH WANG <wpsteak@gmail.com>
# Based on https://github.com/automacaoiot/ESP8266-SDK-Docker/

RUN apk --update add build-base g++ make curl wget openssl-dev apache2-utils git libxml2-dev sshfs nodejs bash tmux python python-dev py-pip \
 && rm -f /var/cache/apk/*\
 && mkdir /workspace

WORKDIR /opt/Espressif

# VOLUME /workspace

# ------------------------------------------------------------------------------
# Install Xtensa GCC toolchain
# ------------------------------------------------------------------------------

# Download and install glibc compatability

ENV GLIBC_VERSION 2.25-r0

RUN apk add --update curl && \
  curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
  curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
  curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
  apk add glibc-bin.apk glibc.apk && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  rm -rf glibc.apk glibc-bin.apk /var/cache/apk/*

RUN cd /tmp && \
    mkdir -p /opt/Espressif/esp-open-sdk && \
    wget https://github.com/nodemcu/nodemcu-firmware/raw/master/tools/esp-open-sdk.tar.xz && \
    tar -Jxvf esp-open-sdk.tar.xz && \ 
    mv esp-open-sdk/xtensa-lx106-elf /opt/Espressif/esp-open-sdk/. && \
    rm esp-open-sdk.tar.xz
    # echo 'export PATH=/opt/Espressif/esp-open-sdk/xtensa-lx106-elf/bin:$PATH' >> /etc/profile.d/esp8266.sh 

# ------------------------------------------------------------------------------    
# Install Espressif NONOS SDK v2.0
# ------------------------------------------------------------------------------

RUN cd /tmp && \
    wget http://bbs.espressif.com/download/file.php?id=1690 -O sdk.zip && \
    unzip sdk.zip && \
    mv `pwd`/ESP8266_NONOS_SDK/ /opt/Espressif/esp-open-sdk/sdk && \
    rm sdk.zip

# ------------------------------------------------------------------------------    
# Install ESP Open RTOS
# ------------------------------------------------------------------------------
RUN git clone https://github.com/esp8266/source-code-examples.git \
  && git clone --recursive https://github.com/Superhouse/esp-open-rtos.git

# ------------------------------------------------------------------------------
# Set Environment
# ------------------------------------------------------------------------------

ENV PATH /opt/Espressif/esp-open-sdk/xtensa-lx106-elf/bin:$PATH
ENV XTENSA_TOOLS_ROOT /opt/Espressif/esp-open-sdk/xtensa-lx106-elf/bin
ENV SDK_BASE /opt/Espressif/esp-open-sdk/sdk
ENV FW_TOOL /opt/Espressif/esp-open-sdk/xtensa-lx106-elf/bin/esptool.py  

# ------------------------------------------------------------------------------
# Install ESP8266 Tools
# ------------------------------------------------------------------------------
# Install python-serial
RUN pip install pyserial

# Install esptool.py
RUN cd /tmp && \
    wget https://github.com/espressif/esptool/archive/master.zip && \
    unzip master.zip && \
    mv esptool-master /opt/Espressif/esp-open-sdk/esptool && rm master.zip

ENV PATH /opt/Espressif/esp-open-sdk/esptool/:$PATH%