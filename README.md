# Docker Image for building esp-open-rtos firmware
Use Docker as EPS8266 (Superhouse esp-open-rtos) build machine 

## Installation
1. Pull from docker hub

    docker pull wpinshih/esp8266:latest

1. clone this project from github

    git clone https://github.com/wpsteak/esp_open_sdk_dockerfile.git    

1. create a symbolic link to /usr/local/bin/ (OS X / Ubuntu)

    sudo ln -s {$PATH_YOU_CLONE}/make.sh /usr/local/bin/espmake

## How To use espmake

1. enter target folder

1. just build firmware
espmake

1. or you want to clean before make
espmake clean
