#!/bin/bash

. ./common.sh
. ./format_config.sh

NETWORK_NAME="mail-service"
OUTPUT=`docker network inspect ${NETWORK_NAME}`
net_exists=$?
if [ "${net_exists}" != "0" ];then
    echo "create network "${NETWORK_NAME}
    docker network create --subnet=192.168.100.0/24 ${NETWORK_NAME}
fi
docker-compose up -d
docker-compose start
