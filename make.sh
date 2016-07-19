#!/bin/bash
set -e

DOCKER_IMAGE=esp_dev
ESP_HOME=/opt/Espressif

ESP_WORK_DIR="$ESP_HOME/esp-open-rtos/src/$(basename $PWD)"

PARAMS="$PARAMS -it --rm"
PARAMS="$PARAMS -v $PWD:$ESP_WORK_DIR"
PARAMS="$PARAMS -w $ESP_WORK_DIR"

eval docker run $PARAMS $DOCKER_IMAGE make $@

