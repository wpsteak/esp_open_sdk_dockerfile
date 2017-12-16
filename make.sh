#!/bin/bash
set -e

DOCKER_IMAGE=esp8266
ESP_HOME=/opt/Espressif
ESP_WORK_DIR="$ESP_HOME/esp-open-rtos/src/$(basename $PWD)"
# ESP_PORT="/dev/tty.SLAB_USBtoUART"
# ESP_PORT="/dev/tty.usbserial"
 ESP_PORT="/dev/tty.usbserial-00000000"
# ESP_PORT="/dev/tty.wchusbserial14110"


# PARAMS="$PARAMS -it --rm"
PARAMS="$PARAMS --rm"
PARAMS="$PARAMS -v $PWD:$ESP_WORK_DIR"
PARAMS="$PARAMS -w $ESP_WORK_DIR"
# PARAMS="$PARAMS --device=/dev/tty.SLAB_USBtoUART:/dev/USB0:rwm"

if [[ "$@" == "flash" ]]
then
  make flash ESPPORT=$ESP_PORT
elif [[ "$@" == "gdb" ]]
then
  eval docker run $PARAMS $DOCKER_IMAGE  xtensa-lx106-elf-gdb -x gdbcmds -b 115200
elif [[ "$@" == "debug" ]]
then
    # eval docker run $PARAMS $DOCKER_IMAGE make clean
    eval docker run $PARAMS $DOCKER_IMAGE make
    str=$(screen -ls | grep tty)
    array=$(echo $str|tr "." "\n")
    echo $str
    for V in $array  
    do  
    if [ $V -gt 0  ]  
    then  screen -S $V -X quit  
    fi
    done 
    make flash ESPPORT=$ESP_PORT
    screen $ESP_PORT 115200
else
    eval docker run $PARAMS $DOCKER_IMAGE make $@
fi
