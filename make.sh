#!/bin/bash
set -e

DOCKER_IMAGE=esp_dev
ESP_HOME=/opt/Espressif
ESP_WORK_DIR="$ESP_HOME/esp-open-rtos/src/$(basename $PWD)"
ESP_PORT="/dev/tty.SLAB_USBtoUART"
# ESP_PORT="/dev/tty.wchusbserial14110"

PARAMS="$PARAMS -it --rm"
PARAMS="$PARAMS -v $PWD:$ESP_WORK_DIR"
PARAMS="$PARAMS -w $ESP_WORK_DIR"
# PARAMS="$PARAMS --device=/dev/tty.SLAB_USBtoUART:/dev/USB0:rwm"

if [[ "$@" == "flash" ]]
then
  make flash ESPPORT=$ESP_PORT
else

  if [[ "$@" == "debug" ]]
  then
    eval docker run $PARAMS $DOCKER_IMAGE make clean
    eval docker run $PARAMS $DOCKER_IMAGE make
    make flash ESPPORT=$ESP_PORT
    screen $ESP_PORT 115200
  else
    eval docker run $PARAMS $DOCKER_IMAGE make $@
  fi

fi
