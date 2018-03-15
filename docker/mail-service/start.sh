#!/bin/bash

. ./common.sh

IMAGE_MAIN=`read_package_config "mail-service" "image-main"`
IMAGE_MYSQL=`read_package_config "mail-service" "image-mysql"`
IMAGE_REDIS=`read_package_config "mail-service" "image-redis"`
DATA_ROOT="${DATA_DIR}/mail"
mkdir -p ${DATA_ROOT}
python format_config.py ${DATA_ROOT} ${IMAGE_MAIN} ${IMAGE_MYSQL} ${IMAGE_REDIS}

NETWORK_NAME="mail-service"
OUTPUT=`docker network inspect ${NETWORK_NAME}`
net_exists=$?
if [ "${net_exists}" != "0" ];then
    echo "create network "${NETWORK_NAME}
    docker network create --subnet=192.168.100.0/24 ${NETWORK_NAME}
fi
docker-compose up -d
docker-compose start
